import QtQuick 2.4

MouseArea {
	height: 25
	width: parent.width
	hoverEnabled: true

	property string text

	Rectangle {
		anchors.fill: parent
		radius: 5
		color: parent.containsMouse && !parent.pressed ? "white" : "black"
		opacity: 0.25
	}
	
	Text {
		anchors.centerIn: parent
		text: parent.text
		color: "white"
		font.pixelSize: 16
	}
}