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
    //aflags: Qt.WA_NoSystemBackground
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "transparent"
    minimumWidth: width
    minimumHeight: height
    maximumWidth: width
    maximumHeight: height
    x: controller.xPosition
    y: controller.yPosition

    Connections {
        target: controller
        onMinimizeRequested: window.showMinimized()
    }

    /*Rectangle {
        id: fillBackground
        anchors.fill: parent
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: fillBackground.width
                height: fillBackground.height
                Rectangle {
                    anchors.centerIn: parent
                    width: fillBackground.width
                    height: fillBackground.height
                    radius: 5
                }
            }
        }
    }*/

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
    
    /*Image {
        id: img
        anchors.fill: parent
        source: "/images/background_noice.png"
        opacity: 1
        visible: false

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: pageList.width
                height: pageList.height
                Rectangle {
                    anchors.centerIn: parent
                    width: pageList.width
                    height: pageList.height
                    radius: 5
                }
            }
        }
    }*/

    /*Image {
        source: "/images/parallax_background.png"
        x: -((Math.abs(pageList.rowX) / pageList.rowWidth) * width)
    }*/

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: {
            if (pressed) {
                controller.changePosition(Qt.point(mouse.x, mouse.y))
            }
        }
    }
    
    PageList {
        id: pageList
        height: 500
        width: 400
        anchors.centerIn: parent
        page: "Player"
        pages: ["Playlist", "Search", "Player", "Settings"]

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: pageList.width
                height: pageList.height
                Rectangle {
                    anchors.centerIn: parent
                    width: pageList.width
                    height: pageList.height
                    radius: 5
                }
            }
        }
    }

    /*Row {
        Button {
            width: 25
            height: 25
            onClicked: pageList.previousPage()
        }

        Button {
            width: 25
            height: 25
            onClicked: pageList.nextPage()
        }

        Text {
            text: pageList.page
        }
    }*/

    Rectangle {
        anchors.fill: parent
        border.width: 1
        border.color: "black"
        radius: 5
        color: "transparent"
        opacity: 0.25
    }



    /*Column {
        anchors.centerIn: parent
        width: parent.width
        Slider {
            id: refSlider
            maximumValue: 156
            minimumValue: 0
            width: parent.width
        }

        Slider {
            id: valueSlider
            maximumValue: 98
            minimumValue: 0
            width: parent.width
            value: refSlider.value * (maximumValue / refSlider.maximumValue)
        }
    }*/


    /*Rectangle {
        id: mask
        anchors.fill: parent
        color: "black"
        radius: 20
        border.width: 20
        visible: true
    }*/

    /*OpacityMask {
        anchors.fill: pageList
        source: pageList
        maskSource: mask
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            pageList.nextPage()
        }
    }*/

    /*Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 1
        border.color: "#faba00"
    }*/

    Component.onCompleted: controller.extendFrame()
}
