import QtQuick 2.3
import QtGraphicalEffects 1.0

Rectangle {
	width: 400
	height: 500
	color: "transparent"
	//radius: 5
	//clip: true
	//color: "red"

	Image {
		id: img
		anchors.fill: parent
		source: "/images/background_noice.png"
		opacity: 1//0.95
		//visible: false
	}

	/*Image {
		id: img
		property bool rounded: true
		property bool adapt: false
		anchors.fill: parent
		source: "/images/background_noice.png"
		
		layer.enabled: rounded
		layer.effect: OpacityMask {
		    maskSource: Item {
		        width: img.width
		        height: img.height
		        Rectangle {
		            anchors.centerIn: parent
		            width: img.width//img.adapt ? img.width : Math.min(img.width, img.height)
		            height: img.height//img.adapt ? img.height : width
		            radius: 5//Math.min(width, height)
		        }
		    }
		}
	}*/

	/*ShaderEffect {
        width: img.width; height: img.height
        property variant src: img
        vertexShader: "
            uniform highp mat4 qt_Matrix;
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            varying highp vec2 coord;
            void main() {
                coord = qt_MultiTexCoord0;
                gl_Position = qt_Matrix * qt_Vertex;
            }"
        fragmentShader: "
            varying highp vec2 coord;
            uniform sampler2D src;
            uniform lowp float qt_Opacity;
            void main() {
                lowp vec4 tex = texture2D(src, coord);
                gl_FragColor = vec4(vec3(dot(tex.rgb,
                                    vec3(0.344, 0.5, 0.156))),
                                         tex.a) * qt_Opacity;
            }"
    }*/

    /*Rectangle {
    	id: rect
    	anchors.centerIn: parent
    	width: 200
    	height: 200
    	color: "yellow"

    	MouseArea {
    		anchors.fill: parent
    		onPressed: console.log("pressed")
    	}

    	layer.enabled: true
		layer.effect: OpacityMask {
		    maskSource: Item {
		        width: rect.width
		        height: rect.height
		        Rectangle {
		            anchors.centerIn: parent
		            width: rect.width
		            height: rect.height
		            radius: 10//Math.min(width, height)
		        }
		    }
		}
    }*/

    Rectangle {
    	anchors.horizontalCenter: parent.horizontalCenter
    	y: 100
    	height: 200
    	width: 200
    	opacity: 0.1
    	color: "white"

    	Rectangle {
    		anchors.fill: parent
    		color: "transparent"
    		border.width: 1
    		border.color: "white"
    	}
    }

	/*Rectangle {
		anchors.fill: parent
		border.width: 1
		border.color: "black"
		radius: 5
		color: "transparent"
		opacity: 0.25
	}*/

	/*Rectangle {
		id: mask
		anchors.fill: parent
		color: "black"
		radius: 20
		border.width: 20
		visible: true
	}

	OpacityMask {
		anchors.fill: img
		source: img
		maskSource: mask
	}*/

	MainContent {
		anchors.fill: parent
	}
}