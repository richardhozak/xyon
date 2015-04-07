import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2

Item {
    id: root
    property int currentIndex: -1
    signal textChanged(string text)
    signal textAccepted(string text)
    property alias isExpanded: searchField.focus

    property alias model: completionList.model

    QtObject {
        id: internal
        property string lastInput: ""
        property int lastIndex: -1
        property bool ignoreTextChanged: false

        function acceptText(text) {
            root.textAccepted(text);
            searchField.focus = false;
        }

        function setCurrentIndex(index) {
            if (index === root.currentIndex)
            {
                return;
            }

            internal.ignoreTextChanged = true;

            internal.lastIndex = root.currentIndex;
            currentIndex = index;

            if (root.currentIndex == -1)
            {
                searchField.text = internal.lastInput;
            }
            else
            {
                searchField.text = completionList.currentItem.text;
            }


            internal.ignoreTextChanged = false;
        }
    }

    TextField {
        id: searchField
        anchors.fill: parent
        font.pixelSize: 20
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

        onAccepted: internal.acceptText(text)

        onTextChanged: {
            if (internal.ignoreTextChanged)
            {
                return;
            }
            root.currentIndex = -1;
            internal.lastInput = text;
            root.textChanged(text);
        }

        function incrementCurrentIndex() {
            if (currentIndex >= completionList.count - 1)
            {
                internal.setCurrentIndex(-1);
            }
            else
            {
                internal.setCurrentIndex(currentIndex + 1);
            }
        }

        function decrementCurrentIndex() {
            if (currentIndex - 1 < -1)
            {
                internal.setCurrentIndex(completionList.count - 1);
            }
            else
            {
                internal.setCurrentIndex(currentIndex - 1);
            }
        }

        Keys.onUpPressed: decrementCurrentIndex()
        Keys.onDownPressed: incrementCurrentIndex()

        Rectangle {
            id: completionListContainer
            width: searchField.width
            height: searchField.focus ? (completionList.count * 25 > 400 ? 400 : completionList.count * 25) : 0
            anchors.top: searchField.bottom
            anchors.left: searchField.left
            visible: height != 0

            ScrollView {
                anchors.fill: parent
                visible: parent.visible
                style: ScrollViewStyle {
                    handle: Item {
                        visible: parent.visible
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
                    decrementControl: Item {}
                    incrementControl: Item {}
                }

                ListView {
                    id: completionList
                    anchors.fill: parent
                    model: 4
                    currentIndex: root.currentIndex

                    delegate: Rectangle {
                        property string text: object

                        anchors.left: parent.left
                        height: 25
                        width: parent.width
                        color: root.currentIndex == index ? "#d6d6d6" : "#dbdbdb"

                        Text {
                            text: object
                            width: parent.width
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onContainsMouseChanged: {
                                if (containsMouse)
                                {
                                    internal.setCurrentIndex(index);
                                    //root.currentIndex = index;
                                }
                            }
                            onClicked: internal.acceptText(searchField.text)
                        }

                        Component.onCompleted: console.log("object", object)
                    }
                }
            }
        }
    }
}
