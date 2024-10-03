import QtQuick
import QtQuick.Controls
import QtQuick.Layouts



Item {
    id: root

    height: icon.height + icon.anchors.margins * 2
    property alias productName: nameText.text
    property string protein: "Б %1".arg(protein)
    property string fat : "Ж %1".arg(fat)
    property string carbohydrates: "У " + carbs.text
    property string calory: "Ккал " + calories.text

    Rectangle {
        anchors.fill: parent
        radius: 6
        color: "lightsteelblue"

        Image {
            id: icon
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 6
            width: 20
            height: 20
            source: "cupcake.png"

        }

            RowLayout {

                anchors {
                    left: icon.right
                    top: parent.top
                    leftMargin: 5
                    topMargin: 5
                }
                Rectangle {
                    id: indicator
                    width: 10
                    height: width
                    radius: width/2
                }

                Text {
                    id: nameText
                    font.bold: true
                    Layout.alignment: Qt.AlignVCenter
                }
            }

        }

        RowLayout {

            anchors {
                right: parent.right
                top: parent.top
                rightMargin: 5
                topMargin: 5
            }
            spacing: 10

            Text {
                id: proteins
                text: protein
                font.pixelSize: 14
            }

            Text {
                id: fats
                text: fat
                font.pixelSize: 14
            }

            Text {
                id: carbs
                text: carbohydrates
                font.pixelSize: 14
            }

            Text {
                id: calories
                text: calory
                font.pixelSize: 14
            }
        }
    }
