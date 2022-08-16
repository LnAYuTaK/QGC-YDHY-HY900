#include "InstrumentDisplayListModel.h"



InstrumentDisplayListModel::InstrumentDisplayListModel(QObject* parent)
    : QObject(parent)
{
   this->setFactValueHY800();
}

InstrumentDisplayListModel::~InstrumentDisplayListModel()
{
    this->clear();
}

InstrumentValueData* InstrumentDisplayListModel::get(QString factName , int index)
{
    if (index < 0 || index >= _instrumentMap.count()) {
        return nullptr;
    }
    if(!_instrumentMap.contains(factName)) {
        return nullptr;
    }
    return  _instrumentMap[factName];
}

void InstrumentDisplayListModel::insertFactData(QString factDataName , InstrumentValueData* dataObject)
{
    if(dataObject!=nullptr) {
      _instrumentMap.insert(factDataName,dataObject);
      dataObject->setFact("Vehicle",factDataName);
      dataObject->setText(dataObject->fact()->shortDescription());
      dataObject->setShowUnits(true);
    }
}
void   InstrumentDisplayListModel::insertFactGroupData (QString factGroupDataName,InstrumentValueData*dataObject)
{
    if(dataObject!=nullptr) {
      _instrumentMap.insert(factGroupDataName,dataObject);

    }
}

void InstrumentDisplayListModel::clear()
{
    _instrumentMap.clear();
    QMap<QString , InstrumentValueData* >::const_iterator it = _instrumentMap.constBegin();
      while (it != _instrumentMap.constEnd()) {
          if(it.value()!=nullptr){
          it.value()->deleteLater();
          }
          ++it;
      }
}
//这里开了空间注意释放问题
InstrumentValueData* InstrumentDisplayListModel::createData()
{
    InstrumentValueData * data  = new InstrumentValueData(nullptr , nullptr);
    return data;
}

//2.仪表盘在右上角，俯仰角（0.0°）、滚转角、偏航角、设备状态（已锁定）、飞行模式（定高、定点、自动、返航，点击可以设置）

//、卫星定位（fix 10，float 20）、电池电压（0.0V）、高度（0.0m）、水平速度（0.0m/s）、升降速度（0.0m/s）、

//飞行时间（0.0min）、返航距离（0.0m）、链路信号（0%）、电机温度1-6（0℃ 1℃）、电调温度1-6。
void InstrumentDisplayListModel::setFactValueHY800()
{
    this->clear();
    //俯仰角
    this->insertFactData("PitchRate",(this->createData()));
    //滚转角
    this->insertFactData("RollRate",(this->createData()));
    //偏航角
    this->insertFactData("YawRate",(this->createData()));
    //飞行模式 TUDO

    //卫星定位1 卫星定位GPS
//测试通过
//     InstrumentValueData * data  = new InstrumentValueData(nullptr , nullptr);
//     data->setFact("Gps","lat");
//   _instrumentMap.insert("GPS",data);

    //电池电压   Vehicle.cc(1506)

    //相对海拔高度

    //地面速度
    this->insertFactData("GroundSpeed",(this->createData()));
    //升降速度

    //飞行时间
    this->insertFactData("FlightTime",(this->createData()));
    //返航距离
    this->insertFactData("DistanceToHome",(this->createData()));
    //链路信号
    //电机温度1-6()
    //电调温度1-6()




}

void InstrumentDisplayListModel::printTest()
{
    QMap<QString , InstrumentValueData* >::const_iterator it = _instrumentMap.constBegin();
      while (it != _instrumentMap.constEnd()) {
         qDebug()<< "Test : "<<it.key() <<it.value()->fact()->rawValue();
             ++it;
      }
}










