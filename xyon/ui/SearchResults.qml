import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Item {
    property alias interactive: scrollView.enabled
    property alias model: resultsList.model

    ScrollView {
        id: scrollView
        anchors.fill: parent

        style: ScrollViewStyle {
            handle: Item {
                implicitWidth: 14
                implicitHeight: 26
                Rectangle {
                    color: "#494949"
                    anchors.fill: parent
                    anchors.leftMargin: 4
                    anchors.rightMargin: 4
                }
            }
            scrollBarBackground: Item {
                implicitWidth: 14
                implicitHeight: 26
            }
            decrementControl: Item{}
            incrementControl: Item{}
        }

        ListView {
            id: resultsList
            anchors.fill: parent
            delegate: Entry {
                anchors.left: parent.left
                anchors.leftMargin: 10
                height: 50
                width: parent.width - 20
                entry: object
            }
        }
    }
}
