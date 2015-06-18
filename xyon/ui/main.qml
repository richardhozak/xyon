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
    height: 500// + 25
    //flags: Qt.ToolTip//Qt.FramelessWindowHint | Qt.Window
    color: "transparent"
    minimumWidth: width
    minimumHeight: height
    maximumWidth: width
    maximumHeight: height
    x: controller.xPosition
    y: controller.yPosition

    /*SimpleButton {
        width: 25
        height: 25
        text: "<"
        onClicked: {
            pageList.prevPage()
        }
    }

    SimpleButton {
        width: 25
        height: 25
        text: ">"
        anchors.left: parent.left
        anchors.leftMargin: 25

        onClicked: {
            pageList.nextPage()
        }
    }*/
    
    PageList {
        id: pageList
        anchors.fill: parent
        //anchors.topMargin: 25

        page: "Player"
        pages: ["Playlist", "Search", "Player", "Settings"]
    }

    /*Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 1
        border.color: "#faba00"
    }*/
}
