import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0
import QtMultimedia 5.0

Item {

    ScrollView {
        id: playlist
        anchors.left: parent.left
        anchors.leftMargin: 10
        width: parent.width - 20
        height: parent.height / 2
        anchors.horizontalCenter: parent.horizontalCenter

        style: ScrollViewStyle {
            transientScrollBars: true
            handle: Item {
                implicitWidth: 14
                implicitHeight: 26
                Rectangle {
                    color: "white"
                    anchors.fill: parent
                    anchors.leftMargin: 4
                    anchors.rightMargin: 4
                    opacity: 0.5
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
            model: controller.playlist.items
            delegate: Item {
                anchors.left: parent.left
                height: 50
                width: parent.width
                //clip: true

                property bool containsMouseOrIsPlaying: hoverArea.containsMouse || controller.playlist.currentPlayingIndex === index

                Text {
                    anchors.left: playListButton.right
                    anchors.leftMargin: containsMouseOrIsPlaying ? 5 : 0
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    text: object.title
                    color: "white"
                    elide: Text.ElideRight
                    width: parent.width - playListButton.width - (containsMouseOrIsPlaying ? 5 : 0) - removeFromListButton.width
                    font.pixelSize: 16
                }

                Text {
                    anchors.right: removeFromListButton.left
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
                    text: object.time
                    color: "white"
                    font.pixelSize: 16

                    Rectangle {
                        width: parent.width
                        height: 5
                        color: "white"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -5
                    }
                }

                Rectangle {
                    id: playListButton
                    width: containsMouseOrIsPlaying ? 40 : 0
                    height: parent.height
                    //color: addMouseArea.pressed ? Qt.lighter("#dbdbdb") : "#dbdbdb"
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
                                //controller.playlist.setCurrentIndex(index);
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
                    source: controller.playlist.currentPlayingIndex === index ? "/images/stop.png" : "/images/play.png"
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
                            console.log("removing", index);
                            controller.playlist.removeAt(index);
                        }
                    }

                    Behavior on width {
                        NumberAnimation { duration: 50 }
                    }
                }

                Image {
                    id: removeFromListButtonImage
                    width: removeFromListButton.width / 2
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

                Rectangle {
                    width: parent.width
                    height: 1
                    color: "white"
                    anchors.bottom: parent.bottom
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

    function updateText(textArea, total) {
        //var total = controller.player.duration;
        var hours = Math.floor((total / (60 * 60 * 1000)));
        var minutes = Math.floor((total / (60 * 1000)) % 60).toString();
        var seconds = Math.floor((total / 1000) % 60).toString();

        //console.log("hours", hours, "minutes", minutes, "seconds", seconds);

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
        onStateChanged: console.log(controller.player.state)
    }

    Item {
        id: controlArea
        anchors.top: playlist.bottom
        width: parent.width
        height: parent.height - playlist.height

        //color: "green"

        Text {
            id: title
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            text: controller.playlist.playingItem.title
            color: "white"
            font.pixelSize: 20
            elide: Text.ElideRight | Text.ElideLeft
            width: parent.width - 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            Component.onCompleted: {
                console.log("controller.playlist.playingItem", controller.playlist.playingItem)
            }
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
                    border.color: "white"
                    color: "transparent"
                    radius: 3
                    clip: true

                    Rectangle {
                        height: parent.height
                        color: "white"
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
            color: "white"
            text: "0:00"
            font.pixelSize: 16
        }

        Text {
            id: durationText
            anchors.right: parent.right
            anchors.top: progressBar.bottom
            anchors.rightMargin: 5
            anchors.topMargin: 5
            color: "white"
            text: "4:20"
            font.pixelSize: 16
        }

        Item {
            width: parent.width
            anchors.top: durationText.bottom
            anchors.bottom: parent.bottom

            RoundButton {
                id: playButton
                anchors.centerIn: parent
                source: controller.player.state == MediaPlayer.PlayingState ? "/images/pause.png" : "/images/play.png"
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

            RoundButton {
                size: 50
                anchors.right: playButton.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 15
                source: "/images/previous.png"
                ratio: 0.4
                enabled: controller.playlist.currentIndex > 0
                onClicked: controller.playlist.currentIndex--
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
                onCurrentPlayingIndexChanged: {
                    console.log("current playing index", controller.playlist.currentPlayingIndex);
                }
            }

            RoundButton {
                size: 50
                anchors.left: playButton.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 15
                source: "/images/next.png"
                ratio: 0.4
                enabled: controller.playlist.currentIndex !== -1 && controller.playlist.currentIndex < controller.playlist.items.count -1
                onClicked: controller.playlist.currentIndex++
            }

            Slider {
                height: 15
                rotation: -90
                width: parent.height * 0.9
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: -width + 70
                maximumValue: 100
                minimumValue: 0
                value: controller.player.volume
                onValueChanged: controller.player.volume = value

                style: SliderStyle {
                    groove: Rectangle {
                        implicitWidth: progressBar.width
                        implicitHeight: progressBar.height
                        border.width: 2
                        border.color: "white"
                        color: "transparent"
                        radius: 3
                        clip: true

                        Rectangle {
                            height: parent.height
                            color: "white"
                            width: styleData.handlePosition
                            radius: parent.radius
                        }
                    }
                    handle: Item {}
                }
            }
        }
    }
}

