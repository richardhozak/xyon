import QtQuick 2.3
import QtGraphicalEffects 1.0

Item {

	property alias source: image.source
	property alias color: overlay.color

	Image {
		id: image
		anchors.fill: parent
		fillMode: Image.PreserveAspectFit
	}

	ColorOverlay {
		id: overlay
		anchors.fill: parent
		source: image
	}
}