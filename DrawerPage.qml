import QtQuick          2.5
import QtQuick.Controls 2.4
import QtQuick.Dialogs  1.3
import QtQuick.Layouts  1.11
import QtQuick.Window   2.11

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.MenuTool      1.0
Drawer {
    id:             toolDrawerSelect
    width:          mainWindow.width*0.8
    height:         mainWindow.height
    edge:           Qt.LeftEdge
    dragMargin:     0
    closePolicy:    Popup.CloseOnPressOutsideParent|Popup.CloseOnPressOutside
    interactive:    false
    visible:        false

    Rectangle {
        id:             toolDrawerSelectToolbar
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.top:    parent.top
        height:         ScreenTools.toolbarHeight
        color:          "black"
        RowLayout {
            anchors.fill:parent
            QGCLabel{
                id:planLabel
                text:"任务规划"
                font.pointSize:         15
                wrapMode:               QGCLabel.WrapAnywhere
                 color:                 qgcPal.buttonText
                 QGCMouseArea{
                     anchors.fill:parent
                       onClicked: {

                       }
                }

            }
            Rectangle{
                color:"white"
                height:parent.height
                width:2
            }

            QGCLabel{
                text:"通讯连接"
                font.pointSize:         15
                wrapMode:               QGCLabel.WrapAnywhere
                 color:             qgcPal.buttonText
                 QGCMouseArea{
                     anchors.fill:parent
                     onClicked: {
                         toolDrawerSelectLoader.sourceComponent = connectView
                     }
                }
            }
            Rectangle{
                color:"white"
                height:parent.height
                width:2
            }

            QGCLabel{
                text:"飞控参数"
                font.pointSize:         15
                wrapMode:               QGCLabel.WrapAnywhere
                 color:             qgcPal.buttonText
                 QGCMouseArea{
                     anchors.fill:parent
                     onClicked: {


                     }
                }
            }
            Rectangle{
                color:"white"
                height:parent.height
                width:2
            }

            QGCLabel{
                text:"版本说明"
                font.pointSize:         15
                wrapMode:               QGCLabel.WrapAnywhere
                 color:             qgcPal.buttonText
                 QGCMouseArea{
                     anchors.fill:parent
                     onClicked: {
                          toolDrawerSelectLoader.sourceComponent = versionView

                     }
                }
            }

        }
    }
    Loader {
        id:             toolDrawerSelectLoader
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.top:    toolDrawerSelectToolbar.bottom
        anchors.bottom: parent.bottom

    }
    //默认是连接界面
     Component.onCompleted: toolDrawerSelectLoader.sourceComponent =connectView
    Component {
        id:connectView
       ConnectView {
           anchors.fill:parent
        }
    }
    Component {
        id:setupView
       SetupView {
           anchors.fill:parent
        }
    }
    Component {
        id:versionView
        VersionView {
            anchors.fill:parent
        }
    }
}


   // Component.onCompleted: toolDrawerSelectLoader.sourceComponent

