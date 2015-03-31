import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {

    property real percent: 1 - (x / -width)

    //onPercentChanged: console.log("percentil", percent)

    TextField {
        id: searchField
        width: parent.width - 20
        height: 32
        font.pixelSize: 20

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 10

        placeholderText: "Search..."

        style: TextFieldStyle {
            textColor: "black"
            background: Rectangle {
                radius: 2
                implicitWidth: 100
                implicitHeight: 24
                border.color: "#494949"
                border.width: 1
                color: "#dbdbdb"
            }
        }

        onAccepted: controller.search(text)
    }

    Item {
        id: searchResultsContainer
        anchors.top: searchField.bottom
        width: parent.width
        height: parent.height - searchField.height - 10 - loadMoreButton.height

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
                decrementControl: Item{}
                incrementControl: Item{}
            }

            ListView {
                anchors.fill: parent
                model: controller.searchlist
                //spacing: 5
                delegate: Item {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    height: 50
                    width: parent.width - 20
                    //clip: true

                    MarqueeText {
                        id: marquee
                        anchors.left: addButton.right
                        anchors.leftMargin: hoverArea.containsMouse ? 5 : 0
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        text: object.title
                        width: parent.width - (hoverArea.containsMouse ? 45 : 0)
                        isScrolling: hoverArea.containsMouse
                    }

//                    Text {
//                        anchors.left: addButton.right
//                        anchors.leftMargin: hoverArea.containsMouse ? 5 : 0
//                        anchors.top: parent.top
//                        anchors.topMargin: 5
//                        text: object.title
//                        color: "#dbdbdb"
//                        font.pixelSize: 16
//                        elide: Text.ElideRight
//                        width: parent.width - addButton.width - (hoverArea.containsMouse ? 5 : 0)
//                    }
                    Text {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        text: object.time
                        color: "#dbdbdb"
                        font.pixelSize: 16

                        Rectangle {
                            width: parent.width
                            height: 5
                            color: "#494949"
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: -5
                        }
                    }

                    Rectangle {
                        id: addButton
                        width: hoverArea.containsMouse ? 40 : 0
                        height: parent.height
                        color: addMouseArea.pressed ? Qt.lighter("#494949") : "#494949"
                        clip: true

                        Text {
                            text: "+"
                            font.pixelSize: parent.height / 2
                            anchors.centerIn: parent
                            color: "#dbdbdb"
                        }

                        MouseArea {
                            id: addMouseArea
                            anchors.fill: parent
                            onClicked: {
                                console.log(object);
                                controller.playlist.addAudioEntry(object);
                            }
                        }

                        Behavior on width {
                            id: addBehavior
                            NumberAnimation { duration: 50 }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#494949"
                        anchors.bottom: parent.bottom
                    }

                    MouseArea {
                        id: hoverArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onPressed: {
                            marquee.displayDuration();
                            mouse.accepted = false
                        }
                        onExited: marquee.stopAnimation()
                    }
                }
            }
        }
    }

    Button {
        id: loadMoreButton
        anchors.top: searchResultsContainer.bottom
        height: 25
        width: parent.width
        text: "Load more"
        visible: controller.searchlist.count > 0
        style: ButtonStyle {
            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 25
                //border.width: control.activeFocus ? 2 : 1
                //border.color: loadMoreButton.pressed ? "#dbdbdb" : "#494949"
                color: loadMoreButton.pressed ? Qt.lighter("#494949"): "#494949"
            }
            label: Component {
                Text {
                    text: loadMoreButton.text
                    clip: true
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.fill: parent
                    color: loadMoreButton.pressed ? "black" : "#dbdbdb"
                }
            }
        }
        onClicked: controller.load_more()
    }

    //                    Rectangle {
    //                        width: 30
    //                        height: 30
    //                        anchors.left: parent.left
    //                        anchors.bottom: parent.bottom
    //                        color: "transparent"

    //                        Text {
    //                            text: "+"
    //                            font.pixelSize: parent.width * 0.75
    //                            color: "white"
    //                            anchors.centerIn: parent
    //                        }
    //                    }



    //    Rectangle {
    //        anchors.top: parent.top
    //        anchors.left: parent.left
    //        anchors.topMargin: 10
    //        anchors.leftMargin: 10
    //        color: "black"
    //        width: parent.width - 20
    //        height: 25

    //        TextInput {
    //            id: input
    //            anchors.fill: parent
    //            clip: true
    //            color: "white"
    //            height: parent.height
    //            anchors.verticalCenter: parent.verticalCenter
    //        }
    //    }


}

