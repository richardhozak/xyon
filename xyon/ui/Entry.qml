import QtQuick 2.4

Item {
    property var entry: null

    Rectangle {
        id: typeStripe
        width: 5
        height: parent.height
        color: entry.type == "youtube_list" ? "crimson" : "dodgerblue"

        Component.onCompleted: {
            if (entry.type == "youtube_list") 
            {
                color = "crimson";
            }
            else if (entry.type == "youtube_audio" || entry.type == "soundcloud_audio")
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
        source: entry.img
        height: parent.height
        fillMode: Image.PreserveAspectFit
        anchors.left: typeStripe.right

        Rectangle {
            anchors.fill: parent
            color: thumbnailMouseArea.pressed ? Qt.lighter("#494949") : "#494949"
            opacity: thumbnailMouseArea.containsMouse ? 0.75 : 0

            Text {
                visible: thumbnailMouseArea.containsMouse
                text: entry.type == "youtube_list" ? "<" : "+"
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
                        controller.load_playlist(entry);
                        root.loadPlaylistClicked();
                    }
                    else if (entry.type == "youtube_audio")
                    {
                        controller.playlist.addAudioEntry(entry);    
                    }
                }
            }
        }
    }



    MarqueeText {
        id: marquee
        anchors.left: thumbnailImage.right
        anchors.leftMargin: 5
        //width: parent.width - thumbnail.width - 5
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 5
        text: entry.title
        isScrolling: hoverArea.containsMouse
    }



    Text {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        text: entry.type == "youtube_list" ? "Playlist" : entry.time
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
        onPressed: {
            //marquee.displayDuration();
            mouse.accepted = false;
            console.log("thumbnail width", thumbnailImage.width)
        }
        onExited: marquee.stopAnimation()
    }
}