import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0


//连接界面->   LinkSettingsPage.qml
Rectangle {
    id:     connectView
    color:  qgcPal.window
    z:      QGroundControl.zOrderTopMost

    readonly property real _defaultTextHeight:  ScreenTools.defaultFontPixelHeight
    readonly property real _defaultTextWidth:   ScreenTools.defaultFontPixelWidth
    readonly property real _horizontalMargin:   _defaultTextWidth / 2
    readonly property real _verticalMargin:     _defaultTextHeight / 2

    property int  _buttonHeight:  ScreenTools.defaultFontPixelHeight * 2

    property bool _first: true

    QGCPalette { id: qgcPal }

    Component.onCompleted: {
        //-- Default Settings
        __rightPanel.source = QGroundControl.corePlugin.settingsPages[QGroundControl.corePlugin.defaultSettings].url
    }

    //Header

    ListView{
        id:                 buttonList
        width:              _defaultTextWidth*20
        anchors.topMargin:  _verticalMargin
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        anchors.leftMargin: _horizontalMargin
        anchors.left:       parent.left
        clip:               true
        focus: true

    ColumnLayout {
        id:         buttonColumn
        spacing:    Math.ceil(ScreenTools.defaultFontPixelHeight * 0.25)
        width : parent.width
        property real _maxButtonWidth: 0
        Repeater {
            model:  QGroundControl.corePlugin.settingsPages
            QGCButton {
                height:             _buttonHeight
                text:               modelData.title
                autoExclusive:      true
                Layout.fillWidth:   true
                showBorder :true
                onClicked: {
                    if (mainWindow.preventViewSwitch()) {
                        return
                    }
                    if (__rightPanel.source !== modelData.url) {
                        __rightPanel.source = modelData.url
                    }
                    checked = true
                }
//                Component.onCompleted: {
//                    if(_first) {
//                        _first = false
//                        checked = true
//                    }
//                }
             }
          }
      }
   }

//   QGCFlickable {
//        id:                 buttonList
//        width:              buttonColumn.width
//        anchors.topMargin:  _verticalMargin
//        anchors.top:        parent.top
//        anchors.bottom:     parent.bottom
//        anchors.leftMargin: _horizontalMargin
//        anchors.left:       parent.left
//        contentHeight:      buttonColumn.height + _verticalMargin
//        flickableDirection: Flickable.VerticalFlick
//        clip:               true

//        ColumnLayout {
//            id:         buttonColumn
//            spacing:    _verticalMargin

//            property real _maxButtonWidth: 0

//            Repeater {
//                model:  QGroundControl.corePlugin.settingsPages
//                QGCButton {
//                    height:             _buttonHeight
//                    text:               modelData.title
//                    autoExclusive:      true
//                    Layout.fillWidth:   true
//                    onClicked: {
//                        if (mainWindow.preventViewSwitch()) {
//                            return
//                        }
//                        if (__rightPanel.source !== modelData.url) {
//                            __rightPanel.source = modelData.url
//                        }
//                        checked = true
//                    }
//                    Component.onCompleted: {
//                        if(_first) {
//                            _first = false
//                            checked = true
//                        }
//                    }
//                }
//            }
//        }
//    }

    Rectangle {
        id:                     divider
        anchors.topMargin:      _verticalMargin
        anchors.bottomMargin:   _verticalMargin
        anchors.leftMargin:     _horizontalMargin
        anchors.left:           buttonList.right
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        width:                  2
        color:                  qgcPal.windowShade
    }
    //-- Panel Contents
    Loader {
        id:                     __rightPanel
        anchors.leftMargin:     _horizontalMargin
        anchors.rightMargin:    _horizontalMargin
        anchors.topMargin:      _verticalMargin
        anchors.bottomMargin:   _verticalMargin
        anchors.left:           divider.right
        anchors.right:          parent.right
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
    }
}
