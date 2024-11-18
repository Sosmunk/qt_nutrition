import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts


Item {
    id: root

    height: icon.height + icon.anchors.margins * 2
    property alias productName: nameText.text
    property int dailyProductId
    property int productId;
    property string protein
    property string fat
    property string carbohydrates
    property string calory
    property string weight
    signal requestDeleteProduct


    Rectangle {
        anchors.fill: parent
        radius: 6
        color: "beige"

        Button {
            id: icon
            text: "-"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 10
            width: 30
            height: 30
            font.pixelSize: 24
            font.bold: true
            property color defaultColor: "darkred"
            property color clickedColor: "darkred"

            background: Rectangle {
                id: buttonBackground
                color: icon.defaultColor
                border.color: "black"
                border.width: 2
            }

            Text {
                text: icon.text
                color: "green"
                font.bold: true
                font.pixelSize: 24
                fontSizeMode: Text.Fit
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                onEntered: buttonBackground.color = "black"
                onExited: buttonBackground.color = icon.defaultColor
                onClicked: {
                    productService.removeDailyProduct(dailyProductId)
                    buttonBackground.color = (buttonBackground.color === icon.defaultColor) ? icon.clickedColor : icon.defaultColor
                }

            }
        }

        RowLayout {
            anchors {
                left: icon.right
                top: parent.top
                leftMargin: 5
                topMargin: 5
            }

            Text {
                id: nameText
                Layout.maximumWidth: 100
                font.bold: true
                Layout.alignment: Qt.AlignVCenter
                wrapMode: Text.WordWrap
            }


        }

    }
    ColumnLayout {

        anchors {
            right: parent.right
            top: parent.top
            rightMargin: 5
            topMargin: 5
        }

        RowLayout {
            spacing: 10

            Text {
                id: p
                text: "Б"
                color: "black"
                font.pixelSize: 10
            }
            Text {
                id: proteins
                text: protein
                font.pixelSize: 14
            }
            Text {
                id: f
                text: "Ж"
                color: "black"
                font.pixelSize: 10
            }

            Text {
                id: fats
                text: fat
                font.pixelSize: 14
            }

            Text {
                id: c
                text: "У"
                color: "black"
                font.pixelSize: 10
            }

            Text {
                id: carbs
                text: carbohydrates
                font.pixelSize: 14
            }


        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            Layout.bottomMargin: 5


            Text {
                id: ccal
                text: "ККАЛ"
                color: "black"
                font.pixelSize: 10
            }

            Text {
                id: calories
                text: calory
                font.pixelSize: 14
            }

            Text {
                id: weightText
                text: "Гр."
                font.pixelSize: 14
            }
            Text {
                id: weightValue
                text: weight
                font.pixelSize: 14
            }
        }
    }

}



