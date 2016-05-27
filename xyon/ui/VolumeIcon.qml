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
				var gridWidth = 8
				var gridUnit = canvasSize.width / gridWidth
				ctx.fillStyle = "white"

				ctx.beginPath()
				ctx.moveTo(gridUnit, 3 * gridUnit)
				ctx.lineTo(gridUnit + gridUnit, 3 * gridUnit)
				ctx.lineTo(gridUnit + gridUnit, 4 * gridUnit + gridUnit)
				ctx.lineTo(gridUnit, 4 * gridUnit + gridUnit)
				ctx.closePath()
				ctx.fill()

				ctx.beginPath()
				ctx.moveTo(2 * gridUnit, 3 * gridUnit)
				ctx.lineTo(4*gridUnit, 1.5*gridUnit)
				ctx.lineTo(4*gridUnit, 6.5*gridUnit)
				ctx.lineTo(2*gridUnit, 4 * gridUnit + gridUnit)
				ctx.closePath()
				ctx.fill()

				ctx.fillStyle = Qt.rgba(1, 1, 1, 0.25)

				ctx.fillRect(4*gridUnit,2*gridUnit,3*gridUnit,4*gridUnit)

				ctx.lineWidth = 1
				ctx.strokeStyle = "white"
				
				ctx.beginPath()
				ctx.moveTo(4.5 * gridUnit, 2 * gridUnit)
				ctx.lineTo(4.5 * gridUnit, 6 * gridUnit)
				ctx.closePath()
				ctx.stroke()

				ctx.beginPath()
				ctx.moveTo(5 * gridUnit, 2 * gridUnit)
				ctx.lineTo(5 * gridUnit, 6 * gridUnit)
				ctx.closePath()
				ctx.stroke()

				ctx.beginPath()
				ctx.moveTo(5.5 * gridUnit, 2 * gridUnit)
				ctx.lineTo(5.5 * gridUnit, 6 * gridUnit)
				ctx.closePath()
				ctx.stroke()

				ctx.beginPath()
				ctx.moveTo(6 * gridUnit, 2 * gridUnit)
				ctx.lineTo(6 * gridUnit, 6 * gridUnit)
				ctx.closePath()
				ctx.stroke()

				ctx.beginPath()
				ctx.moveTo(6.5 * gridUnit, 2 * gridUnit)
				ctx.lineTo(6.5 * gridUnit, 6 * gridUnit)
				ctx.closePath()
				ctx.stroke()
			}
		}

		layer.enabled: true
		layer.effect: OpacityMask {
		    maskSource: Item {
		        width: root.width
		        height: root.height
		        Rectangle {
		            anchors.left: parent.left
		            anchors.leftMargin: root.width / 8
		            width: root.width / 2 - root.width / 8 + (root.width / 8) * 3 * internal.displayedValue
		            height: root.height
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