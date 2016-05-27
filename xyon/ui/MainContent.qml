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

    Row {
        height: 20
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 1
        
        Item {
            width: 30
            height: 20
            
            Rectangle {
                anchors.fill: parent
                color: minimizeMouseArea.containsMouse && !minimizeMouseArea.pressed ? "white" : "black"
                opacity: 0.25
            }

            Rectangle {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 3
                width: parent.width * 0.4
                height: 1.5
                color: "white"
            }

            MouseArea {
                id: minimizeMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.minimizeClicked()
            }
        }

        Rectangle {
            width: 45
            height: 20
            color: closeMouseArea.containsMouse && !closeMouseArea.pressed ? Qt.lighter("#C85051") : "#C85051"

            Canvas {
                anchors.centerIn: parent
                height: parent.height / 2.5
                width: height
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.strokeStyle = "white"
                    ctx.lineWidth = 1
                    ctx.beginPath()
                    ctx.moveTo(0,0)
                    ctx.lineTo(canvasSize.width, canvasSize.height)
                    ctx.moveTo(canvasSize.width, 0)
                    ctx.lineTo(0, canvasSize.height)
                    ctx.closePath()
                    ctx.stroke()
                }
            }

            MouseArea {
                id: closeMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.closeClicked()
            }
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
            anchors.right: parent.right
            height: parent.height / 2

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

            Keys.onLeftPressed: console.log("pressed")

            ListView {
                anchors.fill: parent
                //anchors.rightMargin: 5 + 1 // some weird 1px bug

                currentIndex: controller.player.playlist.currentIndex
                highlightFollowsCurrentItem: true

                model: controller.player.playlist
                delegate: PlaylistEntry {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
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
                color: "white"
                opacity: 0.5
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
                    groove: Item {
                        implicitWidth: progressBar.width
                        implicitHeight: progressBar.height
                        Item {
                            height: parent.height * 0.75
                            width: parent.width
                            anchors.bottom: parent.bottom

                            Rectangle {
                                height: parent.height
                                color: "white"
                                width: styleData.handlePosition
                                //radius: parent.radius
                                opacity: 0.1
                            }
                            
                            Rectangle {
                                height: 1
                                width: parent.width
                                anchors.bottom: parent.bottom
                                color: "white"
                                opacity: 0.25
                            }
                        }
                    }
                    handle: Item {
                        implicitWidth: 1
                        //implicitHeight: parent.height
                        height: control.height - 1
                        


                        Rectangle {
                            anchors.fill: parent
                            color: "white"
                            opacity: 0.25
                        }
                    }
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
                font.pixelSize: 20
                font.weight: Font.Light
                opacity: 0.5
            }

            Text {
                id: durationText
                anchors.right: parent.right
                anchors.top: progressBar.bottom
                anchors.rightMargin: 5
                anchors.topMargin: 5
                color: "white"
                text: "4:20"
                font.pixelSize: 20
                font.weight: Font.Light
                opacity: 0.5
            }

            Item {
                width: parent.width
                anchors.top: progressBar.bottom
                anchors.bottom: parent.bottom

                PlayButton {
                    id: playButton
                    height: 75
                    width: 75
                    anchors.centerIn: parent
                    playing: controller.player.state == MediaPlayer.PlayingState
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

                /*ControlButton {
                    height: 40
                    width: 40
                    anchors.right: playButton.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 15
                    source: "/images/previous.png"
                    sourcePressed: "/images/previous_selected.png"
                    enabled: controller.player.playlist.currentIndex > 0
                    onClicked: controller.player.previous()
                }*/

                NextPreviousButton {
                    height: 50
                    width: 50
                    anchors.right: playButton.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 15
                    enabled: controller.player.playlist.currentIndex > 0
                    previous: true
                    onClicked: controller.player.previous()
                }

                /*ControlButton {
                    height: 40
                    width: 40
                    anchors.left: playButton.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 15
                    source: "/images/next.png"
                    sourcePressed: "/images/next_selected.png"
                    enabled: controller.player.playlist.currentIndex !== -1 && controller.player.playlist.currentIndex < controller.player.playlist.count - 1
                    onClicked: controller.player.next()
                }*/

                NextPreviousButton {
                    height: 50
                    width: 50
                    anchors.left: playButton.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 15
                    enabled: controller.player.playlist.currentIndex !== -1 && controller.player.playlist.currentIndex < controller.player.playlist.count - 1
                    previous: false
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

                /*
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
                */

                VolumeSlider {
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    value: controller.player.volume
                    onValueChanged: controller.player.volume = value
                }
                
                /*Text {
                    anchors.left: volumeSlider.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: volumeSlider.verticalCenter
                    text: Math.floor(volumeSlider.value) + " %"
                    color: "white"
                    opacity: 0.5
                    font.weight: Font.Light
                    font.pixelSize: 15
                }*/

                /*VolumeIcon {
                    width: 50
                    height: 50
                    anchors.bottom: volumeSlider.top
                    anchors.right: volumeSlider.right
                }*/

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

