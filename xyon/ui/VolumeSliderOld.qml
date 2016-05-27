import QtQuick 2.4
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

Slider {
    id: root

    width: 120
    height: 96

    maximumValue: 100
    minimumValue: 0

    style: SliderStyle {
        groove: Item {
            implicitWidth: root.width
            implicitHeight: root.height
            Item {
                id: background
                width: root.width
                height: root.height
                opacity: 0

                Rectangle {
                    width: styleData.handlePosition
                    height: parent.height
                    color: "#faba00"
                }
            }

            Image {
                id: mask
                source: "/images/volume.png"
                width: root.width
                height: root.height
                opacity: 0
            }
            
            OpacityMask {
                anchors.fill: background
                source: background
                maskSource: mask
            }
        }
        handle: Item {}
    }
}