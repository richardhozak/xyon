import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Item {
    id: root
    property alias interactive: scrollView.enabled
    property alias model: resultsList.model

    signal contentScrolled()

    function resetViewLocation() {
        scrollView.flickableItem.contentY = 0
    }

    property int count: model.count
    property int maxContentY: count * 50 - height
    property int threshold: 5 * 50
    property real contentY: scrollView.flickableItem.contentY

    QtObject {
        id: internal
        property bool loading: false
    }

    onContentYChanged: {
        if (contentY > maxContentY - threshold && !internal.loading) {
            internal.loading = true
            console.log("loading more...")
            root.contentScrolled()
        }
    }

    onCountChanged: {
        console.log("count", count)
        internal.loading = false
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent

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
            id: resultsList
            anchors.fill: parent
            delegate: Entry {
                anchors.left: parent.left
                anchors.leftMargin: 10
                height: 50
                width: parent.width - 20
                entry: object
            }
        }
    }
}
