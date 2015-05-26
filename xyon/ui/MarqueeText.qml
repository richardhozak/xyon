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
        id: scrollingText
        color: "#dbdbdb"
        font.pixelSize: 16
    }

    Image {
        source: "/images/gradient.png"
        height: parent.height
        width: height
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        visible: scrollingText.width > parent.width
    }

    SequentialAnimation {
        id: animateText
        running: isScrolling && scrollingText.width > marqueeText.width
        loops: Animation.Infinite
        alwaysRunToEnd: false

        PropertyAction {
            target: scrollingText
            property: "x"
            value: 0
        }

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
            to: -(scrollingText.width - width) - 10
            duration: scrollingText.text.length * 10 * 2
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

    function stopAnimation() {
        animateText.alwaysRunToEnd = false;
        animateText.restart();
        animateText.stop();
    }

    function displayDuration() {
        console.log("text length", scrollingText.text.length)
        console.log("animation duration", 520 * (scrollingText.text.length) / 520 * 10);
    }
}

