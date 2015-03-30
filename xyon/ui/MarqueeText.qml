import QtQuick 2.0

Item {
    id: marqueeText
    height: scrollingText.height
    clip: true

    property alias text: scrollingText.text
    property int startPause: 750
    property int endPause: 750
    property bool isScrolling

    Text {
        id:scrollingText
        color: "#dbdbdb"
        font.pixelSize: 16
    }

//    MouseArea {
//        id:mouseArea
//        anchors.fill: parent
//        hoverEnabled: true
//    }

    SequentialAnimation {
        id: animateText
        running: isScrolling && scrollingText.width > marqueeText.width
        loops: Animation.Infinite
        alwaysRunToEnd: false
        onStopped: console.log("animation stopped")

        PauseAnimation {
            duration: startPause
        }

        PropertyAction {
            target: animateText
            property: "alwaysRunToEnd"
            value: true
        }

        NumberAnimation {
            target: scrollingText
            properties: "x"
            from: 0
            to: -(scrollingText.width - width)
            duration: scrollingText.text.length * 50//* 12 * 2
            //loops: Animation.Infinite
        }

        PauseAnimation {
            duration: endPause
        }

        PropertyAction {
            target: scrollingText; property: "x"; value: 0
        }

        PropertyAction {
            target: animateText
            property: "alwaysRunToEnd"
            value: false
        }
    }

    Component.onCompleted:  {
        console.log("length", scrollingText.text.length);
        console.log(500 / scrollingText.text.length);
        console.log("swidth", scrollingText.width)
        console.log("mwidth", width)
        console.log("delta width", scrollingText.width - width);
    }
}
