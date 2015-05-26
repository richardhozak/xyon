import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    id: root
    property real percent: 1 - (x / -width)

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
    }

    property bool isDisabled: false
    signal loadPlaylistClicked

    SuggestionBox {
        id: searchField
        width: parent.width - 20// - switchButton.width
        height: 32

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 10 + 30

        onTextAccepted: controller.serviceManager.search(text)
        onTextChanged: controller.queryCompletion(text)

        model: controller.suggestionList
        z: 1
    }

    /*ServiceSwitch {
        id: switchButton
        anchors.left: searchField.right
        anchors.verticalCenter: searchField.verticalCenter
        height: 32
        width: height
        border.color: "#494949"
        border.width: 1
        color: "#dbdbdb"
        radius: 2
        items: ["YT", "SC"]
        onSelectedItemChanged: {
            if (selectedItem == "YT") {
                controller.serviceManager.changeService("youtube")
            }
            else if (selectedItem == "SC") {
                controller.serviceManager.changeService("soundcloud")
            }
        }
    }*/

    SearchSwitch {
        id: searchSwitch
        anchors.top: searchField.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        height: 25
        color: root.color
        filter: controller.serviceManager.queryFilter
        onFilterChanged: controller.serviceManager.queryFilter = filter
    }
    
    Item {
        id: searchResultsContainer
        anchors.top: searchSwitch.bottom
        anchors.bottom: parent.bottom//loadMoreButton.top
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        
        width: parent.width
        clip: true

        SearchResults {
            id: trackSearchResults
            x: controller.serviceManager.queryFilter == "tracks" ? 0 : -width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width

            interactive: !root.isDisabled
            model: controller.serviceManager.trackResults

            Behavior on x {
                NumberAnimation { duration: 100 }
            }

            onContentScrolled: controller.serviceManager.loadMore("tracks")

            Connections {
                target: controller.serviceManager.trackResults
                onCountChanged: {
                    var count = controller.serviceManager.trackResults.count
                    if (count == 0) {
                        trackSearchResults.resetViewLocation()
                    }
                }
            }
        }

        SearchResults {
            id: playlistSearchResults
            anchors.left: trackSearchResults.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width
            
            interactive: !root.isDisabled
            model: controller.serviceManager.playlistResults

            onContentScrolled: controller.serviceManager.loadMore("playlists")

            Connections {
                target: controller.serviceManager.playlistResults
                onCountChanged: {
                    var count = controller.serviceManager.playlistResults.count
                    if (count == 0) {
                        playlistSearchResults.resetViewLocation()
                    }
                }
            }
        }

        /*Image {
            anchors.fill: playlistSearchResults
            fillMode: Image.PreserveAspectFit
            source: "/images/uc.png"
            visible: switchButton.selectedItem == "SC"
        }*/
    }

    MouseArea {
        enabled: searchField.isExpanded
        hoverEnabled: enabled
        width: parent.width + 100
        height: parent.height
        onClicked: searchField.isExpanded = false
    }
}
