import QtQuick 2.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.2

Rectangle {
	id: root
	width: 400
	height: 500
	color: "transparent"
	//radius: 5
	//clip: true
	//color: "red"

	signal changePage(string page)

	
	/*VolumeIconNew {
		anchors.horizontalCenter: parent.horizontalCenter
		y: 100
		width: 150
		height: 200
		value:	sliderVol.value / 100
		onClicked: muted = !muted
	}*/

	/*Text {
		anchors.horizontalCenter: parent.horizontalCenter
		y: 100
		font.pixelSize: 40
		text: "H"

		layer.enabled: true
		layer.effect: OpacityMask {
		    maskSource: Item {
		        width: 200
		        height: 200
		        Rectangle {
		            anchors.centerIn: parent
		            width: parent.width
		            height: parent.height
		            radius: 10
		        }
		    }
		}
	}*/

	/*Rectangle {
		id: itemItem
		anchors.horizontalCenter: parent.horizontalCenter
		y: 100
		width: 200
		height: 200

		color: "#00FF00"

		Text {
			anchors.centerIn: parent
			text: "%"
			font.pixelSize: 50
			color: "#FF0000"
			visible: true
		}

		layer.enabled: true
		layer.effect: ShaderEffect {
	        width: itemItem.width; height: itemItem.height
	        property variant src: itemItem
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
	            	//gl_FragColor = vec4(0, tex.gb, tex.a) * qt_Opacity;
	            	if (tex.r == 1) {
	            		discard;
	            	}

	            	gl_FragColor = tex;

	            	//if (tex.r > 0) {
	            	//	gl_FragColor = vec4(1, tex.g - tex.r, tex.b, tex.a);
	            	//}
	            	//else {
	            	//	gl_FragColor = tex;
	            	//}
	            	//if (tex.a == 1) {
	            	//	gl_FragColor = vec4(0,0,0,0) * qt_Opacity;
	            	//}
	            	//else {
	            	//	gl_FragColor = vec4(0,0,1,1) * qt_Opacity;
	            	//}
	            }"
	    }
	}*/

	/*Rectangle {
        id: gradientRect;
        width: 10
        height: 10
        gradient: Gradient {
            GradientStop { position: 0; color: "white" }
            GradientStop { position: 1; color: "steelblue" }
        }
        visible: true; // should not be visible on screen.
        layer.enabled: true;
        layer.smooth: true
    }

    Text {
        id: textItem
        font.pixelSize: 48
        text: "Gradient Text"
        anchors.centerIn: parent
        layer.enabled: true
        layer.samplerName: "maskSource"
        layer.effect: ShaderEffect {
            property var colorSource: gradientRect;
            fragmentShader: "
                uniform lowp sampler2D colorSource;
                uniform lowp sampler2D maskSource;
                uniform lowp float qt_Opacity;
                varying highp vec2 qt_TexCoord0;
                void main() {
                    gl_FragColor =
                        texture2D(colorSource, qt_TexCoord0)
                        * texture2D(maskSource, qt_TexCoord0).a
                        * qt_Opacity;
                }
            "
        }
    }*/

    
    /*
    Rectangle {
    	id: testRect
    	anchors.centerIn: parent
    	width: 200
    	height: 200
    	color: "blue"
    	layer.enabled: true
        layer.samplerName: "rectSource"
        layer.effect: ShaderEffect {
            property var textSource: textItem;
            fragmentShader: "
                uniform lowp sampler2D textSource;
                uniform lowp sampler2D rectSource;
                uniform lowp float qt_Opacity;
                varying highp vec2 qt_TexCoord0;
                void main() {
                	lowp vec4 rectTex = texture2D(rectSource, qt_TexCoord0);
                	lowp vec4 textTex = texture2D(textSource, qt_TexCoord0);

                	gl_FragColor = textTex;

                	if (textTex.r == 1) {
	            		discard;
	            	}
	            	else {
                		gl_FragColor = rectTex;//vec4(rectTex.r, rectTex.g, rectTex.b, textTex.a) * qt_Opacity;
	            		
	            	}


                    gl_FragColor =
                        texture2D(rectSource, qt_TexCoord0)
                        * texture2D(textSource, qt_TexCoord0).a
                        * qt_Opacity;
                }
            "
        }
    }

    Text {
    	id: textItem
    	//anchors.fill: testRect
    	text: "text"
    	font.pixelSize: 48
    	color: "#FF0000"
    	visible: true
    }

	Slider {
		id: sliderVol
		width: parent.width
		height: 50
		maximumValue: 100
		minimumValue: 0
	}
	*/

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

    /*Rectangle {
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
    }*/

    /*Rectangle {
    	id: getRekt
    	anchors.horizontalCenter: parent.horizontalCenter
    	y: 100
    	height: 200
    	width: 200
    	color: "black"

    	layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: getRekt.width
                height: getRekt.height
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    radius: 10
                    //color: "transparent"
                    //border.width: 20
                    //border.color: "transparent"
                    opacity: 0.25
                }

                Rectangle {
                	anchors.centerIn: parent
                	width: parent.width - 6
                	height: parent.height - 6
                	radius: 10
                }
            }
        }
    }*/

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

	/*PlayButton {
		anchors.horizontalCenter: parent.horizontalCenter
		y: 100
		onClicked: playing = !playing
	}*/

	/*PlayButton {
		anchors.horizontalCenter: parent.horizontalCenter
		y: 100
		height: 100
		width: 100
		enabled: false
	}*/

	/*Rectangle {
		id: testRect
		anchors.centerIn: parent
		width: 200
		height: 200
		color: "white"
		visible: false
	}

	Item {
		id: testItem
		anchors.centerIn: parent
		width: 200
		height: 200
		visible: false

		Text {
			text: "text"
			font.pixelSize: 48
			anchors.centerIn: parent
			color: "black"
		}
	}

	ShaderEffect {

		}*/

	MainContent {
		anchors.fill: parent
		onCloseClicked: controller.closeApplication()
		onMinimizeClicked: controller.minimizeApplication()
	}

	MouseArea {
		width: 50
		height: 50
		onClicked: root.changePage("Search")
	}

	MouseArea {
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.topMargin: 25
		width: 30
		height: 25
		onClicked: root.changePage("Settings")

		Rectangle {
			anchors.fill: parent
			opacity: 0.25
			color: "white"
		}
	}
}