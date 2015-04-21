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
        width: parent.width - 20 - switchButton.width
        height: 32

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 10

        onTextAccepted: controller.search(text)
        onTextChanged: controller.query_completion(text)

        model: controller.suggestionList
        z: 1
    }

    ServiceSwitch {
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
        
    }
    /*
    Button {
        id: switchButton
        anchors.left: searchField.right
        anchors.verticalCenter: searchField.verticalCenter
        
        height: 32
        width: height
        text: controller.selectedService == "youtube" ? "YT" : "SC"
        tooltip: "Switch search engine"

        onClicked: {
            if (controller.selectedService == "youtube")
            {
                controller.selectedService = "soundcloud";
            }
            else
            {
                controller.selectedService = "youtube";
            }
        }
    }
    */
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
        search: controller.searchOption
        onSearchChanged: controller.searchOption = search
    }
    
    Item {
        id: searchResultsContainer
        anchors.top: searchSwitch.bottom
        anchors.bottom: loadMoreButton.top
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        
        width: parent.width
        clip: true

        SearchResults {
            id: trackSearchResults
            x: controller.searchOption == "tracks" ? 0 : -width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width

            interactive: !root.isDisabled
            model: controller.trackResults

            Behavior on x {
                NumberAnimation { duration: 100 }
            }

            Component.onCompleted: {
                console.log("x", x);
                console.log("width", width);
            }
        }

        SearchResults {
            anchors.left: trackSearchResults.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width
            
            interactive: !root.isDisabled
            model: controller.playlistResults
        }
    }

    Button {
        id: loadMoreButton
        anchors.bottom: parent.bottom
        height: 25
        width: parent.width
        text: "Load more"
        visible: true//TODO    //controller.searchlist.count > 0
        style: ButtonStyle {
            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 25
                color: loadMoreButton.pressed ? Qt.lighter("#494949"): "#494949"
            }
            label: Component {
                Text {
                    text: loadMoreButton.text
                    clip: true
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.fill: parent
                    color: loadMoreButton.pressed ? "black" : "#dbdbdb"
                }
            }
        }
        onClicked: controller.load_more()
    }

    MouseArea {
        enabled: searchField.isExpanded
        hoverEnabled: enabled
        width: parent.width + 100
        height: parent.height
        onClicked: searchField.isExpanded = false
    }
}
