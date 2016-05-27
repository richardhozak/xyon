import QtQuick 2.3


Rectangle {
	id: root

	width: 350
	height: 500
	color: "transparent"

	signal activatePage()

	Rectangle {
		anchors.fill: parent
		color: "white"
		opacity: 0.1

		Rectangle {
    		anchors.fill: parent
    		color: "transparent"
    		border.width: 1
    		border.color: "white"
    	}
	}

	Column {
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.leftMargin: 10
		anchors.rightMargin: 10
		anchors.top: parent.top
		anchors.topMargin: 10
		spacing: 10

		SimpleGlassButton {
			text: "Load playlist"
			onClicked: controller.openPlaylist()
		}

		SimpleGlassButton {
			text: "Save playlist"
			onClicked: controller.savePlaylist()
		}
	}


	Image {
		width: 25
		height: 25
		anchors.topMargin: 25
		anchors.rightMargin: 5
		anchors.right: parent.left
		anchors.top: parent.top
		source: "/images/settings.png"
		mipmap: true
		rotation: percentage * 360 / 2
	}
}