#ifndef PRODUCTSERVICE_H
#define PRODUCTSERVICE_H

#include <QObject>
#include <QSqlQuery>
#include <QSqlError>
#include <QDate>

class ProductService : public QObject
{
    Q_OBJECT
public:
    explicit ProductService(QObject *parent = nullptr);

    void initDatabase() {
        QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
        db.setDatabaseName("nutrition_db.db");

        if (!db.open()) {
            qDebug() << "Error: Unable to open database" << db.lastError();
            return;
        }

        QSqlQuery query;
        query.exec("CREATE TABLE IF NOT EXISTS products ("
                   "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                   "name TEXT, calories INTEGER, protein INTEGER,"
                   " fat INTEGER, carbs INTEGER)");

        query.exec("CREATE TABLE IF NOT EXISTS daily_products ("
                   "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                   "product_id INTEGER, "
                   "amount INTEGER, "
                   "date_added DATE, "
                   "FOREIGN KEY(product_id) REFERENCES products(id))");
    }


    Q_INVOKABLE void addEntry(const QString &name, int calories, int protein, int fat, int carbs) {
        QSqlQuery query;
        query.prepare("INSERT INTO products (name, calories, protein, fat, carbs)"
                      "VALUES (:name, :calories, :protein, :fat, :carbs)");
        query.bindValue(":name", name);
        query.bindValue(":calories", calories);
        query.bindValue(":protein", protein);
        query.bindValue(":fat", fat);
        query.bindValue(":carbs", carbs);

        if (!query.exec()) {
            qDebug() << "Failed to insert data:" << query.lastError();
        }

        emit productsChanged();
    }


    Q_INVOKABLE void addDailyProductEntry(int productId, int amount, const QString date) {
        QSqlQuery query;
        qDebug() << "Product Id:" << productId;
        qDebug() << "amount:" << amount;
        qDebug() << "date:" << date;
        query.prepare("INSERT INTO daily_products (product_id, amount, date_added)"
                      "VALUES (:product_id, :amount, :date_added)");
        query.bindValue(":product_id", productId);
        query.bindValue(":amount", amount);
        query.bindValue(":date_added", date);

        if (!query.exec()) {
            qDebug() << "Failed to insert product entry:" << query.lastError();
        }

        emit dailyProductsChanged();
    }

    Q_INVOKABLE QList<QVariantMap> fetchProducts() {
        QList<QVariantMap> products;
        QSqlQuery query("SELECT id, name, calories, protein, fat, carbs FROM products");

        while (query.next()) {
            QVariantMap product;
            product["productId"] = query.value(0).toString();
            product["name"] = query.value(1).toString();
            product["calories"] = query.value(2).toInt();
            product["protein"] = query.value(3).toInt();
            product["fat"] = query.value(4).toInt();
            product["carbs"] = query.value(5).toInt();
            products.append(product);
        }

        if (query.lastError().isValid()) {
            qDebug() << "Error fetching products:" << query.lastError();
        }

        qDebug() << "Fetching products" << products;

        for (int i = 0; i < products.length(); i++) {
            qDebug() << products[i]["name"];
        }

        return products;
    }

    Q_INVOKABLE QList<QVariantMap> fetchDailyProductEntries(const QString &date) {
        QList<QVariantMap> dailyProducts;
        QSqlQuery query;
        query.prepare("SELECT p.name, dn.amount, p.calories, p.protein, p.fat, p.carbs, dn.id, p.id "
                      "FROM daily_products dn "
                      "JOIN products p ON dn.product_id = p.id "
                      "WHERE dn.date_added = :date_added");
        query.bindValue(":date_added", date);

        if (!query.exec()) {
            qDebug() << "Error fetching daily nutrition data:" << query.lastError();
        }

        while (query.next()) {
            QVariantMap nutrition;
            nutrition["name"] = query.value(0).toString();
            nutrition["amount"] = query.value(1).toInt();
            nutrition["calories"] = query.value(2).toInt();
            nutrition["protein"] = query.value(3).toInt();
            nutrition["fat"] = query.value(4).toInt();
            nutrition["carbs"] = query.value(5).toInt();
            nutrition["id"] = query.value(6).toInt();
            nutrition["productId"] = query.value(7).toInt();
            dailyProducts.append(nutrition);
        }

        return dailyProducts;
    }

signals:
    void productsChanged();
    void dailyProductsChanged();
};

#endif // PRODUCTSERVICE_H
