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
    }


    Q_INVOKABLE void addEntry(const QString &name, int calories, int protein, int fat, int carbs) {
        QSqlQuery query;
        query.prepare("INSERT INTO products (name, calories, protein, fat, carbs) "
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

    Q_INVOKABLE QList<QVariantMap> fetchProducts() {
        QList<QVariantMap> products;
        QSqlQuery query("SELECT name, calories, protein, fat, carbs FROM products");

        while (query.next()) {
            QVariantMap product;
            product["name"] = query.value(0).toString();
            product["calories"] = query.value(1).toInt();
            product["protein"] = query.value(2).toInt();
            product["fat"] = query.value(3).toInt();
            product["carbs"] = query.value(4).toInt();
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

signals:
    void productsChanged();
};

#endif // PRODUCTSERVICE_H
