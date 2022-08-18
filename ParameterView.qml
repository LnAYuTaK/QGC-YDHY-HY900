import QtQuick              2.3
import QtQuick.Controls     2.5
import QtQuick.Dialogs      1.2
import QtQuick.Layouts      1.2

import QtQuick.Window 2.12

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0
import MAVLink                              1.0

Rectangle {

  //当前活跃无人机
  property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
  //字体大小
  property real   pointSize:   ScreenTools.defaultFontPointSize*1.5

  property string _LabelColorG :"gray"
  property string _LabelColorB :"blcak"

  property string _pitch             : "俯仰角: "
  property string _roll              : "滚转角: "
  property string _heading           : "偏航角: "
  property string _equipmentState    : "设备状态: "
  //需要可以手动切换
  property string _flghtMode         : "飞行模式: "
  //这四个放到两行
  property string _gpsState          : "gps状态: "
  property string _gps2State         : "gps2状态: "
  property string _gpsCount          : "gps卫星颗数: "
  property string _gps2Count         : "gps2卫星颗数: "

  property string _batteryVoltage    : "电池电压: "
  property string _altitudeRelative  : "相对海拔高度: "
  property string _groundSpeed       : "飞行速度: "
  property string _climbRate         : "升降速度: "
  property string _flightTime        : "飞行时间: "
  property string _distanceToHome    : "返航距离: "
  property string _linksignal        : "链路信号: "
  property string _motorTemp         : "电机温度: "
  property string _escTemp           : "电调温度: "
  Column{
       anchors.fill :parent
       spacing :0
       //俯仰角
       Label {
           id : pitch
           width:parent.width
           font.pointSize: pointSize
           color:"white"
           horizontalAlignment: Text.AlignHCenter
           text: _activeVehicle ? _pitch+_activeVehicle.pitch.valueString+"°": _pitch+qsTr("0°")

           background : Rectangle{
               color:_LabelColorG

           }
       }
       //滚转角
       Label {
           id : roll
            width:parent.width
           font.pointSize: pointSize
           color:"white"
           horizontalAlignment: Text.AlignHCenter
           text: _activeVehicle ?_roll+_activeVehicle.roll.valueString+"°":_roll+qsTr("0°")
           background : Rectangle
           {
               color:_LabelColorB

           }
       }
       //偏航角
       Label {
           id :heading
           width:parent.width
           font.pointSize: pointSize
           color:"white"
           horizontalAlignment: Text.AlignHCenter
           text: _activeVehicle ?_heading+_activeVehicle.heading.valueString+"°": _heading+qsTr("0°")
           background : Rectangle{
               color:_LabelColorG
           }
       }
     //飞行模式
     Label{
          id :flightMode
           width:parent.width
          font.pointSize: pointSize
          color:"white"
          horizontalAlignment: Text.AlignHCenter
          text:_activeVehicle ?_flghtMode+_activeVehicle.flightMode.toString():_flghtMode+"UNKNOW"
          background : Rectangle{
              color:_LabelColorB
          }
      }
      //GPS状态
     Label{
         id :gpsCount
         width:parent.width
         font.pointSize: pointSize
         color:"white"
         horizontalAlignment: Text.AlignHCenter
         text: _activeVehicle ? _gpsCount+_activeVehicle.gps.count.valueString+"颗": _gpsCount+qsTr("N/A", "No data to display")
         background : Rectangle{
            color:_LabelColorG
         }
     }
     Label{
           id :gpsState
           width:parent.width
           font.pointSize: pointSize
           color:"white"
           horizontalAlignment: Text.AlignHCenter
           text: _activeVehicle ? _gpsState+_activeVehicle.gps.lock.enumStringValue : _gpsState+qsTr("N/A", "No data to display")
           background : Rectangle{
               color:_LabelColorB
           }
       }

      Label{
           id :gps2Count
            width:parent.width
           font.pointSize: pointSize
           color:"white"
           horizontalAlignment: Text.AlignHCenter
           text: _activeVehicle ? _gpsCount+_activeVehicle.gps2.count.valueString+"颗": _gpsCount+qsTr("N/A", "No data to display")
           background : Rectangle{
               color:_LabelColorG
           }
       }
       //GPS2
        Label{
           id :gps2State
           width:parent.width
           font.pointSize: pointSize
           color:"white"
           horizontalAlignment: Text.AlignHCenter
           text: _activeVehicle ? _gps2State+_activeVehicle.gps2.lock.enumStringValue :_gps2State+qsTr("N/A", "No data to display")
           background : Rectangle{
               color:_LabelColorB
           }
       }
      //电池电压
        Label{
           id : batteryVoltage
           width:parent.width
           font.pointSize: pointSize
           color:"white"
           horizontalAlignment: Text.AlignHCenter
           text: _activeVehicle ?_batteryVoltage+_activeVehicle.batteries.get(0).voltage.valueString+"v":_batteryVoltage+qsTr("N/A", "No data to display")
           background : Rectangle{
               color:_LabelColorG
           }
       }
       //海拔相对高度
        Label{
          id :  altitudeRelative
           width:parent.width
          font.pointSize: pointSize
          color:"white"
          horizontalAlignment: Text.AlignHCenter
          text: _activeVehicle ?_altitudeRelative+_activeVehicle.altitudeRelative.valueString: _altitudeRelative+qsTr("0m")
          background : Rectangle
          {
              color:_LabelColorB

          }
       }
       //飞行速度
        Label{
          id :  groundSpeed
           width:parent.width
          font.pointSize: pointSize
          color:"white"
          horizontalAlignment: Text.AlignHCenter
          text: _activeVehicle ?_groundSpeed+_activeVehicle.groundSpeed.valueString: _groundSpeed +qsTr("0m/s")
          background : Rectangle
          {
              color:_LabelColorG

          }
       }
        //升降速度
         Label{
           id :  climbRate
           width:parent.width
           font.pointSize: pointSize
           color:"white"
           horizontalAlignment: Text.AlignHCenter
           text: _activeVehicle ?_climbRate+_activeVehicle.climbRate.valueString+"0m/s": _climbRate +qsTr("0m/s")
           background : Rectangle
           {
               color:_LabelColorB
           }
        }



       //飞行时间
       Label{
          id :  flightTime
           width:parent.width
          font.pointSize: pointSize
          color:"white"
          horizontalAlignment: Text.AlignHCenter
          text: _activeVehicle ?_flightTime+_activeVehicle.groundSpeed.valueString: _flightTime+qsTr("0min")
          background : Rectangle
          {
              color:_LabelColorG

          }
       }
       //返航距离
        Label{
          id :  distanceToHome
          width:parent.width
          font.pointSize: pointSize
          horizontalAlignment: Text.AlignHCenter
          color:"white"
          text: _activeVehicle ?_distanceToHome+_activeVehicle.distanceToHome.valueString: _distanceToHome+qsTr("0m")
          background : Rectangle{
              color:_LabelColorB

          }
       }

  }


}



