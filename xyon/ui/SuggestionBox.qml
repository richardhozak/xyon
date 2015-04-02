import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2

Item {
    id: root
    property int currentIndex: -1
    signal textChanged(string text)
    signal textAccepted(string text)

    property alias model: completionList.model

    QtObject {
        id: internal
        property string lastInput: ""
        property int lastIndex: -1
        property bool ignoreTextChanged: false
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

        onAccepted: root.textAccepted(text)

        onTextChanged: {
            if (internal.ignoreTextChanged)
            {
                return;
            }

            internal.lastInput = text;
            root.textChanged(text);
        }

        function setCurrentIndex(index) {
            if (index === currentIndex)
            {
                return;
            }

            internal.ignoreTextChanged = true;

            internal.lastIndex = currentIndex;
            currentIndex = index;

            if (currentIndex == -1)
            {
                searchField.text = internal.lastInput;
            }
            else
            {
                searchField.text = completionList.currentItem.text;
            }


            internal.ignoreTextChanged = false;
        }

        function incrementCurrentIndex() {
            if (currentIndex >= completionList.count - 1)
            {
                setCurrentIndex(-1);
            }
            else
            {
                setCurrentIndex(currentIndex + 1);
            }
        }

        function decrementCurrentIndex() {
            if (currentIndex - 1 < -1)
            {
                setCurrentIndex(completionList.count - 1);
            }
            else
            {
                setCurrentIndex(currentIndex - 1);
            }
        }

        Keys.onUpPressed: decrementCurrentIndex()
        Keys.onDownPressed: incrementCurrentIndex()

        Button {
            anchors.right: parent.right
            text: completionList.currentIndex
            onClicked: console.log("completionlistindex", completionList.currentIndex)
        }

        Rectangle {
            id: completionListContainer
            width: searchField.width
            height: completionList.count * 25 > 400 ? 400 : completionList.count * 25
            anchors.top: searchField.bottom
            anchors.left: searchField.left

            ScrollView {
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
                    decrementControl: Item {}
                    incrementControl: Item {}
                }

                ListView {
                    id: completionList
                    anchors.fill: parent
                    model: 4
                    currentIndex: root.currentIndex

                    delegate: Rectangle {
                        property string text: object.text

                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        height: 25
                        width: parent.width - 20
                        color: root.currentIndex == index ? "red" : "wheat"

                        Text {
                            text: object.text
                            anchors.fill: parent
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 2
                            color: "black"
                        }
                    }
                }
            }
        }
    }
}
