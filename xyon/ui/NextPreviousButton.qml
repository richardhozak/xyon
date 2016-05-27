import QtQuick 2.2

Item {
	id: root
	
	height: 75
	width: 75
	opacity: enabled ? 1.0 : 0.5

	property bool previous: false
	signal clicked()

	MouseArea {
		id: buttonMouseArea
		anchors.fill: parent
		hoverEnabled: true
		property bool circleContainsMouse: containsMouse && mouseRange < width / 2
		property real mouseRange: Math.sqrt(Math.pow(Math.abs(mouseX - (width / 2)), 2) + Math.pow(Math.abs(mouseY - (height / 2)), 2))
		onClicked: {
			if (circleContainsMouse) {
				root.clicked()	
			}
		}
	}

	Rectangle {
		anchors.fill: parent
    	radius: height / 2
    	color: "black"
    	opacity: 0.25
	}

	Item {
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
		width: parent.width / 2
		height: parent.height / 2
		opacity: 0.75
		rotation: root.previous ? 180 : 0

		Canvas {
			anchors.fill: parent
			onPaint: {
				var ctx = getContext("2d")
				ctx.fillStyle = "white"
				ctx.beginPath()
				ctx.moveTo(0, 0)
				ctx.lineTo(width - width / 3, height / 2)
				ctx.lineTo(0, height)
				ctx.lineTo(0, 0)
				ctx.closePath()
				ctx.fill()

				ctx.beginPath()
				ctx.moveTo(width, 0)
				ctx.lineTo(width - width / 3, 0)
				ctx.lineTo(width - width / 3, height)
				ctx.lineTo(width, height)
				ctx.lineTo(width, 0)
				ctx.closePath()

				ctx.fill()
			}
		}
	}

	Rectangle {
		anchors.fill: parent
		radius: height / 2
		color: "white"
		opacity: 0.1
		visible: buttonMouseArea.circleContainsMouse && !buttonMouseArea.pressed
	}

	Rectangle {
    	anchors.fill: parent
    	radius: height / 2
    	color: "transparent"

    	border.width: 1
    	border.color: "black"
    	opacity: 0.25
	}
}