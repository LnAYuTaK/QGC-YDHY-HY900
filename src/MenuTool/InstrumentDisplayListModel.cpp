#include "InstrumentDisplayListModel.h"

InstrumentDisplayListModel::InstrumentDisplayListModel(QObject* parent)
    : QObject(parent)
{

   MultiVehicleManager* multiVehicleManager = qgcApp()->toolbox()->multiVehicleManager();
   connect(multiVehicleManager,&MultiVehicleManager::activeVehicleChanged,this,&InstrumentDisplayListModel::vehicleChanged);
   _activeVehicle = multiVehicleManager->activeVehicle();
   this->setFactValueHY800();
}

InstrumentDisplayListModel::~InstrumentDisplayListModel()
{
    this->clear();
}

void InstrumentDisplayListModel::vehicleChanged()
{
    //���¸���һ�µ�ǰ��ԾVehicle
    MultiVehicleManager* multiVehicleManager = qgcApp()->toolbox()->multiVehicleManager();
    _activeVehicle = multiVehicleManager->activeVehicle();
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

void InstrumentDisplayListModel::insertFactData(QString factGroupDataName,QString factDataName)
{
      InstrumentValueData * data = this->createData();
      if(data!=nullptr){
         data->setFact(factGroupDataName,factDataName);
         data->setText(data->fact()->shortDescription());
         data->setShowUnits(true);
         _instrumentMap.insert(factDataName,data);
      }
}

void InstrumentDisplayListModel::clear()
{
    _instrumentMap.clear();
    QMap<QString , InstrumentValueData* >::const_iterator it = _instrumentMap.constBegin();
    while (it != _instrumentMap.constEnd()) {
        if(it.value()!=nullptr) {
           it.value()->deleteLater();
        }
        ++it;
    }
}
//���￪�˿ռ�ע���ͷ�����
InstrumentValueData* InstrumentDisplayListModel::createData()
{
    InstrumentValueData * data  = new InstrumentValueData(nullptr , nullptr);
    return data;
}

//2.�Ǳ��������Ͻǣ������ǣ�0.0�㣩����ת�ǡ�ƫ���ǡ��豸״̬����������������ģʽ�����ߡ����㡢�Զ�������������������ã�

//�����Ƕ�λ��fix 10��float 20������ص�ѹ��0.0V�����߶ȣ�0.0m����ˮƽ�ٶȣ�0.0m/s���������ٶȣ�0.0m/s����

//����ʱ�䣨0.0min�����������루0.0m������·�źţ�0%��������¶�1-6��0�� 1�棩������¶�1-6��
void InstrumentDisplayListModel::setFactValueHY800()
{
    this->clear();
//   ������
    this->insertFactData("Vehicle","Pitch");
//   ��ת��
    this->insertFactData("Vehicle","Roll");
//   ƫ����
    this->insertFactData("Vehicle","Heading");
    //����ģʽ TUDO

    //GPS1
    this->insertFactData("gps","lat");
    //GPS2
    this->insertFactData("gps2","lat");
    //��ص�ѹ   Vehicle.cc(1506)��qml��ߵ�����ʾ
    //
    //��Ժ��θ߶�
    this->insertFactData("Vehicle","AltitudeRelative");
    //�����ٶ�
    this->insertFactData("Vehicle","GroundSpeed");
    //�����ٶ�

//    //����ʱ��
    this->insertFactData("Vehicle","FlightTime");
//    //��������
    this->insertFactData("Vehicle","DistanceToHome");
    //��·�ź�

    //����¶�1-6()

    //����¶�1-6()
}

void InstrumentDisplayListModel::printTest()
{
    QMap<QString , InstrumentValueData* >::const_iterator it = _instrumentMap.constBegin();
      while (it != _instrumentMap.constEnd()) {
         qDebug()<< "Test : "<<it.key() <<it.value()->fact()->rawValue();
             it++;
      }
      qDebug() << "MAPCOUNT"<<_instrumentMap.count();

}










