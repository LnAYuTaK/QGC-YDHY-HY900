import QtQuick          2.5
import QtQuick.Controls 2.4
import QtQuick.Dialogs  1.3
import QtQuick.Layouts  1.2
import QtQuick.Window   2.11

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.MenuTool      1.0
Rectangle {
    id:versionView
    color:  qgcPal.window
    z:      QGroundControl.zOrderTopMost
    visible:        true
    property real   _margins:                   ScreenTools.defaultFontPixelWidth
    readonly property real _defaultTextHeight:  ScreenTools.defaultFontPixelHeight
    readonly property real _verticalMargin:     _defaultTextHeight / 2
    readonly property real _buttonHeight:       ScreenTools.isTinyScreen ? ScreenTools.defaultFontPixelHeight * 3 : ScreenTools.defaultFontPixelHeight * 2
    QGCPalette { id: qgcPal }
    QGCFlickable {
    clip:               true
    anchors.fill:       parent
    contentHeight:      outerItem.height
    flickableDirection: Flickable.VerticalFlick
    Item {
        id:     outerItem
        width:  Math.max(versionView.width, view.width)
        height: view.height
            ColumnLayout{
                id:view
                anchors.fill: parent
                QGCLabel {
                    id:             devicesLabel
                    text:           qsTr("设备")
                }
                Rectangle {
                    id:deviceInfo
                    Layout.preferredHeight:devicesId.height+ (_margins*2)
                    Layout.fillWidth:       true
                    color:         qgcPal.windowShade
                    GridLayout {
                         id:                devicesId
                        columns:            2
                        QGCLabel {
                            text:           qsTr("设备名称")
                        }
                        QGCLabel {
                            text:           qsTr("N/A")
                        }

                        QGCLabel {
                            text:           qsTr("设备型号")

                        }
                        QGCLabel {
                            text:           qsTr("N/A")
                        }
                    }
                }
                QGCLabel {
                    id:         groundControlLabel
                    text:       qsTr("地面站")
                }
                Rectangle {
                    id:groundControlInfo
                    Layout.preferredHeight:groundControl.height+ (_margins*2)
                    Layout.fillWidth:       true
                    color:         qgcPal.windowShade
                    GridLayout {
                         id:                groundControl
                        columns:            2
                        QGCLabel {
                            text:           qsTr("地面站版本")

                        }
                        QGCLabel {
                            text:           qsTr("1.0")
                        }
                    }
                }
            QGCLabel {
                id:         otherLabel
                text:       qsTr("其他")
            }
            Rectangle {
                id:otherinfo
                Layout.preferredHeight:other.height+ (_margins*2)
                Layout.fillWidth:       true
                color:         qgcPal.windowShade
                GridLayout {
                     id:                other
                    columns:            2
                    QGCLabel {
                        text:           qsTr("电池")

                    }
                    QGCLabel {
                        text:           qsTr("N/A")
                   }
                }
              }
            }
        }
    }
}

