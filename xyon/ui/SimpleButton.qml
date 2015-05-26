import QtQuick 2.4

Item {

	property alias text: buttonText.text
	signal clicked()

	readonly property alias containsMouse: buttonMouseArea.containsMouse

	readonly property color currentBackgroundColor: buttonMouseArea.pressed ? backgroundPressedColor : (buttonMouseArea.containsMouse ? backgroundMouseOverColor : backgroundColor)
	readonly property real currentBackgroundOpacity: buttonMouseArea.pressed ? backgroundPressedOpacity : (buttonMouseArea.containsMouse ? backgroundMouseOverOpacity : backgroundOpacity) 

	readonly property color currentForegroundColor: buttonMouseArea.pressed ? foregroundPressedColor : (buttonMouseArea.containsMouse ? foregroundMouseOverColor : foregroundColor)
	readonly property real currentForegroundOpacity: buttonMouseArea.pressed ? foregroundPressedOpacity : (buttonMouseArea.containsMouse ? foregroundMouseOverOpacity : foregroundOpacity) 

	property color foregroundColor: "#faba00"
	property color foregroundMouseOverColor: "#faba00"
	property color foregroundPressedColor: "aliceblue"
	
	property color backgroundColor: "transparent"
	property color backgroundMouseOverColor: "aliceblue"
	property color backgroundPressedColor: "#faba00"

	property real foregroundOpacity: 1
	property real foregroundMouseOverOpacity: 1
	property real foregroundPressedOpacity: 1

	property real backgroundOpacity: 1
	property real backgroundMouseOverOpacity: 1
	property real backgroundPressedOpacity: 1

	Rectangle {
		anchors.fill: parent
		color: currentBackgroundColor
		opacity: currentBackgroundOpacity
	}

	Text {
		id: buttonText
		font.pixelSize: parent.height * 0.65
		anchors.centerIn: parent
		color: currentForegroundColor
		opacity: currentForegroundOpacity
	}

	MouseArea {
		id: buttonMouseArea
		anchors.fill: parent
		hoverEnabled: true
		onClicked: parent.clicked()
	}
}