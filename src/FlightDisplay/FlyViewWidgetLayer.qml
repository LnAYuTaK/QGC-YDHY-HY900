/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.12
import QtQuick.Controls         2.4
import QtQuick.Dialogs          1.3
import QtQuick.Layouts          1.12

import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Window           2.2
import QtQml.Models             2.1
import QtGraphicalEffects      1.15

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Airspace      1.0
import QGroundControl.Airmap        1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0
import QGroundControl.MenuTool      1.0

import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Layouts          1.2

// This is the ui overlay layer for the widgets/tools for Fly View
Item {
    id: _root

    property var    parentToolInsets
    property var    totalToolInsets:        _totalToolInsets
    property var    mapControl
    property var    parameterView   :        parameterView

    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property var    _planMasterController:  globals.planMasterControllerFlyView
    property var    _missionController:     _planMasterController.missionController
    property var    _geoFenceController:    _planMasterController.geoFenceController
    property var    _rallyPointController:  _planMasterController.rallyPointController
    property var    _guidedController:      globals.guidedControllerFlyView
    property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75
    property rect   _centerViewport:        Qt.rect(0, 0, width, height)
    property real   _rightPanelWidth:       ScreenTools.defaultFontPixelWidth * 10
    property real   _defaltPixSize:         ScreenTools.defaultFontPixelWidth

    QGCToolInsets {
        id:                     _totalToolInsets
        leftEdgeTopInset:       toolStrip.leftInset
        leftEdgeCenterInset:    toolStrip.leftInset
        leftEdgeBottomInset:    parentToolInsets.leftEdgeBottomInset
        rightEdgeTopInset:      parentToolInsets.rightEdgeTopInset
        rightEdgeCenterInset:   parentToolInsets.rightEdgeCenterInset
        rightEdgeBottomInset:   parentToolInsets.rightEdgeBottomInset
        topEdgeLeftInset:       parentToolInsets.topEdgeLeftInset
        topEdgeCenterInset:     parentToolInsets.topEdgeCenterInset
        topEdgeRightInset:      parentToolInsets.topEdgeRightInset
        bottomEdgeLeftInset:    parentToolInsets.bottomEdgeLeftInset
        bottomEdgeCenterInset:  mapScale.centerInset
        bottomEdgeRightInset:   0
    }

    FlyViewMissionCompleteDialog {
        missionController:      _missionController
        geoFenceController:     _geoFenceController
        rallyPointController:   _rallyPointController
    }

    Row {
        id:                 multiVehiclePanelSelector
        anchors.margins:    _toolsMargin
        anchors.top:        parent.top
        anchors.right:      parent.right
        width:              _rightPanelWidth
        spacing:            ScreenTools.defaultFontPixelWidth
        visible:            QGroundControl.multiVehicleManager.vehicles.count > 1 && QGroundControl.corePlugin.options.flyView.showMultiVehicleList

        property bool showSingleVehiclePanel:  !visible || singleVehicleRadio.checked

        QGCMapPalette { id: mapPal; lightColors: true }

        QGCRadioButton {
            id:             singleVehicleRadio
            text:           qsTr("Single")
            checked:        true
            textColor:      mapPal.text
        }

        QGCRadioButton {
            text:           qsTr("Multi-Vehicle")
            textColor:      mapPal.text
        }
    }

    MultiVehicleList {
        anchors.margins:    _toolsMargin
        anchors.top:        multiVehiclePanelSelector.bottom
        anchors.right:      parent.right
        width:              _rightPanelWidth
        height:             parent.height - y - _toolsMargin
        visible:            !multiVehiclePanelSelector.showSingleVehiclePanel
    }

    function parameterVisable(){
        if(parameterView.visible) {
            parameterView.visible = false
            instrumentPanel.visible = false
        }
        else {
            parameterView.visible = true
            instrumentPanel.visible = true
        }
    }

    //罗盘
    FlyViewInstrumentPanel {
        id:                         instrumentPanel
        anchors.top:                parent.top
        anchors.right:              parent.right
        width:                      _rightPanelWidth*1.5
       // spacing:                    _toolsMargin
        visible:                    true
        anchors.horizontalCenter:   parameterView.horizontalCenter
        //availableHeight:            parent.height - y - _toolsMargin
       // property real rightInset: visible ? parent.width - x : 0
    }
    //右侧隐藏参数箭头
    Image {
        id:            currentButton
        anchors.right :  instrumentPanel.visible== true?instrumentPanel.left:parent.right
        source:     instrumentPanel.visible== true? "qrc:/qmlimages/resources/ImageRes/youjiantou.svg":"qrc:/qmlimages/resources/ImageRes/zuojiantou.svg"
        MouseArea{
            anchors.fill :parent
            onClicked: parameterVisable()
        }
    }
    //右侧参数界面
    ParameterView{
             id : parameterView
             anchors.top:          instrumentPanel.bottom
             anchors.right:        parent.right
             anchors.bottom :parent.bottom
             width:                parent.width*0.2
             color:                "black"
             visible:  true
     }
//    QGCPipOverlay {
//        id:                     _pipOverlay
//        anchors.left:           parent.left
//        anchors.right :         widgetLayer.parameterView.left
//        anchors.bottom:         parent.bottom
//        anchors.margins:        _toolsMargin
//        item1IsFullSettingsKey: "MainFlyWindowIsMap"
//        item1:                  mapControl
//        item2:                  QGroundControl.videoManager.hasVideo ? videoControl : null
//        fullZOrder:             _fullItemZorder
//        pipZOrder:              _pipItemZorder
//        show:                   !QGroundControl.videoManager.fullScreen &&
//                                    (videoControl.pipState.state === videoControl.pipState.pipState || mapControl.pipState.state === mapControl.pipState.pipState)
//    }
//    PhotoVideoControl {
//        id:                     photoVideoControl
//        anchors.margins:        _toolsMargin
//        anchors.right:          parent.right
//        width:                  _rightPanelWidth
//        state:                  _verticalCenter ? "verticalCenter" : "topAnchor"
//        states: [
//            State {
//                name: "verticalCenter"
//                AnchorChanges {
//                    target:                 photoVideoControl
//                    anchors.top:            undefined
//                    anchors.verticalCenter: _root.verticalCenter
//                }
//            },
//            State {
//                name: "topAnchor"
//                AnchorChanges {
//                    target:                 photoVideoControl
//                    anchors.verticalCenter: undefined
//                    anchors.top:            instrumentPanel.bottom
//                }
//            }
//        ]

//        property bool _verticalCenter: !QGroundControl.settingsManager.flyViewSettings.alternateInstrumentPanel.rawValue
//    }


    TelemetryValuesBar {
        id:                 telemetryPanel
        x:                  recalcXPosition()
        anchors.margins:    _toolsMargin
        visible: false
        // States for custom layout support
        states: [
            State {
                name: "bottom"
                when: telemetryPanel.bottomMode

                AnchorChanges {
                    target: telemetryPanel
                    anchors.top: undefined
                    anchors.bottom: parent.bottom
                    anchors.right: undefined
                    anchors.verticalCenter: undefined
                }

                PropertyChanges {
                    target: telemetryPanel
                    x: recalcXPosition()
                }
            },

            State {
                name: "right-video"
                when: !telemetryPanel.bottomMode && photoVideoControl.visible

                AnchorChanges {
                    target: telemetryPanel
                    anchors.top: photoVideoControl.bottom
                    anchors.bottom: undefined
                    anchors.right: parent.right
                    anchors.verticalCenter: undefined
                }
            },

            State {
                name: "right-novideo"
                when: !telemetryPanel.bottomMode && !photoVideoControl.visible

                AnchorChanges {
                    target: telemetryPanel
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        ]

        function recalcXPosition() {
            // First try centered
            var halfRootWidth   = _root.width / 2
            var halfPanelWidth  = telemetryPanel.width / 2
            var leftX           = (halfRootWidth - halfPanelWidth) - _toolsMargin
            var rightX          = (halfRootWidth + halfPanelWidth) + _toolsMargin
            if (leftX >= parentToolInsets.leftEdgeBottomInset || rightX <= parentToolInsets.rightEdgeBottomInset ) {
                // It will fit in the horizontalCenter
                return halfRootWidth - halfPanelWidth
            } else {
                // Anchor to left edge
                return parentToolInsets.leftEdgeBottomInset + _toolsMargin
            }
        }
    }

//虚拟摇杆屏蔽
//-- Virtual Joystick
//    Loader {
//        id:                         virtualJoystickMultiTouch
//        z:                          QGroundControl.zOrderTopMost + 1
//        width:                      parent.width  - (_pipOverlay.width / 2)
//        height:                     Math.min(parent.height * 0.25, ScreenTools.defaultFontPixelWidth * 16)
//        visible:                    _virtualJoystickEnabled && !QGroundControl.videoManager.fullScreen && !(_activeVehicle ? _activeVehicle.usingHighLatencyLink : false)
//        anchors.bottom:             parent.bottom
//        anchors.bottomMargin:       parentToolInsets.leftEdgeBottomInset + ScreenTools.defaultFontPixelHeight * 2
//        anchors.horizontalCenter:   parent.horizontalCenter
//        source:                     "qrc:/qml/VirtualJoystick.qml"
//        active:                     _virtualJoystickEnabled && !(_activeVehicle ? _activeVehicle.usingHighLatencyLink : false)

//        property bool autoCenterThrottle: QGroundControl.settingsManager.appSettings.virtualJoystickAutoCenterThrottle.rawValue

//        property bool _virtualJoystickEnabled: QGroundControl.settingsManager.appSettings.virtualJoystick.rawValue
//    }

    //设置悬浮控制栏//包括打开飞行规划模式和总体控件
//    Rectangle
//    {
//        color:"#1b2538"
//        opacity:  0.7
//        radius:     5
//        border.width:   /*_readyForSave ? 0 : */1
//        border.color:   "black"
//        width:ScreenTools.defaultFontPixelWidth*8
//        height:ScreenTools.defaultFontPixelWidth*20
//        anchors.topMargin: _margins
//        anchors.leftMargin: _margins
//        anchors.top:parent.top
//        anchors.left:parent.left
//        Image {
//                id :menuButton
//                Layout.alignment: Qt.AlignHCenter
//                width:parent.width*0.7
//                height:menuButton.width
//                sourceSize.height:  height
//                source:             "qrc:/qmlimages/resources/ImageRes/shenglve.svg"
//                fillMode:           Image.PreserveAspectFit
//                MouseArea {
//                    anchors.fill:   parent
//                    onClicked:mainWindow.showSetupTool()
//                }
//            }

        QGCToolBarButton {
            id:                     menuToolBarButton
            width:ScreenTools.defaultFontPixelWidth*4
            height:ScreenTools.defaultFontPixelWidth*4
            anchors.leftMargin: _margins
            anchors.top:parent.top
            anchors.left:parent.left
            //修改公司图标
            icon.source:            "qrc:/qmlimages/resources/ImageRes/shenglve.svg"
            logo:                   true
            //2022 8.22
            onClicked:  menuToolStrip.visible ==true ?(menuToolStrip.visible=false): (menuToolStrip.visible=true)
                /*mainWindow.showMenuToolStrip()*/
        }

//        MenuToolStrip{
//            id:menuToolStrip
//            anchors.left:       parent.left
//            anchors.top:menuToolBarButton.bottom
//            anchors.leftMargin: _margins
//            z:                      QGroundControl.zOrderWidgets
//            maxHeight: ScreenTools.defaultFontPixelWidth*30
//            width:ScreenTools.defaultFontPixelWidth*6
//            visible:false
//        }
        Rectangle{
                id:menuToolStrip
                anchors.left:       parent.left
                anchors.top:menuToolBarButton.bottom
                anchors.leftMargin: _margins
                width:ScreenTools.defaultFontPixelWidth*20
                height:ScreenTools.defaultFontPixelWidth*15
                z:   QGroundControl.zOrderWidgets
                color:"#3a4055"
                ColumnLayout{
                    anchors.fill: parent
                    Layout.margins: _margins
                    spacing:        ScreenTools.defaultFontPixelWidth
                    Button {
                        id:                 planViewButton
                        Layout.fillWidth:   true
                        text:               qsTr("航线规划")
                        visible:            QGroundControl.corePlugin.showAdvancedUI
                        onClicked: {
                            if (!mainWindow.preventViewSwitch()) {
                                mainWindow.showPlanView()
                            }
                        }
                        background: Rectangle {
                            layer.effect: DropShadow {
                                verticalOffset: 1
                                color: control.visualFocus ? "#330066ff" : "#aaaaaa"
                                spread: 0.5
                            }
                        }
                    }
                    Button {
                        id:                 commButton
                        Layout.fillWidth:   true
                        text:               qsTr("通讯连接")
                        visible:            QGroundControl.corePlugin.showAdvancedUI
                        onClicked: {
                            if (!mainWindow.preventViewSwitch()) {
                                mainWindow.showConnectView()
                            }
                        }
                        background: Rectangle {
                            layer.effect: DropShadow {
                                verticalOffset: 1
                                color: control.visualFocus ? "#330066ff" : "#aaaaaa"
                                spread: 0.5
                            }
                        }
                    }
                    Button {
                        id:                 settingsButton
                        Layout.fillWidth:   true
                        text:               qsTr("飞控参数")
                        visible:            !QGroundControl.corePlugin.options.combineSettingsAndSetup
                        onClicked: {
                            if (!mainWindow.preventViewSwitch()) {
                                mainWindow.showParameterView()
                            }
                        }
                        background: Rectangle {
                            layer.effect: DropShadow {
                                verticalOffset: 1
                                color: control.visualFocus ? "#330066ff" : "#aaaaaa"
                                spread: 0.5
                            }
                        }
                    }
                    Button {
                        id:                 infoButton
                        Layout.fillWidth:   true
                        text:               qsTr("版本更新")
                        visible:            !QGroundControl.corePlugin.options.combineSettingsAndSetup
                        onClicked: {
                            if (!mainWindow.preventViewSwitch()) {
                                mainWindow.showVersionInfoView()
                            }
                        }
                        background: Rectangle {
                            layer.effect: DropShadow {
                                verticalOffset: 1
                                color: control.visualFocus ? "#330066ff" : "#aaaaaa"
                                spread: 0.5
                            }
                        }
                    }
             }
        }
//           Image {
//                id :planViewDisplay
//                Layout.alignment: Qt.AlignHCenter
//                width:parent.width*0.7
//                height:planViewDisplay.width
//                sourceSize.height:  height
//                source:             "qrc:/qmlimages/resources/ImageRes/renwu.svg"
//                fillMode:           Image.PreserveAspectFit
//                MouseArea {
//                    anchors.fill:   parent
//                    onClicked:mainWindow.showPlanView()
//                }
//            }
//}

    //2022 9.24屏蔽原版QGC任务规划ToolStrip
    FlyViewToolStrip {
         id:                     toolStrip
//         anchors.leftMargin:     _toolsMargin + parentToolInsets.leftEdgeCenterInset
//         anchors.topMargin:      _toolsMargin + parentToolInsets.topEdgeLeftInset
//         anchors.left:           parent.left
//         anchors.top:            currentButton.bottom
         z:                      QGroundControl.zOrderWidgets
         maxHeight:              parent.height - y - parentToolInsets.bottomEdgeLeftInset - _toolsMargin
         visible:                false/*!QGroundControl.videoManager.fullScreen*/
         onDisplayPreFlightChecklist: mainWindow.showPopupDialogFromComponent(preFlightChecklistPopup)
         property real leftInset: x + width
    }

    FlyViewAirspaceIndicator {
        anchors.top:                parent.top
        anchors.topMargin:          ScreenTools.defaultFontPixelHeight * 0.25
        anchors.horizontalCenter:   parent.horizontalCenter
        z:                          QGroundControl.zOrderWidgets
        show:                       mapControl.pipState.state !== mapControl.pipState.pipState
    }
//   提示警告
//    VehicleWarnings {
//        anchors.centerIn:   parent
//        z:                  QGroundControl.zOrderTopMost
//    }

    Component {
        id: preFlightChecklistPopup
             FlyViewPreFlightChecklistPopup {
        }
    }
}
