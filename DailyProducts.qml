import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "js/DateUtils.js" as DateUtils

    ListView {
        property var dailyProducts: productService.fetchDailyProductEntries(DateUtils.getCurrentISODate())
        anchors.fill: parent
        clip: true
        model: dailyProducts
        spacing: 10
        delegate: DailyProduct {
            width: parent.width
            productName: modelData.name
            protein: calcByWeight(modelData.amount, modelData.protein)
            fat: calcByWeight(modelData.amount, modelData.fat)
            carbohydrates:  calcByWeight(modelData.amount, modelData.carbs)
            calory: calcByWeight(modelData.amount, modelData.calories)
            weight: modelData.amount
            dailyProductId: modelData.id
        }

        Component.onCompleted: {
            productService.dailyProductsChanged.connect(refreshDailyProducts)
            calculateDailyTotals()
        }

        function refreshDailyProducts() {
            dailyProducts = productService.fetchDailyProductEntries(DateUtils.getCurrentISODate())
            calculateDailyTotals()
        }

        function calcByWeight(amount, value) {
            return Math.ceil((amount/100) * value)
        }

        function calculateDailyCalories() {
            const totalCal = dailyProducts.reduce((res, prod) => res + calcByWeight(prod.amount, prod.calories), 0);
            totalCalories.text = "Всего калорий: " + totalCal
        }

        function calculateDailyTotals() {
            calculateDailyCalories()
            totalCarbs.text = "Углеводов: " + calculateDailyProperty("carbs")
            totalProteins.text = "Белков: " + calculateDailyProperty("protein")
            totalFats.text = "Жиров: " + calculateDailyProperty("fat")
        }

        function calculateDailyProperty(prop) {
            return dailyProducts.reduce((res, prod) => res + calcByWeight(prod.amount, prod[prop]), 0);
        }

    }



