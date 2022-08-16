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
    //������
    this->insertFactData("PitchRate",(this->createData()));
    //��ת��
    this->insertFactData("RollRate",(this->createData()));
    //ƫ����
    this->insertFactData("YawRate",(this->createData()));
    //����ģʽ TUDO

    //���Ƕ�λ1 ���Ƕ�λGPS
//����ͨ��
//     InstrumentValueData * data  = new InstrumentValueData(nullptr , nullptr);
//     data->setFact("Gps","lat");
//   _instrumentMap.insert("GPS",data);

    //��ص�ѹ   Vehicle.cc(1506)

    //��Ժ��θ߶�

    //�����ٶ�
    this->insertFactData("GroundSpeed",(this->createData()));
    //�����ٶ�

    //����ʱ��
    this->insertFactData("FlightTime",(this->createData()));
    //��������
    this->insertFactData("DistanceToHome",(this->createData()));
    //��·�ź�
    //����¶�1-6()
    //����¶�1-6()




}

void InstrumentDisplayListModel::printTest()
{
    QMap<QString , InstrumentValueData* >::const_iterator it = _instrumentMap.constBegin();
      while (it != _instrumentMap.constEnd()) {
         qDebug()<< "Test : "<<it.key() <<it.value()->fact()->rawValue();
             ++it;
      }
}










