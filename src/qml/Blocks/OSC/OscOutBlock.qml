import QtQuick 2.5
import CustomElements 1.0
import "../../CustomBasics"
import "../../CustomControls"

BlockBase {
	id: root
	width: Math.max(oscMessageInput.implicitWidth + 30*dp, 100*dp)
    height: 60*dp
	onWidthChanged: block.positionChanged()
	settingsComponent: settings

	StretchColumn {
		anchors.fill: parent

		TextInput {
			id: oscMessageInput
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.leftMargin: 4*dp
			anchors.rightMargin: 4*dp
			height: 30*dp
			hintText: "path"
			text: block.message
			onTextChanged: {
				if (text !== block.message) {
					block.message = text
				}
			}
		}

        DragArea {
			text: "OSC"
            InputNode {
                node: block.node("inputNode")
                suggestions: ["Button"]
			}

			// ------------ Tx Status LED -----------

			Rectangle {
				width: 10*dp
				height: 10*dp
				radius: width / 2
				anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10*dp
				color: ledTimer.running ? "lightgreen" : "#777"
                antialiasing: false

				Timer {
					// this timer is triggered when the LED should light up
					// it stops running 200ms after that
					id: ledTimer
					repeat: false
					interval: 200
				}

				Connections {
					target: block
					// trigger the timer when a message has been sent:
					onMessageSent: ledTimer.restart()
				}
			}
		}
	}

	Component {
		id: settings
		StretchColumn {
			leftMargin: 15*dp
			rightMargin: 15*dp
			defaultSize: 30*dp

			StretchText {
				text: "<value> Range:"
			}
			BlockRow {
				StretchText {
					text: "From:"
				}
                ButtonBottomLine {
                    width: 15*dp
                    implicitWidth: 0
                    text: block.attr("negativeMinValue").val ? "-" : "+"
                    onPress: block.attr("negativeMinValue").val = !block.attr("negativeMinValue").val
                }
				NumericInput {
					width: 60*dp
					implicitWidth: 0  // do not stretch
					minimumValue: 0
					maximumValue: 999
					decimals: 1
					value: block.minValue
					onValueChanged: {
						if (value !== block.minValue) {
							block.minValue = value
						}
					}
				}
				StretchText {
					implicitWidth: -0.7
					text: "To:"
					hAlign: Text.AlignRight
				}
                ButtonBottomLine {
                    width: 15*dp
                    implicitWidth: 0
                    text: block.attr("negativeMaxValue").val ? "-" : "+"
                    onPress: block.attr("negativeMaxValue").val = !block.attr("negativeMaxValue").val
                }
				NumericInput {
					width: 60*dp
					implicitWidth: 0  // do not stretch
                    minimumValue: 0
					maximumValue: 999
					value: block.maxValue
					decimals: 1
					onValueChanged: {
						if (value !== block.maxValue) {
							block.maxValue = value
						}
					}
				}
			}
            BlockRow {
                StretchText {
                    text: "(Range not used for BPM values)"
                }
            }
			BlockRow {
				StretchText {
					text: "Use Integer Values:"
				}
				CheckBox {
					width: 30*dp
					active: block.useInteger
					onActiveChanged: {
						if (active !== block.useInteger) {
							block.useInteger = active
						}
					}
				}
			}
		}
	}  // end Settings Component
}

