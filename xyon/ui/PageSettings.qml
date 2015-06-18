import QtQuick 2.3


Rectangle {
	id: root

	width: 350
	height: 500
	color: "#242424"

	signal activatePage()

	Text {
		text: "Under\nConstruction"
		color: "white"
		anchors.centerIn: parent
		font.pixelSize: 50
	}

	MouseArea {
		width: 50
		height: 50
		anchors.right: parent.left
		anchors.top: parent.top

		Image {
			width: 50
			height: 50
			anchors.centerIn: parent
			source: "/images/settings.png"
			smooth: true
			rotation: percentage * 360 / 2
		}

		onClicked: root.activatePage()
	}
}