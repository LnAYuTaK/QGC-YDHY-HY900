import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2

import QGroundControl                   1.0
import QGroundControl.ScreenTools       1.0
import QGroundControl.Vehicle           1.0
import QGroundControl.Controls          1.0
import QGroundControl.FactControls      1.0
import QGroundControl.Palette           1.0
import QGroundControl.SettingsManager   1.0
import QGroundControl.Controllers       1.0

// Editor for Mission Settings
Rectangle {
    id:                 valuesRect
    width:              availableWidth
    height:             valuesColumn.height + (_margin * 2)
    color :"transparent"
    visible:true//visible:            missionItem.isCurrentItem
    radius:             _radius
    property var    _masterControler:               masterController
    property var    _missionController:             _masterControler.missionController
    property var    _controllerVehicle:             _masterControler.controllerVehicle
    property bool   _vehicleHasHomePosition:        _controllerVehicle.homePosition.isValid
    property bool   _showCruiseSpeed:               !_controllerVehicle.multiRotor
    property bool   _showHoverSpeed:                _controllerVehicle.multiRotor || _controllerVehicle.vtol
    property bool   _multipleFirmware:              !QGroundControl.singleFirmwareSupport
    property bool   _multipleVehicleTypes:          !QGroundControl.singleVehicleSupport
    property real   _fieldWidth:                    ScreenTools.defaultFontPixelWidth * 16
    property bool   _mobile:                        ScreenTools.isMobile
    property var    _savePath:                      QGroundControl.settingsManager.appSettings.missionSavePath
    property var    _fileExtension:                 QGroundControl.settingsManager.appSettings.missionFileExtension
    property var    _appSettings:                   QGroundControl.settingsManager.appSettings
    property bool   _waypointsOnlyMode:             QGroundControl.corePlugin.options.missionWaypointsOnly
    property bool   _showCameraSection:             (_waypointsOnlyMode || QGroundControl.corePlugin.showAdvancedUI) && !_controllerVehicle.apmFirmware
    property bool   _simpleMissionStart:            QGroundControl.corePlugin.options.showSimpleMissionStart
    property bool   _showFlightSpeed:               !_controllerVehicle.vtol && !_simpleMissionStart && !_controllerVehicle.apmFirmware
    property bool   _allowFWVehicleTypeSelection:   _noMissionItemsAdded && !globals.activeVehicle

    readonly property string _firmwareLabel:    qsTr("Firmware")
    readonly property string _vehicleLabel:     qsTr("Vehicle")
    readonly property real   _margin:            ScreenTools.defaultFontPixelWidth / 2
    readonly property real    defalutSize:       ScreenTools.defaultFontPixelWidth

    QGCPalette { id: qgcPal }
    QGCFileDialogController { id: fileController }
    Component { id: altModeDialogComponent; AltModeDialog { } }

    Connections {
        target: _controllerVehicle
        function onSupportsTerrainFrameChanged() {
            if (!_controllerVehicle.supportsTerrainFrame && _missionController.globalAltitudeMode === QGroundControl.AltitudeModeTerrainFrame) {
                _missionController.globalAltitudeMode = QGroundControl.AltitudeModeCalcAboveTerrain
            }
        }
    }
    ColumnLayout {
        id:                 valuesColumn
        anchors.margins:    _margin
        anchors.left:       parent.left
        anchors.right:      parent.right
        anchors.top:        parent.top
        spacing:            _margin
//      MouseArea {
//            visible: false
//            Layout.preferredWidth:  childrenRect.width
//            Layout.preferredHeight: childrenRect.height
//            enabled:                _noMissionItemsAdded

//            onClicked: {
//                var removeModes = []
//                var updateFunction = function(altMode){ _missionController.globalAltitudeMode = altMode }
//                if (!_controllerVehicle.supportsTerrainFrame) {
//                    removeModes.push(QGroundControl.AltitudeModeTerrainFrame)
//                }
//                altModeDialogComponent.createObject(mainWindow, { rgRemoveModes: removeModes, updateAltModeFn: updateFunction }).open()
//            }
//            RowLayout {
//                spacing: ScreenTools.defaultFontPixelWidth
//                enabled: _noMissionItemsAdded
//                QGCLabel {
//                    id:     altModeLabel
//                    text:   QGroundControl.altitudeModeShortDescription(_missionController.globalAltitudeMode)
//                }
//                //不显示
//                QGCColoredImage {
//                    height:     ScreenTools.defaultFontPixelHeight / 2
//                    width:      height
//                    source:     "/res/DropArrow.svg"
//                    color:      altModeLabel.color
//                    visible:    false
//                }
//            }
//        }
       // 加载航点文件 保存航点文件
       RowLayout{
            id :missionLayerBtnGrounp
            Layout.preferredWidth:  childrenRect.width
            //columnSpacing:      ScreenTools.defaultFontPixelWidth
            //rowSpacing:         columnSpacing
            //columns : 2
            QGCButton {
                text:           qsTr("加载航点文件")
                Layout.fillWidth: true
                backRadius:     4
                heightFactor:   0.3333
                showBorder:     true
                onClicked: {
                    mainWindow._planView._planMasterController.loadFromSelectedFile()
                }
           }
            QGCButton {
                text:           qsTr("保存航点文件")
                backRadius:     4
                Layout.fillWidth: true
                heightFactor:   0.3333
                showBorder:     true
                onClicked: {
                    mainWindow._planView._planMasterController.saveToSelectedFile()
                }
            }
            QGCButton {
                text:           qsTr("获取任务文件")
                backRadius:     4
                Layout.fillWidth: true
                heightFactor:   0.3333
                showBorder:     true
                onClicked: {
//                    mainWindow._planView._planMasterController.saveToSelectedFile()
                }
            }
        }
        //清空航点------读取航点------写入航点
        RowLayout{
            Layout.preferredWidth:  childrenRect.width
            QGCButton {
                text:           qsTr("清空航点")
                Layout.fillWidth: true
                backRadius:     4
                heightFactor:   0.3333
                showBorder:     true
                onClicked: {
                //清空航点除了一号航点
                var allVisualItemCount = _missionController.visualItems.count
                if(allVisualItemCount>0) {
                    var indexIedor = 0
                    while(indexIedor!==allVisualItemCount) {
                        _missionController.removeVisualItem(allVisualItemCount)
                        allVisualItemCount--;
                    }
                }
                else {
                    return
                }
              }
            }
            QGCButton {
                text:           qsTr("读取航点")
                Layout.fillWidth: true
                backRadius:     4
                heightFactor:   0.3333
                showBorder:     true
                onClicked: {
                    mainWindow._planView.downloadClicked("读取航点")
                }
                highlighted : true
            }
            QGCButton {
                text:           qsTr("写入航线")
                Layout.fillWidth: true
                backRadius:     4
                heightFactor:   0.3333
                showBorder:     true
                onClicked: {
                    return
                }
            }
        }
        //默认高度  ---   航程
        RowLayout{
            //Layout.fillWidth:   true
            Layout.preferredWidth:  childrenRect.width
            RowLayout {
                QGCLabel {
                    text:           qsTr("默认高度")
                    font.pointSize: ScreenTools.defaultFontPointSize*1.5
                    color:"white"
                    font.weight:Font.DemiBold
                }
                FactTextField {
                    Layout.fillWidth:   true
                    visible:            true
                    fact:   QGroundControl.settingsManager.appSettings.defaultMissionItemAltitude
                }
             }
             RowLayout{
                Layout.fillWidth:   true
        //            columnSpacing:      ScreenTools.defaultFontPixelWidth
        //            rowSpacing:         columnSpacing
        //            columns:            2
                QGCLabel {
                    text:           qsTr("航程")
                    font.pointSize: ScreenTools.defaultFontPointSize*1.5
                    color:"white"
                    font.weight:Font.DemiBold

                }
                QGCTextField {
                    Layout.fillWidth:   true
                    text:String(_missionController.missionDistance)
                    enabled:            false
                    clip:true
                }
              }
            }
            //参数类别
            RowLayout{
                Layout.fillWidth: parent
//                Layout.preferredWidth:  childrenRect.width
                spacing :ScreenTools.comboBoxPadding*2
                RowLayout{
                    spacing:0
                    QGCLabel {
                        text:           qsTr("序号")
                        Layout.preferredWidth:ScreenTools.defaultFontPixelWidth *7
                        color:"white"
                        font.weight:Font.DemiBold
                    }
                    QGCLabel {
                        text:           qsTr("类型")
                        Layout.preferredWidth:ScreenTools.defaultFontPixelWidth *7
                        color:"white"
                        font.weight:Font.DemiBold
                    }
                }
                QGCLabel {
                    text:           qsTr("经度")
                    Layout.preferredWidth:ScreenTools.defaultFontPixelWidth *7
                    color:"white"
                    font.weight:Font.DemiBold
                }
                QGCLabel {
                    text:           qsTr("纬度")
                    Layout.preferredWidth:ScreenTools.defaultFontPixelWidth *7
                    color:"white"
                    font.weight:Font.DemiBold
                }
                QGCLabel {
                    text:           qsTr("高度")
                    Layout.preferredWidth:ScreenTools.defaultFontPixelWidth *7
                    color:"white"
                    font.weight:Font.DemiBold
                }
                QGCLabel {
                    text:           qsTr("参数1")
                    Layout.preferredWidth:ScreenTools.defaultFontPixelWidth *7
                    color:"white"
                    font.weight:Font.DemiBold
                }
            }

//                QGCCheckBox {
//                    id:         flightSpeedCheckBox
//                    text:       qsTr("Flight speed")
//                    visible:    _showFlightSpeed
//                    checked:    missionItem.speedSection.specifyFlightSpeed
//                    onClicked:   missionItem.speedSection.specifyFlightSpeed = checked
//                }
//                FactTextField {
//                    Layout.fillWidth:   true
//                    fact:               missionItem.speedSection.flightSpeed
//                    visible:            _showFlightSpeed
//                    enabled:            flightSpeedCheckBox.checked
//                }

//        GridLayout {
//            Layout.fillWidth:   true
//            columnSpacing:      ScreenTools.defaultFontPixelWidth
//            rowSpacing:         columnSpacing
//            columns:            2
//            visible:            false
//            QGCCheckBox {
//                id:         flightSpeedCheckBox
//                text:       qsTr("Flight speed")
//                visible:    _showFlightSpeed
//                checked:    missionItem.speedSection.specifyFlightSpeed
//                onClicked:   missionItem.speedSection.specifyFlightSpeed = checked
//            }
//            FactTextField {
//                Layout.fillWidth:   true
//                fact:               missionItem.speedSection.flightSpeed
//                visible:            _showFlightSpeed
//                enabled:            flightSpeedCheckBox.checked
//            }
//        }


     //下面的是除了MissionStart之外的
      Column {
            Layout.fillWidth:   true
            spacing:            _margin
            visible:           false /*!_simpleMissionStart*/
            CameraSection {
                id:         cameraSection
                checked:    !_waypointsOnlyMode && missionItem.cameraSection.settingsSpecified
                visible:    false//_showCameraSection
            }
            QGCLabel {
                anchors.left:           parent.left
                anchors.right:          parent.right
                text:                   qsTr("Above camera commands will take affect immediately upon mission start.")
                wrapMode:               Text.WordWrap
                horizontalAlignment:    Text.AlignHCenter
                font.pointSize:         ScreenTools.smallFontPointSize
                visible:                false//_showCameraSection && cameraSection.checked
            }

            SectionHeader {
                id:             vehicleInfoSectionHeader
                anchors.left:   parent.left
                anchors.right:  parent.right
                text:           qsTr("Vehicle Info")
                visible:        false//!_waypointsOnlyMode
                checked:        false
            }
            GridLayout {
                anchors.left:   parent.left
                anchors.right:  parent.right
                columnSpacing:  ScreenTools.defaultFontPixelWidth
                rowSpacing:     columnSpacing
                columns:        2
                visible:        false//vehicleInfoSectionHeader.visible && vehicleInfoSectionHeader.checked
                QGCLabel {
                    text:               _firmwareLabel
                    Layout.fillWidth:   true
                    visible:            _multipleFirmware
                }
                FactComboBox {
                    fact:                   QGroundControl.settingsManager.appSettings.offlineEditingFirmwareClass
                    indexModel:             false
                    Layout.preferredWidth:  _fieldWidth
                    visible:                _multipleFirmware && _allowFWVehicleTypeSelection
                }
                QGCLabel {
                    text:       _controllerVehicle.firmwareTypeString
                    visible:    _multipleFirmware && !_allowFWVehicleTypeSelection
                }

                QGCLabel {
                    text:               _vehicleLabel
                    Layout.fillWidth:   true
                    visible:            _multipleVehicleTypes
                }
                FactComboBox {
                    fact:                   QGroundControl.settingsManager.appSettings.offlineEditingVehicleClass
                    indexModel:             false
                    Layout.preferredWidth:  _fieldWidth
                    visible:                _multipleVehicleTypes && _allowFWVehicleTypeSelection
                }
                QGCLabel {
                    text:       _controllerVehicle.vehicleTypeString
                    visible:    _multipleVehicleTypes && !_allowFWVehicleTypeSelection
                }

                QGCLabel {
                    Layout.columnSpan:      2
                    Layout.alignment:       Qt.AlignHCenter
                    Layout.fillWidth:       true
                    wrapMode:               Text.WordWrap
                    font.pointSize:         ScreenTools.smallFontPointSize
                    text:                   qsTr("The following speed values are used to calculate total mission time. They do not affect the flight speed for the mission.")
                    visible:                _showCruiseSpeed || _showHoverSpeed
                }
                QGCLabel {
                    text:               qsTr("Cruise speed")
                    visible:            _showCruiseSpeed
                    Layout.fillWidth:   true
                }
                FactTextField {
                    fact:                   QGroundControl.settingsManager.appSettings.offlineEditingCruiseSpeed
                    visible:                _showCruiseSpeed
                    Layout.preferredWidth:  _fieldWidth
                }
                QGCLabel {
                    text:               qsTr("Hover speed")
                    visible:            _showHoverSpeed
                    Layout.fillWidth:   true
                }
                FactTextField {
                    fact:                   QGroundControl.settingsManager.appSettings.offlineEditingHoverSpeed
                    visible:                _showHoverSpeed
                    Layout.preferredWidth:  _fieldWidth
                }
            }
            SectionHeader {
                id:             plannedHomePositionSection
                anchors.left:   parent.left
                anchors.right:  parent.right
                text:           qsTr("Launch Position")
                visible:        false// !_vehicleHasHomePosition
                checked:        false
            }
            Column {
                anchors.left:   parent.left
                anchors.right:  parent.right
                spacing:        _margin
                visible:        false// plannedHomePositionSection.checked && !_vehicleHasHomePosition
                GridLayout {
                    anchors.left:   parent.left
                    anchors.right:  parent.right
                    columnSpacing:  ScreenTools.defaultFontPixelWidth
                    rowSpacing:     columnSpacing
                    columns:        2 
                    QGCLabel {
                        text: qsTr("Altitude")
                    }
                    FactTextField {
                        fact:               missionItem.plannedHomePositionAltitude
                        Layout.fillWidth:   true
                    }
                }
                QGCLabel {
                    width:                  parent.width
                    wrapMode:               Text.WordWrap
                    font.pointSize:         ScreenTools.smallFontPointSize
                    text:                   qsTr("Actual position set by vehicle at flight time.")
                    horizontalAlignment:    Text.AlignHCenter
                }
                QGCButton {
                    text:                       qsTr("Set To Map Center")
                    onClicked:                  missionItem.coordinate = map.center
                    anchors.horizontalCenter:   parent.horizontalCenter
                }
            }
        } // Column
    } // Column
} // Rectangle
