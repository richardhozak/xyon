import QtQuick 2.3


Item {
	id: root
	property var pages: []
	property string page: ""

	clip: true

	QtObject {
		id: internal
		property string basePage: ""
		property int basePageIndex: -1
	}

	onPageChanged: updatePage()

	Component.onCompleted: {
		internal.basePage = root.page
		internal.basePageIndex = root.pages.indexOf(page)
		updatePage()
	}
	
	function updatePage() {
		//console.log("page", page)
		for (var i in row.children) {
			var child = row.children[i]
			if (child.objectName == page) {
				var coords = child.mapToItem(row, 0, 0)
				
				if (i > internal.basePageIndex) {
					row.x = -coords.x + (root.width - child.width)
				}
				else {
					row.x = -coords.x
				}
			} 
		}
	}

	function prevPage() {
		var index = root.pages.indexOf(root.page) - 1
		if (index < 0) {
			index = root.pages.length - 1
		}

		root.page = root.pages[index]
	}

	function printInfo() {
		console.log("row.width", row.width)
		console.log("root.width", root.width)
		console.log("loader.width", root.width)
		console.log("row.x", row.x)
		for (var i in row.children) {
			console.log("i", row.children[i])
		}
	}

	function nextPage() {
		var index = root.pages.indexOf(root.page) + 1
		if (index >= root.pages.length) {
			index = 0
		}

		root.page = pages[index]
	}

	Row {
		id: row
		Repeater {
			model: root.pages
			delegate: Loader {
				source: "Page" + modelData + ".qml"
				objectName: modelData
			}
		}

		Behavior on x {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
	}
}