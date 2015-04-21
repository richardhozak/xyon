import QtQuick 2.0

Item {
    id: root

    property string source: ""
    property string sourcePressed: ""
    property alias pressed: buttonArea.pressed
    signal clicked

    Image {
        id: buttonImage
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        opacity: root.enabled ? (buttonArea.containsMouse && !buttonArea.pressed ? 0.75 : 1) : 0.5
        smooth: true
        source: buttonArea.pressed ? root.sourcePressed : root.source
    }

    MouseArea {
        id: buttonArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
