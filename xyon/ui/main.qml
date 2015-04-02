import QtQuick 2.4
import QtQuick.Window 2.2
import QtMultimedia 5.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Window {
    visible: true
    //title: "AudioTest"
    width: 400
    height: 500
    id: window
    //flags: Qt.Drawer
    color: "dodgerblue"
    minimumWidth: width
    minimumHeight: height
    maximumWidth: width
    maximumHeight: height
    title: "Xyon"

    MainContent {
        width: parent.width
        height: parent.height - 50
        anchors.bottom: parent.bottom
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: search.percent / 2

        MouseArea {
            enabled: search.isExpanded
            height: parent.height
            width: 50
            anchors.right: parent.right

            hoverEnabled: search.isExpanded
            onPressed: {
                mouse.accepted = false;
                if (search.isExpanded) {
                    search.isExpanded = false;
                }
            }
        }
    }

    Search {
        id: search
        height: parent.height
        width: 350
        color: "#242424"
        x: isExpanded ? 0 : -width
        property bool isExpanded: false

        Behavior on x {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        Image {
            anchors.left: parent.right
            width: 50
            height: 50
            //color: "white"
            source: "/images/diamond.png"
            rotation: search.isExpanded ? 90 : -90


            Behavior on rotation {
                NumberAnimation { duration: 100 }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: search.isExpanded = !search.isExpanded
            }
        }
    }

    Component.onCompleted: {
        console.log("main completed");
        console.log("controller", controller);
        console.log("controller.playlist", controller.playlist);
        console.log("controller.playlist.items", controller.playlist.items);
    }

//    Button {
//        width: 25
//        height: 25
//        anchors.right: parent.right
//        text: "X"
//        onClicked: window.close()
//    }
}
