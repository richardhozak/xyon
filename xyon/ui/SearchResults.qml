import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Item {
    id: root
    property alias interactive: scrollView.enabled
    property alias model: resultsList.model

    signal contentScrolled()
    signal entryClicked(var entry)

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
                implicitWidth: 9
                implicitHeight: 26
                Rectangle {
                    color: "white"
                    anchors.fill: parent
                    //anchors.leftMargin: 8
                    //anchors.rightMargin: 0
                    opacity: 0.25
                }
            }
            scrollBarBackground: Item {
                implicitWidth: 9
                implicitHeight: 26
                //color: "red"
            }
            decrementControl: Item{}
            incrementControl: Item{}
            transientScrollBars: true
        }

        ListView {
            id: resultsList
            anchors.fill: parent
            spacing: 5
            delegate: Entry {
                anchors.left: parent.left
                anchors.leftMargin: 10
                height: 50
                //width: parent.width - 14
                anchors.right: parent.right
                anchors.rightMargin: 10
                entry: object
                onClicked: root.entryClicked(object)
            }
        }
    }
}
