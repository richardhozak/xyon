import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0
import QtMultimedia 5.0

Item {

    function updateText(textArea, total) {
        var hours = Math.floor((total / (60 * 60 * 1000)));
        var minutes = Math.floor((total / (60 * 1000)) % 60).toString();
        var seconds = Math.floor((total / 1000) % 60).toString();

        if (hours > 0)
        {
            textArea.text = hours + ":" + (minutes.length == 1 ? "0" + minutes : minutes) + ":" + (seconds.length == 1 ? "0" + seconds : seconds);
        }
        else
        {
            textArea.text = minutes + ":" + (seconds.length == 1 ? "0" + seconds : seconds);
        }
    }

    Connections {
        target: controller.player
        onDurationChanged: updateText(durationText, controller.player.duration)
        onPositionChanged: updateText(positionText, controller.player.position)
    }

    Image {
        anchors.fill: parent
        source: "/images/background.png"
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        spacing: 10

        SimpleButton {
            width: 30
            height: 30
            text: "▼"
            onClicked: controller.save_playlist()
        }

        SimpleButton {
            width: 30
            height: 30
            text: "▲"
            onClicked: controller.open_playlist()
        }
    }

    Item {

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: parent.height - 50


        ScrollView {
            id: playlist
            anchors.left: parent.left
            anchors.leftMargin: 10
            width: parent.width - 20
            height: parent.height / 2
            anchors.horizontalCenter: parent.horizontalCenter

            style: ScrollViewStyle {
                //transientScrollBars: true
                handle: Rectangle {
                    implicitWidth: 8
                    implicitHeight: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 1
                    color: "#faba00"
                }
                scrollBarBackground: Rectangle {
                    color: "white"
                    implicitWidth: 10
                    implicitHeight: 20
                    opacity: 0.5
                }
                decrementControl: Item{}
                incrementControl: Item{}
            }

            Keys.onLeftPressed: console.log("pressed")

            ListView {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 10

                model: controller.playlist.items
                delegate: Item {
                    anchors.left: parent.left
                    height: 25
                    anchors.right: parent.right

                    Rectangle {
                        anchors.fill: parent
                        color: index % 2 != 0 ? "white" : "transparent"
                        opacity: 0.25
                    }

                    property color textColor: "aliceblue"
                    property bool containsMouseOrIsPlaying: hoverArea.containsMouse || controller.playlist.currentPlayingIndex === index

                    Text {
                        anchors.left: playListButton.right
                        anchors.leftMargin: containsMouseOrIsPlaying ? 5 : 0
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: timeText.left

                        text: object.title
                        color: textColor
                        elide: Text.ElideRight
                        font.pixelSize: 16
                    }

                    Text {
                        id: timeText
                        anchors.right: removeFromListButton.left
                        anchors.rightMargin: deleteHoverArea.containsMouse ? 5 : 0
                        anchors.verticalCenter: parent.verticalCenter
                        text: object.time
                        color: textColor
                        font.pixelSize: 16
                    }

                    Rectangle {
                        id: playListButton
                        width: containsMouseOrIsPlaying ? 40 : 0
                        height: parent.height
                        color: "white"
                        opacity: playStopMouseArea.pressed ? 0.5 : 1
                        clip: true



                        MouseArea {
                            id: playStopMouseArea
                            anchors.fill: parent
                            onClicked: {
                                if (controller.playlist.currentIndex === index)
                                {
                                    controller.player.stop();
                                }
                                else
                                {
                                    controller.playlist.currentIndex = index;
                                    controller.player.play();
                                }
                            }
                        }

                        Behavior on width {
                            NumberAnimation { duration: 50 }
                        }
                    }

                    Image {
                        id: playListButtonImage
                        anchors.fill: playListButton
                        source: controller.playlist.currentPlayingIndex === index ? "/images/stop.png" : "/images/play_small.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    ColorOverlay {
                        anchors.fill: playListButtonImage
                        source: playListButtonImage
                        color: "#343434"
                    }

                    Rectangle {
                        id: removeFromListButton
                        width: deleteHoverArea.containsMouse ? 40 : 0
                        height: parent.height
                        anchors.right: parent.right
                        color: "white"
                        opacity: removeFromListArea.pressed ? 0.5 : 1


                        MouseArea {
                            id: removeFromListArea
                            anchors.fill: parent
                            onClicked: {
                                //console.log("removing", index);
                                controller.playlist.removeAt(index);
                            }
                        }

                        Behavior on width {
                            NumberAnimation { duration: 50 }
                        }
                    }

                    Image {
                        id: removeFromListButtonImage
                        width: removeFromListButton.width * 0.25
                        height: width
                        anchors.centerIn: removeFromListButton
                        source: "/images/delete.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    ColorOverlay {
                        anchors.fill: removeFromListButtonImage
                        source: removeFromListButtonImage
                        color: "#343434"
                    }

                    MouseArea {
                        id: hoverArea
                        height: parent.height
                        width: parent.width / 2
                        hoverEnabled: true
                        onPressed: mouse.accepted = false
                    }

                    MouseArea {
                        id: deleteHoverArea
                        height: parent.height
                        width: parent.width / 2
                        anchors.right: parent.right
                        hoverEnabled: true
                        onPressed: mouse.accepted = false
                    }
                }
            }
        }

        Item {
            id: controlArea
            anchors.top: playlist.bottom
            width: parent.width
            height: parent.height - playlist.height

            Text {
                id: title
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                
                text: controller.playlist.playingItem != null ? controller.playlist.playingItem.title : ""
                font.pixelSize: 20
                color: "aliceblue"
            }

            Slider {
                id: progressBar
                anchors.top: title.bottom
                anchors.topMargin: 15
                height: 15
                width: parent.width * 0.9
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true

                maximumValue: controller.player.duration
                minimumValue: 0
                value: controller.player.position
                enabled: controller.player.seekable
                onValueChanged: {
                    if (controller.player.position > value + 25 || controller.player.position < value - 25)
                    {
                        controller.player.setPosition(value)
                    }
                }

                style: SliderStyle {
                    groove: Rectangle {
                        implicitWidth: progressBar.width
                        implicitHeight: progressBar.height
                        border.width: 2
                        border.color: "#faba00"
                        color: "transparent"
                        radius: 3
                        clip: true

                        Rectangle {
                            height: parent.height
                            color: "#faba00"
                            width: styleData.handlePosition
                            radius: parent.radius
                        }
                    }
                    handle: Item {}
                }
            }

            Text {
                id: positionText
                anchors.left: parent.left
                anchors.top: progressBar.bottom
                anchors.leftMargin: 5
                anchors.topMargin: 5
                color: "#faba00"
                text: "0:00"
                font.pixelSize: 20
            }

            Text {
                id: durationText
                anchors.right: parent.right
                anchors.top: progressBar.bottom
                anchors.rightMargin: 5
                anchors.topMargin: 5
                color: "#faba00"
                text: "4:20"
                font.pixelSize: 20
            }

            Item {
                width: parent.width
                anchors.top: progressBar.bottom
                anchors.bottom: parent.bottom

                ControlButton {
                    id: playButton
                    height: 75
                    width: 75
                    anchors.centerIn: parent
                    source: controller.player.state == MediaPlayer.PlayingState ? "/images/pause.png" : "/images/play.png"
                    sourcePressed: controller.player.state == MediaPlayer.PlayingState ? "/images/pause_selected.png" : "/images/play_selected.png"
                    onClicked: {
                        if (controller.player.state == MediaPlayer.PlayingState)
                        {
                            controller.player.pause();
                        }
                        else
                        {
                            controller.player.play();
                        }
                    }
                }

                ControlButton {
                    height: 40
                    width: 40
                    anchors.right: playButton.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 15
                    source: "/images/previous.png"
                    sourcePressed: "/images/previous_selected.png"
                    enabled: controller.playlist.currentIndex > 0
                    onClicked: controller.playlist.currentIndex--
                }

                ControlButton {
                    height: 40
                    width: 40
                    anchors.left: playButton.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 15
                    source: "/images/next.png"
                    sourcePressed: "/images/next_selected.png"
                    enabled: controller.playlist.currentIndex !== -1 && controller.playlist.currentIndex < controller.playlist.items.count -1
                    onClicked: controller.playlist.currentIndex++
                }

                Connections {
                    target: controller.playlist.items
                    onCountChanged: console.log("count", controller.playlist.items.count)
                }

                Connections {
                    target: controller.playlist
                    onCurrentIndexChanged: console.log("current index", controller.playlist.currentIndex)
                }

                Connections {
                    target: controller.playlist
                    onCurrentPlayingIndexChanged: console.log("current playing index", controller.playlist.currentPlayingIndex)
                }

                VolumeSlider {
                    height: 60
                    width: 75
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    value: controller.player.volume
                    onValueChanged: controller.player.volume = value

                    Text {
                        anchors.right: parent.left
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 5

                        color: "#faba00"
                        text: Math.floor(parent.value).toString() + "%" 
                        font.pixelSize: parent.height * 0.25
                    }
                }
            }
        }
    }
}

