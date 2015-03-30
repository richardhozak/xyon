import QtQuick 2.4
import QtQuick.Window 2.2

Window {
	visible: true
	width: 400
	height: 500
	color: "white"

	ListView {
		anchors.fill: parent
		model: controller.items
		delegate: Rectangle {
			width: parent.width
			height: 50
			color: "red"

		}
	}
}
