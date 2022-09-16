import QtQuick 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QGroundControl.ScreenTools           1.0
Rectangle{
    id : parameterLabel
    height: ScreenTools.defaultFontPixelHeight/1.5
    property string parameterName :""
    property string value  :"N/A"
    property string textColor  :"white"
    property real   pointSize:   ScreenTools.defaultFontPointSize*0.7
    RowLayout{
        width:parent.width
        spacing: 0
        Label {
            font.pointSize: pointSize
            Layout.preferredWidth : parent.width/2
            color:textColor
            horizontalAlignment: Text.AlignHCenter
            text:parameterName
        }
        Label {
            font.pointSize: pointSize
            color:textColor
            Layout.preferredWidth : parent.width/2
            horizontalAlignment: Text.AlignHCenter
            text:value
        }
    }
}
