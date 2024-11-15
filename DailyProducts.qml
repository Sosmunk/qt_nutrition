import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "js/DateUtils.js" as DateUtils

ListView {
    property var dailyProducts: productService.fetchDailyProductEntries(DateUtils.getCurrentISODate())
    model: dailyProducts
    spacing: 10
    delegate: DailyProduct {
        width: parent.width
        productName: modelData.name
        protein: modelData.protein
        fat: modelData.fat
        carbohydrates: modelData.carbs
        calory: modelData.calories

        // onRequestWeightInput: {
        //     weightInputDialog.calories = modelData.calories;
        //     weightInputDialog.productId = modelData.productId;
        //     weightInputDialog.open();
        // }
    }

    Component.onCompleted: {
        productService.dailyProductsChanged.connect(refreshDailyProducts)
    }


    function refreshDailyProducts() {
        dailyProducts = productService.fetchDailyProductEntries(DateUtils.getCurrentISODate())
    }
}


