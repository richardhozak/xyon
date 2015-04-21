import QtQuick 2.4
import QtQuick.Window 2.2
import QtMultimedia 5.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0

Window {
    id: window
    visible: true
    width: 400
    height: 500
    flags: Qt.Dialog | Qt.CustomizeWindowHint | Qt.WindowCloseButtonHint | Qt.WindowTitleHint | Qt.WindowMinimizeButtonHint
    //flags: Qt.Dialog
    color: "dodgerblue"
    minimumWidth: width
    minimumHeight: height
    maximumWidth: width
    maximumHeight: height
    title: "Xyon"

    MainContent {
        anchors.top: parent.top
        width: parent.width
        //height: parent.height - 50
        anchors.bottom: parent.bottom
        anchors.left: search.right
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
        //onPercentChanged: console.log("percent", percent)
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
        width: 50
        height: 50
        //color: "white"
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

        onPercentilChanged: console.log("percentil", percentil)

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

    Component.onCompleted: {
        console.log("main completed");
    }
}
