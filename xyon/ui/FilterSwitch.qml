import QtQuick 2.4

Item {
	id: root

	opacity: 0.25

	property string filter: "tracks"

	Image {
		anchors.fill: parent
		source: "/images/icon_playlists.png"
		visible: root.filter == "playlists"
		mipmap: true
		smooth: false
	}

	Image {
		anchors.fill: parent
		source: "/images/icon_tracks.png"
		visible: root.filter == "tracks"
		mipmap: true
		smooth: false
	}

	MouseArea {
		anchors.fill: parent
		onClicked: {
			if (root.filter == "playlists") {
				root.filter = "tracks"
			}
			else {
				root.filter = "playlists"
			}
		}
	}
}