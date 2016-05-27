import QtQuick 2.3


Rectangle {
	id: root

	width: 350
	height: 500
	color: "transparent"

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

	signal changePage(string page)
	signal activatePage()

	Search {
		anchors.fill: parent
		color: "transparent"//"#242424"
		onLoadPlaylistClicked: {
			console.log("loadplaylistclicked")
			root.changePage("Playlist")
		}
	}

	Image {
		width: 50
		height: 50
		anchors.left: parent.right
		anchors.top: parent.top
		source: "/images/diamond.png"
		smooth: true
		rotation: (percentage * 360) / 2 - 90
	}
}