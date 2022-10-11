/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs  1.2
import QtQuick.Layouts  1.2

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Palette       1.0

//关联文件//LinkManager.cc

//2022 9.28重构
Rectangle {
    id:                 _linkRoot
    color:              qgcPal.window
    anchors.fill:       parent
    anchors.margins:    ScreenTools.defaultFontPixelWidth
    property var _currentSelection:     null
    property int _firstColumnWidth:     ScreenTools.defaultFontPixelWidth * 12
    property int _secondColumnWidth:    ScreenTools.defaultFontPixelWidth * 30
    property int _rowSpacing:           ScreenTools.defaultFontPixelHeight / 2
    property int _colSpacing:           ScreenTools.defaultFontPixelWidth / 2

//    function  filterLinkType(linklistmodel){
//      while(linklistmodel.count){
//          console.log(linklistmodel.get(linklistmodel.count).name)
//          linklistmodel.count--
//      }
//   }
    QGCPalette {
        id:                 qgcPal
        colorGroupEnabled:  enabled
    }

    function openCommSettings(originalLinkConfig) {
        settingsLoader.originalLinkConfig = originalLinkConfig
        if (originalLinkConfig) {
            // Editing existing link config
            settingsLoader.editingConfig = QGroundControl.linkManager.startConfigurationEditing(originalLinkConfig)
        } else {
            // Create new link configuration
            settingsLoader.editingConfig = QGroundControl.linkManager.createConfiguration(ScreenTools.isSerialAvailable ? LinkConfiguration.TypeSerial : LinkConfiguration.TypeUdp, "")
        }
        settingsLoader.sourceComponent = commSettings
    }

    Component.onDestruction: {
        if (settingsLoader.sourceComponent) {
            settingsLoader.sourceComponent = null
            QGroundControl.linkManager.cancelConfigurationEditing(settingsLoader.editingConfig)
        }
    }

    function showLinkType(linktype){
        switch(linktype){
            case 0:
                return "串口连接"
            case 1:
               return  "UDP连接"
            case 2:
               return  "TCP连接"
            case 3:
                return  "蓝牙"
            default:
                return  "其他"
        }
    }
     //显示每一个连接
    QGCFlickable {
        clip:               true
        id :                serialLinkFlick
        anchors.top:        parent.top
        anchors.topMargin:  30
        width:              parent.width
        height:             (parent.height - buttonRow.height)/2
        contentHeight:      settingsColumn.height
        contentWidth:       parent.width
        anchors.verticalCenter: parent.verticalCenter
        flickableDirection: Flickable.VerticalFlick
        Rectangle{
            anchors.fill: parent;
            border.width: 1;
            color: "white";
        }
        Column {
            id:                 settingsColumn
            width:              _linkRoot.width
            anchors.margins:    ScreenTools.defaultFontPixelWidth
            anchors.verticalCenter: parent.verticalCenter
            spacing:            ScreenTools.defaultFontPixelHeight/2
            property string linktypeString:  "其他"
            Repeater {
                model: QGroundControl.linkManager.linkConfigurations
                delegate:
                   //2022818添加自动连接和手动连接功能
                   //2022819添加显示连接类型
                    QGCButton {
                        anchors.horizontalCenter:   settingsColumn.horizontalCenter
                        width:                      settingsColumn.width
                        autoExclusive:              true
                        visible:                    !object.dynamic
                    Text {
                        anchors.left:parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text:showLinkType(object.linkType)+"  ID: "+object.name
                    }
                    CheckBox {
                       anchors.verticalCenter: parent.verticalCenter
                       anchors.right: _linkButton.left
                       text: qsTr("自动");
                       checked:            object.autoConnect
                       onCheckedChanged:   object.autoConnect = checked
                    }
                    Button {
                         id: _linkButton
                         anchors.verticalCenter: parent.verticalCenter
                         anchors.right : parent.right
                         anchors.rightMargin:  10
                         text: qsTr("连接");
                         onClicked: {
                             checked = true
                             _currentSelection = object
                             QGroundControl.linkManager.createConnectedLink(_currentSelection)
                         }
                    }
                    onClicked: {
                        checked = true
                        _currentSelection = object
                    }
                }
            }
        }
    }


    //底部的新建//删除//断开
    Row {
        id:                 buttonRow
        spacing:            ScreenTools.defaultFontPixelWidth
        anchors.bottom:     parent.bottom
        anchors.margins:    ScreenTools.defaultFontPixelWidth
        anchors.horizontalCenter: parent.horizontalCenter
        QGCButton {
            width:      ScreenTools.defaultFontPixelWidth * 10
            text:       qsTr("Delete")
            enabled:    _currentSelection && !_currentSelection.dynamic
            onClicked:  deleteDialog.visible = true

            MessageDialog {
                id:         deleteDialog
                visible:    false
                icon:       StandardIcon.Warning
                standardButtons: StandardButton.Yes | StandardButton.No
                title:      qsTr("Remove Link Configuration")
                text:       _currentSelection ? qsTr("Remove %1. Is this really what you want?").arg(_currentSelection.name) : ""

                onYes: {
                    QGroundControl.linkManager.removeConfiguration(_currentSelection)
                    _currentSelection = null
                    deleteDialog.visible = false
                }
                onNo: deleteDialog.visible = false
            }
        }
        QGCButton {
            text:       qsTr("Edit")
            visible :   false
            enabled:    _currentSelection && !_currentSelection.link
            onClicked:  _linkRoot.openCommSettings(_currentSelection)
        }

        QGCButton {
            text:       qsTr("新建连接")
            onClicked:  _linkRoot.openCommSettings(null)
        }
//       QGCButton {
//          text:       qsTr("Connect")
//          enabled:    _currentSelection && !_currentSelection.link
//          onClicked:  QGroundControl.linkManager.createConnectedLink(_currentSelection)
//        }
        QGCButton {
            text:       qsTr("Disconnect")
            enabled:    _currentSelection && _currentSelection.link
            onClicked:  _currentSelection.link.disconnect()
        }
//        QGCButton {
//            text:       qsTr("MockLink Options")
//            visible:    _currentSelection && _currentSelection.link && _currentSelection.link.isMockLink
//            onClicked:  mainWindow.showPopupDialogFromSource("qrc:/unittest/MockLinkOptionsDlg.qml", { link: _currentSelection.link })
//        }
    }
    Loader {
        id:             settingsLoader
        anchors.fill:   parent
        visible:        sourceComponent ? true : false
        property var originalLinkConfig:    null
        property var editingConfig:      null
    }
    //---------------------------------------------
    // Comm Settings
    Component {
        id: commSettings
        Rectangle {
            id:             settingsRect
            color:          qgcPal.window
            anchors.fill:   parent
            property real   _panelWidth:    width * 0.8

            QGCFlickable {
                id:                 settingsFlick
                clip:               true
                anchors.fill:       parent
                anchors.margins:    ScreenTools.defaultFontPixelWidth
                contentHeight:      mainLayout.height
                contentWidth:       mainLayout.width
                //
                ColumnLayout {
                    id:         mainLayout
                    spacing:    _rowSpacing

                    QGCGroupBox {
                        title: originalLinkConfig ? qsTr("Edit Link Configuration Settings") : qsTr("Create New Link Configuration")

                        ColumnLayout {
                            spacing: _rowSpacing

                            GridLayout {
                                columns:        2
                                columnSpacing:  _colSpacing
                                rowSpacing:     _rowSpacing

                                QGCLabel { text: qsTr("连接命名") }
                                QGCTextField {
                                    id:                     nameField
                                    Layout.preferredWidth:  _secondColumnWidth
                                    Layout.fillWidth:       true
                                    text:                   editingConfig.name===""? showLinkType(editingConfig.linkType):editingConfig.name
                                    //placeholderText:        qsTr("Enter name")
                                }

                                QGCCheckBox {
                                    Layout.columnSpan:  2
                                    text:               qsTr("Automatically Connect on Start")
                                    checked:            editingConfig.autoConnect
                                    onCheckedChanged:   editingConfig.autoConnect = checked
                                }

                                QGCCheckBox {
                                    Layout.columnSpan:  2
                                    text:               qsTr("High Latency")
                                    checked:            editingConfig.highLatency
                                    onCheckedChanged:   editingConfig.highLatency = checked
                                }

                                QGCLabel { text: qsTr("连接类型") }
                                QGCComboBox {
                                    Layout.preferredWidth:  _secondColumnWidth
                                    Layout.fillWidth:       true
                                    enabled:                originalLinkConfig == null
                                    model:                  QGroundControl.linkManager.linkTypeStrings
                                    currentIndex:           editingConfig.linkType

                                    onActivated: {
                                        if (index !== editingConfig.linkType) {
                                            // Save current name
                                            var name = nameField.text
                                            // Create new link configuration
                                            editingConfig = QGroundControl.linkManager.createConfiguration(index, name)
                                            nameField.text   =   showLinkType(editingConfig.linkType)
                                        }
                                    }
                                }
                            }

                            Loader {
                                id:     linksettingsLoader
                                source: subEditConfig.settingsURL
                                property var subEditConfig: editingConfig
                            }
                        }
                    }

                    RowLayout {
                        Layout.alignment:   Qt.AlignHCenter
                        spacing:            _colSpacing

                        QGCButton {
                            width:      ScreenTools.defaultFontPixelWidth * 10
                            text:       qsTr("OK")
                            enabled:    nameField.text !== ""
                            onClicked: {
                                // Save editing
                                linksettingsLoader.item.saveSettings()
                                editingConfig.name = nameField.text
                                settingsLoader.sourceComponent = null
                                if (originalLinkConfig) {
                                    QGroundControl.linkManager.endConfigurationEditing(originalLinkConfig, editingConfig)
                                } else {
                                    // If it was edited, it's no longer "dynamic"
                                    editingConfig.dynamic = false
                                    QGroundControl.linkManager.endCreateConfiguration(editingConfig)
                                }
                            }
                        }
                        QGCButton {
                            width:      ScreenTools.defaultFontPixelWidth * 10
                            text:       qsTr("Cancel")
                            onClicked: {

                                settingsLoader.sourceComponent = null
                                QGroundControl.linkManager.cancelConfigurationEditing(settingsLoader.editingConfig)
                            }
                        }
                    }
                }
            }
        }
    }
}

