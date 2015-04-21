import QtQuick 2.4

Rectangle {
	property var items: []

	Text {
		anchors.centerIn: parent
		font.pixelSize: parent.height * 0.65
		text: selectedItem
	}

	readonly property string selectedIndex: internal.selected
	property string selectedItem: items.length == 0 ? "" : items[selectedIndex]

	QtObject {
		id: internal
		property int selected: 0

		function setNext() {
			if (selected + 1 < items.length) {
				selected++;
			} else {
				selected = 0;
			}
		}

		function setPrev() {
			if (selected > 0) {
				selected--;
			} else {
				selected = items.length;
			}
		}
	}

	MouseArea {
		anchors.fill: parent
		onPressed: {
			if (mouse.button == Qt.LeftButton) {
				internal.setNext();
			}
			else if (mouse.button == Qt.RightButton) {
				internal.setPrev();
			}
			else {
				mouse.accepted = false;
			}
		}
	}
} 