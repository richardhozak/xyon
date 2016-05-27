import QtQuick 2.4
import QtGraphicalEffects 1.0

Item {
    id: root
    property var entry: null

    signal clicked()

    /*Rectangle {
        id: typeStripe
        width: 5
        height: parent.height

        Component.onCompleted: {
            if (entry.type == "youtube_list") 
            {
                color = "crimson";
            }
            else if (entry.type == "youtube_track" || entry.type == "soundcloud_track")
            {
                color = "dodgerblue";
            }
            else
            {
                color = "pink";
            }
        }
    }*/

    Image {
        id: thumbnailImage
        source: entry != null ? entry.img : ""
        height: parent.height
        fillMode: Image.PreserveAspectFit
        //anchors.left: typeStripe.right

        Rectangle {
            anchors.fill: parent
            color: thumbnailMouseArea.pressed ? Qt.lighter("#494949") : "#494949"
            opacity: thumbnailMouseArea.containsMouse ? 0.75 : 0

            Text {
                visible: thumbnailMouseArea.containsMouse
                text: entry != null ? (entry.type == "youtube_list" ? "<" : "+") : ""
                font.pixelSize: parent.height * 0.65
                anchors.centerIn: parent
                color: thumbnailMouseArea.pressed ? "black" : "white"
            }

            MouseArea {
                id: thumbnailMouseArea
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    root.clicked()
                    console.log("clicked", entry.type, entry.url);
                    if (entry.type == "youtube_list")
                    {
                        controller.serviceManager.loadPlaylist(entry);
                    }
                    else if (entry.type == "youtube_track" || entry.type == "soundcloud_track")
                    {
                        controller.player.addTrack(entry);
                    }
                }
            }
        }

        /*layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: thumbnailImage.width
                height: thumbnailImage.height
                Rectangle {
                    anchors.centerIn: parent
                    width: thumbnailImage.width
                    height: thumbnailImage.height
                    radius: 10
                }
            }
        }*/

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: thumbnailImage.width
                height: thumbnailImage.height
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    radius: 10
                    opacity: 0.5
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width - 2
                    height: parent.height - 2
                    radius: 10
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: "transparent"
            border.color: "black"
            border.width: 1
            opacity: 0.25
        }
    }

    MarqueeText {
        id: marquee
        anchors.left: thumbnailImage.right
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 5
        text: entry != null ? entry.title : ""
        isScrolling: hoverArea.containsMouse
    }

    Text {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        text: entry != null ? (entry.type == "youtube_list" ? "Playlist" : entry.time) : ""
        color: "white"
        font.pixelSize: 16
        font.weight: Font.Light

        Rectangle {
            width: parent.width
            height: 4
            color: "black"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -4
            opacity: 0.25
        }
    }
    
    Rectangle {
        width: parent.width - thumbnailImage.width + 10
        height: 1
        color: "black"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        opacity: 0.25
    }

    MouseArea {
        id: hoverArea
        anchors.right: parent.right
        height: parent.height
        width: parent.width - thumbnailImage.width
        hoverEnabled: true
        onExited: marquee.stopAnimation()
    }
}