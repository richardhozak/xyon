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

    //onPercentChanged: console.log("percentil", percent)

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

        model: controller.queryList
        z: 1
    }

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
    /*
    TextField {
        id: searchField
        width: parent.width - 20
        height: 32
        font.pixelSize: 20

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 10

        placeholderText: "Search..."

        style: TextFieldStyle {
            textColor: "black"
            background: Rectangle {
                radius: 2
                implicitWidth: 100
                implicitHeight: 24
                border.color: "#494949"
                border.width: 1
                color: "#dbdbdb"
            }
        }

        onAccepted: controller.search(text)
    }
    */
    Item {
        id: searchResultsContainer
        anchors.top: searchField.bottom
        width: parent.width
        height: parent.height - searchField.height - 10 - loadMoreButton.height

        ScrollView {
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            enabled: !root.isDisabled

            style: ScrollViewStyle {
                handle: Item {
                    implicitWidth: 14
                    implicitHeight: 26
                    Rectangle {
                        color: "#494949"
                        anchors.fill: parent
                        anchors.leftMargin: 4
                        anchors.rightMargin: 4
                    }
                }
                scrollBarBackground: Item {
                    implicitWidth: 14
                    implicitHeight: 26
                }
                decrementControl: Item{}
                incrementControl: Item{}
            }

            ListView {
                anchors.fill: parent
                model: controller.searchlist
                delegate: Entry {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    height: 50
                    width: parent.width - 20
                    entry: object
                }
                onCountChanged: console.log("search list count changed", count)
            }
        }
    }

    Button {
        id: loadMoreButton
        anchors.top: searchResultsContainer.bottom
        height: 25
        width: parent.width
        text: "Load more"
        visible: controller.searchlist.count > 0
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

