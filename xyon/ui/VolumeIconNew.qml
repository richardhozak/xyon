import QtQuick 2.2
import QtGraphicalEffects 1.0

Item {
	id: root
	property real value: 0.5
	property bool muted: false
	signal clicked()

	QtObject {
		id: internal
		property real displayedValue: root.muted ? 0.0 : (root.value < 0.0 ? 0.0 : (root.value > 1.0 ? 1.0 : root.value))
	}

	Rectangle {
		anchors.fill: parent
		color: "gray"
		opacity: 0.5
	}

	Item {
		anchors.fill: parent	

		Canvas {
			anchors.fill: parent
			onPaint: {
				var ctx = getContext("2d")
				var gridWidth = 3
				var gridUnit = canvasSize.width / gridWidth
				ctx.fillStyle = "white"

				ctx.beginPath()
				ctx.moveTo(0, gridUnit)
				ctx.lineTo(gridUnit, gridUnit)
				ctx.lineTo(gridUnit, 3 * gridUnit)
				ctx.lineTo(0, 3 * gridUnit)
				ctx.closePath()
				ctx.fill()

				ctx.beginPath()
				ctx.moveTo(gridUnit, gridUnit)
				ctx.lineTo(3*gridUnit, 0)
				ctx.lineTo(3*gridUnit, 4*gridUnit)
				ctx.lineTo(gridUnit, 3 * gridUnit)
				ctx.closePath()
				ctx.fill()
			}
		}

		layer.enabled: true
		layer.effect: OpacityMask {
		    maskSource: Item {
		        width: root.width
		        height: root.height
		        Rectangle {
		        	id: opacityRect
		            anchors.centerIn: parent
		            width: parent.width
		            height: parent.height
		            opacity: 1

		            layer.enabled: true
		            layer.effect: OpacityMask {
		            	maskSource: Item {
		            		width: opacityRect.width
		            		height: opacityRect.height

		            		Text {
		            			anchors.centerIn: parent
		            			text: "H"
		            			font.pixelSize: 20
		            			opacity: 0.1
		            		}
		            	}
		            }
		        }
		    }
		}
	}
	
	Item {
		width: parent.width / 4
		height: width
		//color: "red"
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: (parent.width / 8) * 4.5
		visible: root.muted

		Canvas {
			anchors.fill: parent
			onPaint: {
				var ctx = getContext("2d")
				ctx.lineWidth = 2
				ctx.strokeStyle = "white"
				ctx.beginPath()
				ctx.moveTo(0,0)
				ctx.lineTo(parent.width, parent.height)
				ctx.closePath()
				ctx.stroke()
				ctx.beginPath()
				ctx.moveTo(parent.width,0)
				ctx.lineTo(0, parent.height)
				ctx.closePath()
				ctx.stroke()
			}
		}
	}

	MouseArea {
		anchors.fill: parent
		onClicked: root.clicked()
	}
}