import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: button

    property alias source: buttonImage.source
    property real size: 75
    property alias pressed: buttonArea.pressed
    property real ratio: 1
    signal clicked
    property bool isMouseOver

    color: buttonArea.pressed ? "white" : "transparent"
    width: size
    height: size
    radius: size
    border.width: 3
    border.color: buttonArea.pressed || buttonArea.containsMouse ? "#343434" : "white"

    opacity: enabled ? 1 : 0.5

    Image {
        id: buttonImage
        width: parent.width * button.ratio
        height: parent.height * button.ratio
        anchors.centerIn: parent
        smooth: true


    }

    ColorOverlay {
        anchors.fill: buttonImage
        source: buttonImage
        color: button.border.color
    }

    MouseArea {
        id: buttonArea
        anchors.fill: parent
        onClicked: button.clicked()
        hoverEnabled: true

        function contains(x, y) {
            var area = buttonArea;
            var d = (area.width / 2);
            var dx = (x - area.width / 2);
            var dy = (y - area.height / 2);
            return (d * d > dx * dx + dy * dy);
        }
    }
}
