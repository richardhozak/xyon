import QtQuick 2.4


Item {
	id: root

	property string filter: "tracks"

	property color color: "black"
	property color selectedColor: Qt.lighter(color)
	property color fontColor: Qt.lighter(Qt.lighter(color))
	property color selectedFontColor: Qt.darker(color)

	property alias radius: foregroundOverlay.radius
	property alias border: foregroundOverlay.border
	
	Component.onCompleted: {
		border.width = 2;
		border.color = Qt.lighter(color);
		radius = 3;
	}

	Rectangle {
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		
		width: parent.width / 2
		color: root.filter == "tracks" ? root.selectedColor : root.color
		radius: parent.radius

		Rectangle {
			anchors.right: parent.right
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			width: parent.radius
			color: parent.color
			z: parent.z - 1
		}

		Text {
	    	font.pixelSize: parent.height * 0.65
	    	anchors.centerIn: parent
	    	text: "Tracks"
	    	color: root.filter == "tracks" ? root.selectedFontColor : root.fontColor
	    }

	    MouseArea {
	        anchors.fill: parent
	        onClicked: root.filter = "tracks"
	    }
	}
	
	Rectangle {
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		
		width: parent.width / 2
		color: root.filter == "playlists" ? root.selectedColor : root.color
		radius: parent.radius

		Rectangle {
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			width: parent.radius
			color: parent.color
			z: parent.z - 1
		}

		Text {
	    	font.pixelSize: parent.height * 0.65
	    	anchors.centerIn: parent
	    	text: "Playlists"
	    	color: root.filter == "playlists" ? root.selectedFontColor : root.fontColor
	    }

	    MouseArea {
	        anchors.fill: parent
	        onClicked: root.filter = "playlists"
	    }
	}

	Rectangle {
		id: foregroundOverlay
		anchors.fill: parent
		border.width: 2
		radius: 3
		color: "transparent"
	}
}