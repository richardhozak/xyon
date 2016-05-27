import QtQuick 2.4
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

Row {
    id: root

    property alias value: volumeSlider.value

    Slider {
        id: volumeSlider
        //anchors.right: parent.right
        //anchors.rightMargin: 60
        //anchors.bottom: parent.bottom
        //anchors.bottomMargin: 10
        height: 15
        width: 100
        //anchors.horizontalCenter: parent.horizontalCenter
        clip: true
        stepSize: 0.1 * 0.5
        maximumValue: 100//controller.player.duration
        minimumValue: 0
        value: 20//controller.player.position
        //enabled: root.enabled//true//controller.player.seekable

        style: SliderStyle {
            groove: Item {
                implicitWidth: volumeSlider.width
                implicitHeight: volumeSlider.height
                Item {
                    height: parent.height * 0.75
                    width: parent.width
                    anchors.bottom: parent.bottom

                    Rectangle {
                        height: parent.height
                        color: "white"
                        width: styleData.handlePosition
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
        id: text
        width: 45
        text: Math.floor(volumeSlider.value) + " %"
        color: "white"
        opacity: 0.5
        font.weight: Font.Light
        font.pixelSize: 15
        horizontalAlignment: Text.AlignRight
    }   
}
