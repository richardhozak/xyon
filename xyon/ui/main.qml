import QtQuick 2.4
import QtQuick.Window 2.2
import QtMultimedia 5.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0

Window {
    id: window
    title: "Xyon"
    visible: true
    width: 400
    height: 500
    //flags: /*Qt.FramelessWindowHint | *///Qt.WindowMinimizeButtonHint //| Qt.WindowSystemMenuHint //| Qt.WA_TranslucentBackground//Qt.Dialog | Qt.CustomizeWindowHint | Qt.WindowCloseButtonHint | Qt.WindowTitleHint | Qt.WindowMinimizeButtonHint | Qt.FramelessWindowHint
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "transparent"
    minimumWidth: width
    minimumHeight: height
    maximumWidth: width
    maximumHeight: height
    x: controller.xPosition
    y: controller.yPosition

    Item {
        anchors.fill: parent

        MainContent {
            anchors.top: parent.top
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.left: search.right
            //onCloseClicked: window.close()
            //onMinimizeClicked: window.showMinimized()
        }
        
        Connections {
            target: controller.serviceManager
            onOpenPlaylistPage: playlistView.state = "playlist"
        }

        /*
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 50
            anchors.right: parent.right
            anchors.rightMargin: 50
            height: 100
            color: "transparent"

            Item {
                id: nextSelected
                width: 120
                height: 96
                //color: "transparent"
                opacity: 0

                Rectangle {
                    width: parent.width / 2
                    height: parent.height
                    color: "#faba00"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("clicked")
                }
            }

            Image {
                id: mask
                source: "/images/volume.png"
                width: 120
                height: 96
                opacity: 0
            }
            
            OpacityMask {
                anchors.fill: nextSelected
                source: nextSelected
                maskSource: mask
            }

            VolumeSlider {
                anchors.right: parent.right
            }
        }
        */

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: search.percent / 2

            MouseArea {
                anchors.fill: parent

                enabled: playlistView.state != "content"
                hoverEnabled: enabled

                onClicked: playlistView.state = "content"
            }
        }

        Search {
            id: search
            height: parent.height
            width: 350
            color: "#242424"
            anchors.left: playlistView.right
            isDisabled: playlistView.percentil != 0

            onLoadPlaylistClicked: playlistView.state = "playlist"

            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: playlistView.percentil / 2
                z: 2

                MouseArea {
                    anchors.fill: parent
                    enabled: playlistView.percentil != 0
                    hoverEnabled: enabled
                    onClicked: playlistView.state = "search"
                }
            }
        }

        Image {
            anchors.left: search.right
            anchors.top: search.top
            anchors.topMargin: 30
            width: 50
            height: 50
            source: "/images/diamond.png"
            property real angle: -(90 - search.percent * 180)

            rotation: angle
            
            MouseArea {
                anchors.fill: parent
                onClicked: playlistView.state = (playlistView.state == "content" ? "search" : "content")
            }
        }

        EntryPlaylist {
            id: playlistView
            height: parent.height
            width: 350
            color: "#242424"

            property real percentil: state == "playlist" ? 1 - (-x / 350) : 0

            state: "content"
            states: [
                State {
                    name: "content"
                    PropertyChanges { target: playlistView; x: -playlistView.width - search.width }
                },
                State {
                    name: "search"
                    PropertyChanges { target: playlistView; x: - search.width }
                },
                State {
                    name: "playlist"
                    PropertyChanges { target: playlistView; x: 0 }
                }
            ]

            Behavior on x {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }

            onStateChanged: console.log("state", state)
        }
    }

    Component.onCompleted: {
        console.log("main completed");
    }

    /*Rectangle {
        width: parent.width
        height: 30
        color: "black"
        opacity: 0.25
    }*/

    Item {
        id: titleArea
        height: 30
        width: parent.width
        
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.25
        }

        MouseArea {
            property point areaPosition: "0,0"
            id: windowDragArea
            anchors.fill: parent
            hoverEnabled: true
            onPositionChanged: {
                if (windowDragArea.pressed) {
                    controller.changePosition(areaPosition)
                }
            }
            onPressed: {
                areaPosition = Qt.point(mouse.x, mouse.y)
            }
        }

        /*Text {
            text: "Xyon"
            font.pixelSize: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            color: "aliceblue"
        }*/

        Image {
            source: "/images/title_small.png"
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 5
        }

        Row {
            anchors.right: parent.right
            anchors.top: parent.top
            
            SimpleButton {
                width: 30
                height: 30
                text: "▲"
                backgroundColor: "transparent"
                backgroundMouseOverColor: "white"
                backgroundMouseOverOpacity: 0.25
                backgroundPressedColor: "white"
                backgroundPressedOpacity: 0.25
                onClicked: controller.openPlaylist()
            }    

            SimpleButton {
                width: 30
                height: 30
                text: "▼"
                backgroundColor: "transparent"
                backgroundMouseOverColor: "white"
                backgroundMouseOverOpacity: 0.25
                backgroundPressedColor: "white"
                backgroundPressedOpacity: 0.25
                onClicked: controller.savePlaylist()
            }
            
            SimpleButton {
                width: 30
                height: 30
                text: "─"
                backgroundColor: "transparent"
                backgroundMouseOverColor: "white"
                backgroundMouseOverOpacity: 0.25
                backgroundPressedColor: "white"
                backgroundPressedOpacity: 0.25
                onClicked: window.showMinimized()//root.minimizeClicked()
            }    

            SimpleButton {
                width: 50
                height: 30
                text: "X"
                backgroundColor: "transparent"
                backgroundMouseOverColor: "white"
                backgroundMouseOverOpacity: 0.25
                backgroundPressedColor: "white"
                backgroundPressedOpacity: 0.25
                onClicked: window.close()//root.closeClicked()
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 1
        border.color: "#faba00"
    }
}
