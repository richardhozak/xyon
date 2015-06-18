import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
	width: 350
	height: 500
	color: "#242424"

    Item {
	    height: parent.height - addAllButton.height// - 30
	    width: parent.width
	    anchors.bottom: addAllButton.top

        ScrollView {
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.bottomMargin: 10

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
                decrementControl: Item {}
                incrementControl: Item {}
            }

            ListView {
                anchors.fill: parent
                model: controller.serviceManager.playlistList
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

    Button {
        id: addAllButton
        anchors.bottom: parent.bottom
        height: 25
        width: parent.width
        text: "Add all"
        style: ButtonStyle {
            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 25
                color: addAllButton.pressed ? Qt.lighter("#494949"): "#494949"
            }
            label: Component {
                Text {
                    text: addAllButton.text
                    clip: true
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.fill: parent
                    color: addAllButton.pressed ? "black" : "#dbdbdb"
                    font.pixelSize: addAllButton.height * 0.75
                }
            }
        }
        onClicked: controller.player.addPlaylist(controller.serviceManager.playlistList)
    }
}