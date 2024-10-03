import QtQuick
import QtQuick.Controls
import QtQuick.Layouts



Window {

    property var products: productService.fetchProducts()
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

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: products
            spacing: 10
            delegate: Product {
                width: parent.width
                productName: modelData.name
                protein: modelData.protein
                fat: modelData.fat
                carbohydrates: modelData.carbs
                calory: modelData.calories
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


    function refreshProducts() {
        products = productService.fetchProducts()
    }

    function clearInputs() {

        nameInput.clear();
        caloriesInput.clear();
        proteinInput.clear();
        fatInput.clear();
        carbsInput.clear();
    }


    Component.onCompleted: {
        productService.productsChanged.connect(refreshProducts)
    }
}
