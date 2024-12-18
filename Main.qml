import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "js/DateUtils.js" as DateUtils

ApplicationWindow {

    property var products: productService.fetchProducts()
    property var dailyProducts: productService.fetchDailyProductEntries(DateUtils.getCurrentISODate())

    width: 420
    height: 780
    visible: true
    title: qsTr("Hello World")

    color: "#DEE4E7"


    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20

        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: "lightgray"
            border.color: "darkgray"

            Text {
                text: "Список продуктов"
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
                anchors.centerIn: parent
            }
        }

        RowLayout {
            spacing: 10

            Button {
                text: "Все продукты"
                onClicked: {
                    enableProductList()
                }
                Layout.fillWidth: true
            }

            Button {
                text: "Дневной рацион"
                Layout.fillWidth: true
                onClicked: {
                    enableDailyProducts()
                }
            }
        }

        Loader {
            id: productListLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            source: "ProductList.qml"
        }

        ColumnLayout {
            id: total
            visible: false
            Text {
                id: totalCalories
                text: "Всего калорий: 0"
            }

            RowLayout {
                Text {
                    id: totalCarbs
                    text: 'Углеводов:'
                }

                Text {
                    id: totalProteins
                    text: "Белков: "
                }

                Text {
                    id: totalFats
                    text: "Жиров: "
                }
            }

        }

        Button {
            text: "Добавить продукт"
            Layout.alignment: Qt.AlignHCenter
            width: parent.width * 0.8
            onClicked: {
                addProductDialog.open();
            }
        }


    }

    Dialog {
        id: addProductDialog
        title: "Добавить продукт"
        standardButtons: Dialog.Ok | Dialog.Cancel
        anchors.centerIn: parent

        ColumnLayout {
            spacing: 10
            anchors.margins: 20
            Layout.alignment: Qt.AlignHCenter

            TextField {
                id: nameInput
                placeholderText: "Название продукта"
            }
            TextField {
                id: caloriesInput
                placeholderText: "Калории"
                inputMethodHints: Qt.ImhDigitsOnly
            }
            TextField {
                id: proteinInput
                placeholderText: "Белки"
                inputMethodHints: Qt.ImhDigitsOnly
            }
            TextField {
                id: fatInput
                placeholderText: "Жиры"
                inputMethodHints: Qt.ImhDigitsOnly
            }
            TextField {
                id: carbsInput
                placeholderText: "Углеводы"
                inputMethodHints: Qt.ImhDigitsOnly

            }
        }

        onAccepted: {
            productService.addEntry(
                        nameInput.text,
                        parseInt(caloriesInput.text) ? parseInt(caloriesInput.text) : 0,
                        parseInt(proteinInput.text ? parseInt(proteinInput.text) : 0),
                        parseInt(fatInput.text) ? parseInt(fatInput.text) : 0,
                        parseInt(carbsInput.text ? parseInt(carbsInput.text) : 0)
                        );

            clearInputs();

        }
    }

    Dialog {
        id: weightInputDialog
        title: "Добавить продукт"
        standardButtons: Dialog.NoButton
        width: parent.width * 0.7
        modal: true
        anchors.centerIn: parent

        property int calories: 0
        property int productId: 0

        ColumnLayout {

            width: parent.width
            spacing: 10
            anchors.margins: 20

            TextField {
                id: weightInput
                anchors.margins: 10
                placeholderText: "Вес (гр.)"
                inputMethodHints: Qt.ImhDigitsOnly
                onTextChanged: calculateCalories()
                Layout.alignment: Qt.AlignHCenter

            }

            Text {
                id: resultText
                text: "Калорий: 0"
                font.pixelSize: 16
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                Button {
                    text: "Добавить"
                    onClicked: {
                        productService.addDailyProductEntry(
                                    weightInputDialog.productId,
                                    parseInt(weightInput.text),
                                    DateUtils.getCurrentISODate()
                                    );
                        weightInputDialog.close();
                        weightInput.clear();
                    }
                }

                Button {
                    text: "Отмена"
                    onClicked: {
                        weightInputDialog.close()
                        weightInput.clear()
                    }
                }
            }
        }
    }

    function clearInputs() {

        nameInput.clear();
        caloriesInput.clear();
        proteinInput.clear();
        fatInput.clear();
        carbsInput.clear();
    }


    function calculateCalories() {
        resultText.text = "Калорий: " + getDialogCalories().toFixed(2);
    }

    function getDialogCalories() {
        var weight = parseInt(weightInput.text) || 0;
        return parseInt((weight / 100) * weightInputDialog.calories);
    }

    function enableDailyProducts() {
        productListLoader.source = "DailyProducts.qml"
        total.visible = true
    }
    function enableProductList() {

        total.visible = false
        productListLoader.source = "ProductList.qml"
    }
}
