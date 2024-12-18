import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts


Item {
    id: root

    height: icon.height + icon.anchors.margins * 3
    property alias productName: nameText.text
    property int productId;
    property string protein
    property string fat
    property string carbohydrates
    property string calory
    signal requestWeightInput


    Rectangle {
        anchors.fill: parent
        radius: 6
        color: "lightsteelblue"

        Button {
            id: icon
            text: "+"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 6
            width: 30
            height: 30
            font.pixelSize: 24
            font.bold: true
            property color defaultColor: "mediumseagreen"
            property color clickedColor: "coral"

            background: Rectangle {
                id: buttonBackground
                color: icon.defaultColor
                border.color: "darkgreen"
                border.width: 2
            }

            contentItem: Item {

                Text {
                    text: icon.text
                    color: "white"
                    font.bold: true
                    font.pixelSize: 24
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onEntered: buttonBackground.color = "seagreen"
                onExited: buttonBackground.color = icon.defaultColor
                onClicked: {
                    buttonBackground.color = (buttonBackground.color === icon.defaultColor) ? icon.clickedColor : icon.defaultColor
                    requestWeightInput()
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
                color: "yellow"
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
                color: "yellow"
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
                color: "yellow"
                font.pixelSize: 10
            }

            Text {
                id: carbs
                text: carbohydrates
                font.pixelSize: 14
            }


        }

        RowLayout {

            Layout.bottomMargin: 5
            Layout.alignment: Qt.AlignRight

            Text {
                id: ccal
                text: "ККАЛ"
                color: "yellow"
                font.pixelSize: 10
            }

            Text {
                id: calories
                text: calory
                font.pixelSize: 14
            }
        }
    }

}
