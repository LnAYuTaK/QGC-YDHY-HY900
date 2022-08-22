import QtQml.Models 2.12
import QtQuick          2.3
import QtQuick.Controls 1.2
import QtLocation       5.3
import QtPositioning    5.3
import QtQuick.Layouts  1.2
import QtQuick.Window   2.2

import QGroundControl           1.0
import QGroundControl.Controls  1.0
import QGroundControl.Palette   1.0
import QGroundControl.ScreenTools       1.0
//导航栏内部List
ToolStripActionList {
    id: _root
    signal displayPreFlightChecklist

    model: [
        ToolStripAction {
            text:           qsTr("任务规划")
          iconSource:     "/qmlimages/Plan.svg"
            onTriggered:    mainWindow.showPlanView()
        },
        ToolStripAction {
            text:           qsTr("通信连接")
           iconSource:     "/qmlimages/resources/ImageRes/lianjie.svg"
            onTriggered:    mainWindow.showConnectTool()
        },
        ToolStripAction {
            text:           qsTr("飞控参数")
           iconSource:     "/qmlimages/resources/ImageRes/canshushezhi.svg"
            onTriggered:    mainWindow.showParameterTool()
        },
        ToolStripAction {
            text:           qsTr("版本说明")
            iconSource:     "/qmlimages/resources/ImageRes/banbenxinxi.svg"
            onTriggered:    mainWindow.showVersionView()
        }
    ]
    //版本描述组件
}

