import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0
import QtMultimedia 5.0

Item {
    id: root

    signal closeClicked()
    signal minimizeClicked()
    signal downloadClicked()

    function updateText(textArea, total) {
        var hours = Math.floor((total / (60 * 60 * 1000)));
        var minutes = Math.floor((total / (60 * 1000)) % 60).toString();
        var seconds = Math.ceil((total / 1000) % 60).toString();

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
        onPositionChanged: {
            if (controller.player.state == MediaPlayer.StoppedState) {
                updateText(positionText, 0)
            }
            else {
                updateText(positionText, controller.player.position)    
            }
        }
    }

    /*Image {
        anchors.fill: parent
        source: "/images/background.png"
        opacity: 0.95
    }*/

    Item {

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: parent.height - 50 - 30


        ScrollView {
            id: playlist
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.rightMargin: 10 - 1 // some weird 1px bug
            height: parent.height / 2

            style: ScrollViewStyle {
                handleOverlap: 0
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
                    opacity: 0.25
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: -1
                    anchors.bottomMargin: -1
                }
                decrementControl: Rectangle { width: 0; height: 0 }
                incrementControl: Rectangle { width: 0; height: 0 }
            }

            Keys.onLeftPressed: console.log("pressed")

            ListView {
                anchors.fill: parent
                anchors.rightMargin: 10 + 1 // some weird 1px bug

                currentIndex: controller.player.playlist.currentIndex
                highlightFollowsCurrentItem: true

                model: controller.player.playlist
                delegate: PlaylistEntry {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    entry: track
                    trackIndex: index
                    onClicked: {
                        controller.player.playIndex(index)
                    }
                    onDoubleClicked: controller.setClipboard(track)
                    onDeleteClicked: controller.player.removeTrack(track)
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
                
                text: controller.player.playlist.currentIndex != -1 ? controller.player.playlist.get(controller.player.playlist.currentIndex).title : ""
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

                /*Rectangle {
                    width: 20
                    height: width
                    radius: width
                    color: stopMouseArea.pressed ? "#faba00" : "transparent"
                    border.color: "#faba00"
                    anchors.horizontalCenter: playButton.right
                    anchors.bottom: playButton.top

                    MouseArea {
                        id: stopMouseArea
                        anchors.fill: parent
                        onClicked: controller.player.stop()
                    }
                }*/

                ControlButton {
                    height: 40
                    width: 40
                    anchors.right: playButton.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 15
                    source: "/images/previous.png"
                    sourcePressed: "/images/previous_selected.png"
                    enabled: controller.player.playlist.currentIndex > 0
                    onClicked: controller.player.previous()
                }

                ControlButton {
                    height: 40
                    width: 40
                    anchors.left: playButton.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 15
                    source: "/images/next.png"
                    sourcePressed: "/images/next_selected.png"
                    enabled: controller.player.playlist.currentIndex !== -1 && controller.player.playlist.currentIndex < controller.player.playlist.count - 1
                    onClicked: controller.player.next()
                }

                Connections {
                    target: controller.player.playlist
                    onCountChanged: console.log("playlist count", controller.player.playlist.count)
                }

                Connections {
                    target: controller.player.playlist
                    onCurrentIndexChanged: console.log("index", controller.player.playlist.currentIndex)
                }

                VolumeSlider {
                    height: 60
                    width: 75 + 10
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


                /*SimpleButton {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom

                    width: 25
                    height: 25
                    text: "D"

                    onClicked: {
                        controller.downloadEntry(controller.player.playlist.get(controller.player.playlist.currentIndex))
                    }
                }*/
            }
        }
    }
}

