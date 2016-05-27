import QtQuick 2.3

Rectangle {
	id: root
	property var pages: []
	property string page: ""
	property string mainPage: ""

	QtObject {
		id: internal
		property var pageWidths: ({})

		function getWidthOfPageAtIndex(index) {
			return internal.pageWidths[root.pages[index]]
		}

		function isPageOnRightSideOfMainPage(page) {
			return root.pages.indexOf(page) > root.pages.indexOf(root.mainPage)
		}

		function printPageWidths() {
			console.log("page widths (total", pageRow.width + "):")
			for (var i = 0; i < root.pages.length; i++) {
				console.log(" ", root.pages[i], internal.pageWidths[root.pages[i]])
			}
		}

		function getSumWidthUptoPage(page) {
			var pageIndex = root.pages.indexOf(page)
			if (pageIndex != -1) {
				var width = 0
				if (internal.isPageOnRightSideOfMainPage(page)) {
					for (var i = 0; i <= pageIndex; i++) {
						width += internal.getWidthOfPageAtIndex(i)
					}
					return width - internal.pageWidths[root.mainPage]
				}
				else {
					for (var i = 0; i < pageIndex; i++) {
						width += internal.getWidthOfPageAtIndex(i)
					}
					return width
				}
			}
			return 0
		}

		function getAbsoluteSumToPage(page) {
			var pageIndex = root.pages.indexOf(page)
			if (pageIndex != -1) {
				var width = 0
				for (var i = 0; i < pageIndex; i++) {
					width += internal.getWidthOfPageAtIndex(i)
				}
				return width
			}
			return 0
		}
	}

	function nextPage() {
		var index = root.pages.indexOf(root.page) + 1
		if (index >= root.pages.length) {
			index = 0
		}

		root.page = root.pages[index]
	}

	function previousPage() {
		var index = root.pages.indexOf(root.page) - 1
		if (index < 0) {
			index = root.pages.length - 1
		}

		root.page = root.pages[index]
	}

	Image {
		id: parallaxBackground
		x: -(parallaxBackground.width - root.width) * (internal.getSumWidthUptoPage(root.page) / (pageRow.width - root.width))
		source: "/images/parallax_background_5.png"
		enabled: pageRow.enabled

		Behavior on x {
			enabled: pageRow.enabled
            NumberAnimation { duration: 600; easing.type: Easing.OutCubic }
        }
	}

	Row {
		id: pageRow
		height: parent.height
		enabled: false
		x: enabled ? -internal.getSumWidthUptoPage(root.page) : 0

		Repeater {
			model: root.pages
			delegate: Loader {
				readonly property real beginPosition: endPosition - item.width
				readonly property real endPosition: internal.getSumWidthUptoPage(modelData)
				//TODO -^
				property real percentage: root.page == modelData ? 1.0 : 0.0
				Behavior on percentage {
					NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
				}

				source: "Page" + modelData + ".qml"
				onLoaded: internal.pageWidths[modelData] = item.width

				MouseArea {
					anchors.fill: item
					enabled: root.page != modelData
					preventStealing: true
					hoverEnabled: true
					onClicked: root.page = modelData
				}

				Binding {
					target: item
					property: "enabled"
					value: root.page == modelData
				}

				Connections {
					ignoreUnknownSignals: true
					target: item
					onChangePage: root.page = page
				}
			}
		}

		Behavior on x {
			enabled: pageRow.enabled
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
	}

	Component.onCompleted: {
		root.mainPage = root.page
		pageRow.enabled = true
	}

	/*Column {
		anchors.centerIn: parent
		Repeater {
			model: [
			"pageRow.x " + pageRow.x,
			"parallaxBackground.width " + parallaxBackground.width,
			"pageRow.width " + pageRow.width, 
			"percentage " + percentil,
			"parallax " + parallaxBackground.width,
			"parallax.x" + parallaxBackground.x,
			"maxValue " + maxValue,
			"maxParallax " + maxParallax,
			"currentXParallax " + maxParallax * percentil,
			]
			delegate: Text {
				text: modelData
			}
		}
	}*/


}