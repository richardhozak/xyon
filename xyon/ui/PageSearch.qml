import QtQuick 2.3


Rectangle {
	id: root

	width: 350
	height: 500
	color: "blue"

	signal changePage(string page)
	signal activatePage()

	Search {
		anchors.fill: parent
		color: "#242424"
		onLoadPlaylistClicked: {
			console.log("loadplaylistclicked")
			root.changePage("Playlist")
		}
	}

	MouseArea {
		width: 50
		height: 50
		anchors.left: parent.right
		anchors.top: parent.top

		Image {
			width: 50
			height: 50
			anchors.centerIn: parent
			source: "/images/diamond.png"
			smooth: true
			rotation: (percentage * 360) / 2 - 90
		}

		onClicked: root.activatePage()
	}
}