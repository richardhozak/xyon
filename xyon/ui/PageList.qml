import QtQuick 2.3
import "Extensions.js" as Ext

Item {
	id: root
	property var pages: []
	property string page: ""

	clip: true

	QtObject {
		id: internal
		property string lastPage: ""
		property string basePage: ""
		property int basePageIndex: -1
		property bool isCompleted: false
	}

	onPageChanged: updatePage()

	Component.onCompleted: {
		internal.basePage = root.page
		internal.lastPage = root.page
		internal.basePageIndex = root.pages.indexOf(root.page)
		updatePage()
		internal.isCompleted = true
	}
	
	function updatePage() {
		//console.log("page", page)

		var child = Ext.findChild(row, page)
		if (child != null) {
			var index = root.pages.indexOf(child.objectName)
			var coords = child.mapToItem(row, 0, 0)
			if (index > internal.basePageIndex) {
				row.x = -coords.x + (root.width - child.width)
			}
			else {
				row.x = -coords.x
			}
			child.activateOverlays()
		}

		/*for (var i in row.children) {
			var child = row.children[i]
			if (child.objectName == page) {
				var coords = child.mapToItem(row, 0, 0)
				
				if (i > internal.basePageIndex) {
					row.x = -coords.x + (root.width - child.width)
				}
				else {
					row.x = -coords.x
				}

				console.log(child.objectName)
				console.log("child width", child.width)
				console.log("child widthSum", child.widthSum)
			} 
		}*/
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

	function sumWidthToPage(page) {
		for (var i in row.children) {
			var child = row.children[i]
			if (child.objectName == page) {
				var coords = child.mapToItem(row, 0, 0)
				return coords.x
			} 
		}
	}

	/*function getOverlay(index) {
		if (index >= 0 && index < root.pages.length) {
			var child = Ext.findChild(row, root.pages[index])
			if (child != null) {
				return Ext.findChild(child, "shadowOverlay")
			}
		}
	}*/

	Row {
		id: row

		property int widthAccumulator: 0

		//onXChanged: console.log("x", x)

		function changePageCallback(page) {
			if (root.page == page) {
				root.page = internal.lastPage
			} 
			else {
				internal.lastPage = root.page
				root.page = page
			}
		}


		Repeater {
			model: root.pages
			delegate: Item {
				width: loader.width
				height: loader.height
				objectName: modelData

				property real percentage: 0
				property int widthSum: 0

				onWidthChanged: console.log(modelData, "width", width)

				property Rectangle prevOverlay: null
				property Rectangle nextOverlay: null
				property Item nextChild: null
				property Item prevChild: null

				Behavior on percentage {
					NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
				}

				function activateOverlays() {
					percentage = 1
					Ext.setIfNotNull(prevOverlay, "opacity", 0.5)
					Ext.setIfNotNull(nextOverlay, "opacity", 0.5)
					Ext.callIfNotNull(prevChild, "deactivateOverlays")
					Ext.callIfNotNull(nextChild, "deactivateOverlays")
				}

				function deactivateOverlays() {
					percentage = 0
					Ext.setIfNotNull(prevOverlay, "opacity", 0)
					Ext.setIfNotNull(nextOverlay, "opacity", 0)
				}

				function rowCompleted() {
					//console.log(modelData, z)
					var index = root.pages.indexOf(modelData)

					if (index + 1 < root.pages.length) {
						var child = Ext.findChild(row, root.pages[index + 1])
						if (child != null) {
							nextChild = child
							nextOverlay = Ext.findChild(child, "shadowOverlay")
						}
					}

					if (index - 1 >= 0) {
						var child = Ext.findChild(row, root.pages[index - 1])
						if (child != null) {
							prevChild = child
							prevOverlay = Ext.findChild(child, "shadowOverlay")
						}
					}
				}
				
				Component.onCompleted: {
					widthSum = row.widthAccumulator
					row.widthAccumulator += width
				}

				Loader {
					id: loader
					source: "Page" + modelData + ".qml"
					objectName: modelData

					function activatePageCallback() {
						row.changePageCallback(modelData)
						/*
						if (root.page == modelData) {
							root.page = internal.lastPage
						} 
						else {
							internal.lastPage = root.page
							root.page = modelData
						}*/
					}

					

					Component.onCompleted: {
						if (Ext.containsProperty(item, "activatePage")) {
							item.activatePage.connect(activatePageCallback)
						}

						if (Ext.containsProperty(item, "changePage")) {
							item.changePage.connect(row.changePageCallback)
						}
					}
				}

				Rectangle {
					anchors.fill: parent
					color: "black"
					opacity: 0
					visible: opacity != 0
					objectName: "shadowOverlay"

					MouseArea {
						anchors.fill: parent
						enabled: opacity != 0
						visible: enabled
						hoverEnabled: enabled
						onClicked: {
							console.log("clicked", modelData)
							root.page = modelData
						}
					}

					Behavior on opacity {
						NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
					}
				}
			}
		}

		Component.onCompleted: {
			var currentIndex = root.pages.indexOf(root.page)
			for (var index in root.pages) {
				var child = Ext.findChild(row, root.pages[index])
				if (child != null) {
					child.z = currentIndex
					if (currentIndex > 0) {
						currentIndex--
					}
					else {
						currentIndex++
					}
					child.rowCompleted()
				}
			}
		}

		Behavior on x {
			enabled: internal.isCompleted
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
	}
}