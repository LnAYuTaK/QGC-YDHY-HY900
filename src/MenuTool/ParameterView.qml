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

import QtQuick.Extras   1.4
import QGroundControl.Vehicle       1.0

import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Palette       1.0
import QGroundControl.FlightMap     1.0
//右侧参数界面
Rectangle {
  color:"black"
  //当前活跃无人机
  property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
  //链路信号
  property bool   _rcRSSIAvailable:   _activeVehicle ? _activeVehicle.rcRSSI > 0 && _activeVehicle.rcRSSI <= 100 : false
  //字体大小
  property real   pointSize:   ScreenTools.defaultFontPointSize*0.7

  property real   _defaultLabelHeight:  ScreenTools.defaultFontPixelWidth*3
  property string _LabelColorG :"#4F4F4F"
  property string _LabelColorB :"#363636"

  //Time to Minute
  function secondString(sec){
      var hours   = Math.floor(sec/ 3600)
      var minutes = Math.floor(sec % 3600 / 60)
      var seconds = Math.floor(sec % 3600 % 60)
      var minStr  = String((minutes)+(hours*60))
      var secStr  = String(seconds)
      return  minStr +"min"+ secStr
  }
  property string _pitch             : "俯仰角: "
  property string _roll              : "滚转角: "
  property string _heading           : "偏航角: "
  property string _equipmentState    : "设备状态: "
  property string _flghtMode         : "飞行模式: "
  property string _gps               : "卫星定位: "
  property string _gps2              : "卫星定位2: "
  property string _batteryVoltage    : "电池电压: "
  property string _altitudeRelative  : "高度: "
  property string _groundSpeed       : "飞行速度: "
  property string _climbRate         : "升降速度: "
  property string _flightTime        : "飞行时间: "
  property string _distanceToHome    : "返航距离: "
  property string _linksignal        : "链路信号: "
  property string _motorTemp         : "电机温度: "
  property string _escTemp           : "电调温度: "
  Column{
       id:_parameter
       anchors.fill :parent
       spacing :0

       //俯仰角
       ParameterLabel{
           id:pitch
           width:parent.width
           parameterName:_pitch
           value:_activeVehicle ?+_activeVehicle.pitch.valueString+"°":qsTr("0°")
           color:_LabelColorG
       }
       //滚转角
       ParameterLabel{
           id:roll
           width:parent.width
           parameterName:_roll
           value:_activeVehicle ?+_activeVehicle.roll.valueString+"°":qsTr("0°")
           color:_LabelColorB
       }
       //偏航角
       ParameterLabel{
           id:heading
           width:parent.width
           parameterName:_heading
           value:_activeVehicle ?+_activeVehicle.heading.valueString+"°":qsTr("0°")
           color:_LabelColorG
       }
       //设备状态
       ParameterLabel{
           id:equipmentState
           width:parent.width
           parameterName:_equipmentState
           value:_activeVehicle && _activeVehicle.armed ?qsTr("已解锁"):qsTr("已锁定")
           color:_LabelColorB
       }
       //飞行模式
       QGCComboBox {
           id :modeComboBox
           alternateText:          _activeVehicle ?_flghtMode+_activeVehicle.flightMode : "飞行模式:未连接"
           model:                  _flightModes
           font.pointSize:         pointSize
           centeredLabel:  true
           height:pitch.height
           currentIndex:           1
           sizeToContents:         true
           width:parent.width
           property bool showIndicator: true
           property var _flightModes:      _activeVehicle ? _activeVehicle.flightModes : [ ]
           onActivated: {
               modeChanged.createObject(mainWindow, {modeNameChanged:_flightModes[index]}).open()
           }
           function changed(modeName) {
               _activeVehicle.flightMode = modeName
               currentIndex = -1
           }
           Component {
               id : modeChanged
               QGCSimpleMessageDialog {
                   title:      qsTr("飞行模式")
                   text:       qsTr("确定更改飞行模式为'%1' ?").arg(modeNameChanged)

                   property var   modeNameChanged
                   buttons:    StandardButton.Yes | StandardButton.No
                   onAccepted: {
                       modeComboBox.changed(modeNameChanged)
                   }
                }
              }
       }
       //卫星定位1
       ParameterLabel{
           id:gps
           width:parent.width
           parameterName:_gps
           value:_activeVehicle ?_activeVehicle.gps.lock.enumStringValue+"·"+_activeVehicle.gps.count.valueString:qsTr("N/A·N/A")
           color:_LabelColorG
       }
       //卫星定位2
       ParameterLabel{
           id:gps2
           width:parent.width
           parameterName:_gps2
           value:_activeVehicle ?_activeVehicle.gps2.lock.enumStringValue+"·"+_activeVehicle.gps2.count.valueString:qsTr("N/A·N/A")
           color:_LabelColorB
       }
       //电池电压
       ParameterLabel{
           id:batteryVoltage
           width:parent.width
           parameterName:_batteryVoltage
           value:_activeVehicle ?_activeVehicle.batteries.get(0).voltage.valueString+"V":qsTr("N/A", "No data to display")
           color:_LabelColorG
       }
       //海拔高度
       ParameterLabel{
           id:altitudeRelative
           width:parent.width
           parameterName:_altitudeRelative
           value:_activeVehicle ?_activeVehicle.altitudeRelative.valueString+"m":qsTr("0m")
           color:_LabelColorB
       }
       //水平飞行速度
       ParameterLabel{
           id:groundSpeed
           width:parent.width
           parameterName:_groundSpeed
           value:_activeVehicle ?_activeVehicle.groundSpeed.valueString+"m/s":qsTr("0m/s")
           color:_LabelColorG
       }
       //升降速度
       ParameterLabel{
           id:climbRate
           width:parent.width
           parameterName:_climbRate
           value: _activeVehicle ?_activeVehicle.climbRate.valueString+"m/s":qsTr("0m/s")
           color:_LabelColorB
       }
       //飞行时间
       ParameterLabel{
           id:flightTime
           width:parent.width
           parameterName:_flightTime
           //_activeVehicle.flightTime.value
           value: _activeVehicle ?secondString(_activeVehicle.flightTime.rawValue.toInt()):qsTr("0min")
           color:_LabelColorG
       }

       //返航距离
       ParameterLabel{
           id:distanceToHome
           width:parent.width
           parameterName:_distanceToHome
           value: _activeVehicle ?_activeVehicle.distanceToHome.valueString+"m": qsTr("0m")
           color:_LabelColorB
       }
       //链路信号
       ParameterLabel{
           id:linksignal
           width:parent.width
           parameterName:_linksignal
           value :_rcRSSIAvailable?_activeVehicle.rcRSSI:qsTr("0%")
           color:_LabelColorG
       }
       //电机温度
       ParameterLabel{
           id:motorTemp
           width:parent.width
           parameterName:_motorTemp
           value: _activeVehicle ?"0"+"°C"+"·"+"0"+"°C":"N/A"
           color:_LabelColorB
       }
       //电调温度
       ParameterLabel{
           id:escTemp
           width:parent.width
           parameterName:_escTemp
           value: _activeVehicle ?"0"+"°C":"N/A"
           color:_LabelColorG
       }

       ParameterLabel{
           id:undetermined
           width:parent.width
           parameterName:""
           value: ""
           color:_LabelColorB
       }
       ParameterLabel{
           id:undetermined2
           width:parent.width
           parameterName:""
           value: ""
           color:_LabelColorG
       }
   }

  //ParameterList
 }

