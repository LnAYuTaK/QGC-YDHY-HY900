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
    dragMargin:     -10
    modal: true
    opacity : 0.99
    interactive : true
    closePolicy:  Popup.CloseOnEscape | Popup.CloseOnPressOutside

    TabBar {
        id: bar
        width: parent.width
        currentIndex:swipeView.currentIndex
        TabButton {
            text: qsTr("通信连接")
        }
        TabButton {
            text: qsTr("飞控参数")
        }
        TabButton {
            text: qsTr("版本更新")
        }
    }
    SwipeView  {
        id :swipeView
        width: parent.width
        anchors.top: bar.bottom
        height: parent.height
        clip: true
        currentIndex: bar.currentIndex
        ConnectView {
            id:connectView
        }
        ParameterEditor {
            id:setUpView
        }
        VersionView {
            id:versionView
        }
    }
}

   // Component.onCompleted: toolDrawerSelectLoader.sourceComponent

