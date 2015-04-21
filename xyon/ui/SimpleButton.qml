import QtQuick 2.4

Rectangle {

	property alias text: buttonText.text
	signal clicked()

	property color borderColorPressed: "aliceblue"
	property color borderColor: "#faba00"

	readonly property color activeColor: buttonMouseArea.pressed ? borderColorPressed : borderColor

	radius: 3
	color: "transparent"
	opacity: buttonMouseArea.containsMouse && !buttonMouseArea.pressed ? 0.75 : 1
	
	border.width: 2
	border.color: activeColor

	Text {
		id: buttonText
		font.pixelSize: parent.height * 0.65
		anchors.centerIn: parent
		color: activeColor
	}

	MouseArea {
		id: buttonMouseArea
		anchors.fill: parent
		onClicked: parent.clicked()
		hoverEnabled: true
	}
}