import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs  1.2
import QtQuick.Layouts  1.2
import QtQuick.Controls.Styles  1.4

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Palette       1.0

//相关文件详见 LinkManager.cc
//新的连接界面2022 9.28重构视图
Rectangle {
    id:                 _linkRoot
    color:              qgcPal.window
    anchors.fill:       parent
    anchors.margins:    ScreenTools.defaultFontPixelWidth
    property var  _currentSelection:     null
    property int  _firstColumnWidth:     ScreenTools.defaultFontPixelWidth * 12
    property int  _secondColumnWidth:    ScreenTools.defaultFontPixelWidth * 30
    property int  _rowSpacing:           ScreenTools.defaultFontPixelHeight / 2
    property int  _colSpacing:           ScreenTools.defaultFontPixelWidth / 2
    property real _margin:               ScreenTools.defaultFontPixelWidth / 2

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

    function openCommSettings(originalLinkConfig,Linktype) {
        settingsLoader.originalLinkConfig = originalLinkConfig
        if (originalLinkConfig) {
            // Editing existing link config
            settingsLoader.editingConfig = QGroundControl.linkManager.startConfigurationEditing(originalLinkConfig)
        } else {

            // Create new link configuration
            //
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
                return "串口"
            case 1:
               return  "UDP"
            case 2:
               return  "TCP"
            case 3:
                return  "蓝牙"
            default:
                return  "其他"
        }
    }
    //左侧显示连接类型
    GridLayout {
       id :selectLinkType
       //四种连接方式 蓝牙  串口  TCP
       anchors.top :parent.top
       anchors.bottom:buttonRow.top
       anchors.bottomMargin: _margin
       anchors.left:parent.left
       width:parent.width/2
       columns : 2
       rowSpacing : 5
       columnSpacing : 5
      QGCButton {
           id : serialLinkIcon
           text:"串口连接"
           Layout.fillHeight: true
           Layout.fillWidth: true
           //iconSource:"qrc:/qmlimages/resources/ImageRes/chuankou.svg"
       }
       QGCButton {
           id : tcpLinkIcon
           text:"TCP连接"
           Layout.fillHeight: true
           Layout.fillWidth: true
           //iconSource:"qrc:/qmlimages/resources/ImageRes/com002.svg"
       }
       QGCButton {
           id : udpLinkIcon
           text:"UDP连接"
           Layout.fillHeight: true
           Layout.fillWidth: true
           //iconSource:"qrc:/qmlimages/resources/ImageRes/com002.svg"
       }
      QGCButton {
           id : bluetoothLinkIcon
           text:"蓝牙连接"
           Layout.fillHeight: true
           Layout.fillWidth: true
           onClicked:  _linkRoot.openCommSettings(_currentSelection)
           //iconSource:"qrc:/qmlimages/resources/ImageRes/lanya.svg"
       }
    }
     //复选table 显示每一个连接
    QGCFlickable {
        clip:               true
        id :                serialLinkFlick
        anchors.top:        parent.top
        anchors.margins: 5
        anchors.left: selectLinkType.right
        anchors.right:parent.right
        height:             (parent.height - buttonRow.height)/2
        contentHeight:      settingsColumn.height
        contentWidth:       parent.width*0.5
        anchors.verticalCenter: parent.verticalCenter
        flickableDirection: Flickable.VerticalFlick
        //显示连接
        Column {
            id:        settingsColumn
            anchors.left:parent.left
            anchors.right:parent.right
            anchors.margins:    ScreenTools.defaultFontPixelWidth
            anchors.verticalCenter: parent.verticalCenter
            spacing:            ScreenTools.defaultFontPixelHeight/2
            property string linktypeString:  "其他"
            Repeater {
                model: QGroundControl.linkManager.linkConfigurations
                delegate:
                    Rectangle {
                        width:                      parent.width
                        height  :25
                        visible:                    !object.dynamic
                        color:"gray"
                        radius:         3
                         border.width: 1
                         border.color: "white"
                         anchors.horizontalCenter:   parent.horizontalCenter
                         RowLayout {
                             spacing:0
                            //LinkName
                            anchors.fill: parent
                            QGCLabel{
                                text:showLinkType(object.linkType)
                                color:"white"
                            }
                            //切换是否自动连接
                            SwitchButton{
                                id:isAutoConnect
                                text: qsTr("自动")
                                checkedColor: "#003221"
                                checked: object.autoConnect
                                onCheckedChanged:  object.autoConnect = checked
                            }
                            //连接
                            SwitchButton{
                                id:isConnect
                                text: qsTr("连接")
                                checkedColor: "#003221"
                                checked:false
                                onClicked: {
                                    if(checked){
                                        QGroundControl.linkManager.createConnectedLink(object)
                                    }
                                    else {
                                        object.link.disconnect()
                                    }
                                }
                            }
                            QGCColoredImage {
                                id:                     deleteButton
                                height:                 20
                                width:                  height
                                sourceSize.height:      height
                                fillMode:               Image.PreserveAspectFit
                                mipmap:                 true
                                smooth:                 true
                                color:                  "white"
                                visible:                visible
                                source:                 "/res/TrashDelete.svg"
                                QGCMouseArea {
                                    fillItem:   parent
                                    onClicked:  deleteDialogs.visible = true
                                }
                                MessageDialog {
                                    id:         deleteDialogs
                                    visible:    false
                                    icon:       StandardIcon.Warning
                                    standardButtons: StandardButton.Yes | StandardButton.No
                                    title:      qsTr("Remove Link Configuration")
                                    text:       object ? qsTr("Remove %1. Is this really what you want?").arg(object.name) : ""
                                    onYes: {
                                        QGroundControl.linkManager.removeConfiguration(object)
                                        object = null
                                        deleteDialogs.visible = false
                                    }
                                    onNo: deleteDialogs.visible = false
                                }
                            }
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

