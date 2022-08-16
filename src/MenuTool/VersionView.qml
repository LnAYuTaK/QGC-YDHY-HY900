import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtQml                    2.2

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controls      1.0
import QGroundControl.Palette       1.0
import QGroundControl.Airmap        1.0

//显示当前地面站版本说明更新计划
Rectangle
{
    id:    versionView
    color:  qgcPal.window
    z:      QGroundControl.zOrderTopMost
    property real baseHeight:   ScreenTools.defaultFontPixelHeight

    QGCLabel{
        id  : versionText
        font.pointSize: ScreenTools.defaultFontPointSize*2
        text:"   云都海鹰地面站版本:         Version1.0"
        height : parent.height*0.35
        width :parent.width
        wrapMode: Text.Wrap
    }

    Rectangle {
        id:                     dividerline
        width :parent.width
        anchors.top :versionText.bottom

        anchors.topMargin      :  ScreenTools.defaultFontPixelWidth
        height:                 4
        color:                  qgcPal.windowShade
    }

    QGCLabel{
        id : versionText2
        anchors.top  :  dividerline.bottom
        anchors.topMargin      :  ScreenTools.defaultFontPixelWidth
        font.pointSize: ScreenTools.defaultFontPointSize*2
        width :parent.width
        height: parent.height*0.35
        text:"待定"
        wrapMode: Text.Wrap
    }


}
