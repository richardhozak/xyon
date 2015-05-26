import QtQuick 2.3
import QtMultimedia 5.4

Item {
	id: root

    property var entry: null
    property int trackIndex: -1

    readonly property bool isPlaying: controller.player.playlist.currentIndex == index && controller.player.state != MediaPlayer.StoppedState
    readonly property bool isSelected: controller.player.playlist.currentIndex == index
    readonly property bool containsMouse: mouseArea.containsMouse || butt.containsMouse

    signal clicked()
    signal deleteClicked()

	width: 400
    height: visible ? 25 : 0
    visible: entry != null
    clip: true

    Rectangle {
        anchors.left: parent.left
        anchors.right: butt.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        color: root.isSelected ? "#faba00" : (root.containsMouse ? "white" : "transparent")
        opacity: 0.25
    }
    
    Item {
    	id: leftContent
    	anchors.left: parent.left
    	anchors.top: parent.top
    	anchors.bottom: parent.bottom
    	width: visible ? 25 : 0
    	visible: root.isPlaying

    	ColorImage {
    		source: "/images/play_small.png"
    		anchors.fill: parent
    		color: "aliceblue"
    	}
    }

    Text {
    	id: title
        anchors.left: leftContent.right
        anchors.leftMargin: root.isPlaying ? 0 : 5
        anchors.right: rightContent.left
        anchors.verticalCenter: parent.verticalCenter

    	text: entry.title
    	elide: Text.ElideRight
        font.pixelSize: 16
        color: "aliceblue"
    }

    MouseArea {
    	id: mouseArea
    	anchors.fill: parent
    	hoverEnabled: true
    	onClicked: {
    		root.clicked()
    	}
    }

    Item {
    	id: rightContent
    	anchors.right: butt.left
    	anchors.top: parent.top
    	anchors.bottom: parent.bottom
    	anchors.rightMargin: 5
    	width: time.width

    	Text {
    		id: time
    		anchors.verticalCenter: parent.verticalCenter
    		text: entry.time
    		color: "aliceblue"
    		font.pixelSize: 16
    	}
    }

	SimpleButton {
		id: butt
		width: 25
		height: 25
		anchors.right: parent.right
		text: "X"
		backgroundOpacity: 0.25
		backgroundPressedOpacity: 0.25
		backgroundMouseOverOpacity: 0.25
		backgroundColor: "white"
		backgroundPressedColor: "#faba00"

		onClicked: root.deleteClicked()

		states: [
			State {
				when: root.containsMouse
				name: "normal"
				AnchorChanges { target: butt; anchors.right: parent.right; anchors.left: undefined }
			},
			State {
				when: !root.containsMouse
				name: "expanded"
				AnchorChanges { target: butt; anchors.right: undefined; anchors.left: parent.right }
			}
		]

		transitions: Transition {
			AnchorAnimation { duration: 50 }
		}
	}
}