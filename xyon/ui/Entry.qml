import QtQuick 2.4

Item {
    property var entry: null

    Rectangle {
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
    }

    Image {
        id: thumbnailImage
        source: entry != null ? entry.img : ""
        height: parent.height
        fillMode: Image.PreserveAspectFit
        anchors.left: typeStripe.right

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
        width: parent.width
        height: 1
        color: "#494949"
        anchors.bottom: parent.bottom
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