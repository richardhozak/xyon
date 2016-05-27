import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
	width: 350
	height: 500
	color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "white"
        opacity: 0.1

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: 1
            border.color: "white"
        }
    }

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
                    implicitWidth: 9
                    implicitHeight: 26
                    Rectangle {
                        color: "white"
                        anchors.fill: parent
                        //anchors.leftMargin: 8
                        //anchors.rightMargin: 0
                        opacity: 0.25
                    }
                }
                scrollBarBackground: Item {
                    implicitWidth: 9
                    implicitHeight: 26
                    //color: "red"
                }
                decrementControl: Item{}
                incrementControl: Item{}
                transientScrollBars: true
            }

            ListView {
                anchors.fill: parent
                model: controller.serviceManager.playlistList
                spacing: 5
                delegate: Entry {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    height: 50
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    entry: object
                }
            }
        }
    }

    Button {
        id: addAllButton
        anchors.bottom: parent.bottom
        height: 25
        width: parent.width - 1
        text: "Add all the things!"
        style: ButtonStyle {
            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 25
                color: "black"//addAllButton.pressed ? Qt.lighter("#494949"): "#494949"
                opacity: 0.25
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
                    font.pixelSize: addAllButton.height * 0.5
                }
            }
        }
        onClicked: controller.player.addPlaylist(controller.serviceManager.playlistList)
    }
}