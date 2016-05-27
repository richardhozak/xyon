import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0

Item {
    id: root
    property int currentIndex: -1
    signal textChanged(string text)
    signal textAccepted(string text)
    property alias isExpanded: searchField.focus

    property alias model: completionList.model

    property alias filter: filterSwitch.filter

    signal filterClicked()

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
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: filterSwitch.left
        anchors.rightMargin: 5
        font.pixelSize: 20
        font.weight: Font.Light
        //placeholderText: "Search..."
        style: TextFieldStyle {
            textColor: "white"
            background: Rectangle {
                radius: 3
                implicitWidth: 100
                implicitHeight: 24
                border.color: "black"
                border.width: 1
                color: "black"
                opacity: 0.25
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
        Keys.onEscapePressed: root.isExpanded = false

    }

    FilterSwitch {
        id: filterSwitch
        height: 32
        width: height
        anchors.right: parent.right
    }
    
    Rectangle {
        id: completionListContainer
        //width: searchField.width
        anchors.left: searchField.left
        anchors.right: filterSwitch.right
        height: searchField.focus ? (completionList.count * 25 > 400 ? 400 : completionList.count * 25) : 0
        anchors.top: searchField.bottom
        anchors.topMargin: 5
        visible: height != 0
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.1
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: pageList.width
                height: pageList.height
                Rectangle {
                    anchors.centerIn: parent
                    width: pageList.width
                    height: pageList.height
                    radius: 5//Math.min(width, height)
                }
            }
        }

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
                currentIndex: root.currentIndex

                delegate: Rectangle {
                    property string text: object

                    anchors.left: parent.left
                    height: 25
                    width: parent.width
                    //color: root.currentIndex == index ? "#d6d6d6" : "#dbdbdb"
                    color: "transparent"

                    Rectangle {
                        anchors.fill: parent
                        color: root.currentIndex == index ? "white" : "transparent"
                        opacity: 0.25
                    }

                    Text {
                        text: object
                        width: parent.width - 5
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: parent.height * 0.65
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onContainsMouseChanged: {
                            if (containsMouse)
                            {
                                internal.setCurrentIndex(index);
                            }
                        }
                        onClicked: internal.acceptText(searchField.text)
                    }
                }
            }
        }
    }

    Text {
        text: "Search..."
        anchors.verticalCenter: searchField.verticalCenter
        anchors.left: searchField.left
        font.pixelSize: 20
        font.weight: Font.Light
        anchors.leftMargin: 8
        color: "white"
        visible: searchField.text.length == 0
        opacity: 0.25
    }

}
