import QtQuick 2.4
import QtQuick.Window 2.2
import QtMultimedia 5.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Window {
    id: window
    visible: true
    width: 400
    height: 500
    flags: Qt.Drawer
    color: "dodgerblue"
    minimumWidth: width
    minimumHeight: height
    maximumWidth: width
    maximumHeight: height
    title: "Xyon"

    Row {
        anchors.right: parent.right

        Button {
            enabled: controller.playlist.items.count > 0
            width: 25
            height: 25
            text: "▼"
            tooltip: "Save playlist"
            onClicked: controller.save_playlist()
        }

        Button {
            width: 25
            height: 25
            text: "▲"
            tooltip: "Load playlist"
            onClicked: controller.open_playlist()
        }
    }

    MainContent {
        width: parent.width
        height: parent.height - 50
        anchors.bottom: parent.bottom
        anchors.left: search.right
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: search.percent / 2

        MouseArea {
            anchors.fill: parent

            enabled: playlistView.state != "content"
            hoverEnabled: enabled

            onClicked: {
                //mouse.accepted = false;
                playlistView.state = "content";
            }
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

        rotation: angle//playlistView.state != "content" ? 90 : -90
        
        //onAngleChanged: console.log("angle", angle)
        /*
        Behavior on rotation {
            NumberAnimation { duration: 500 }
        }
        */
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
        /*
        console.log("controller", controller);
        console.log("controller.playlist", controller.playlist);
        console.log("controller.playlist.items", controller.playlist.items);
        */
    }

//    Button {
//        width: 25
//        height: 25
//        anchors.right: parent.right
//        text: "X"
//        onClicked: window.close()
//    }
}
