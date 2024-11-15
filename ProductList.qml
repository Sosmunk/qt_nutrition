import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ListView {
    property var products: productService.fetchProducts()
    model: products
    spacing: 10
    delegate: Product {
        width: parent.width
        productName: modelData.name
        protein: modelData.protein
        fat: modelData.fat
        carbohydrates: modelData.carbs
        calory: modelData.calories

        onRequestWeightInput: {
            weightInputDialog.calories = modelData.calories;
            weightInputDialog.productId = modelData.productId;
            weightInputDialog.open();
        }
    }

    Component.onCompleted: {
        productService.productsChanged.connect(refreshProducts)
    }

    function refreshProducts() {
        products = productService.fetchProducts()
    }
}







