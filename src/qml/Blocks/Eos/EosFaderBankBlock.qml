import QtQuick 2.5
import CustomElements 1.0
import "../../CustomBasics"
import "../../CustomControls"
import "../../."  // to import EosFaderItem

BlockBase {
    id: root
    width: (block.attr("numFaders").val)*90*dp
    height: 400*dp
    settingsComponent: settings

    StretchColumn {
        anchors.fill: parent

        StretchRow {
            implicitHeight: -1

            Repeater {
                id: faderRepeater
                model: block.attr("numFaders").val

                EosFaderItem {
                    index: modelData
                }
            }
        }

        DragArea {
            text: "Fader Bank"

            StretchRow {
                width: 140*dp
                height: 30*dp
                anchors.right: parent.right
                Text {
                    width: 60*dp
                    text: "Page:"
                }
                ButtonBottomLine {
                    width: 30*dp
                    text: "-"
                    onPress: block.sendPageMinusEvent()
                    mappingID: block.getUid() + "pageMinus"
                }
                NumericInput {
                    width: 40*dp
                    minimumValue: 1
                    maximumValue: 30
                    value: block.page
                    onValueChanged: {
                        if (value !== block.page) {
                            block.page = value
                        }
                    }
                }
                ButtonBottomLine {
                    width: 30*dp
                    text: "+"
                    onPress: block.sendPagePlusEvent()
                    mappingID: block.getUid() + "pagePlus"
                }
            }
        }

    }  // end main Column

    Component {
        id: settings
        StretchColumn {
            leftMargin: 15*dp
            rightMargin: 15*dp
            defaultSize: 30*dp

            BlockRow {
                StretchText {
                    text: "Faders count:"
                }
                AttributeNumericInput {
                    width:  55*dp
                    implicitWidth: 0
                    attr: block.attr("numFaders")
                }
            }
        }
    }  // end Settings Component
}
