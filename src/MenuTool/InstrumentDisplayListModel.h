#ifndef INSTRUMENTDISPLAYLISTMODEL_H
#define INSTRUMENTDISPLAYLISTMODEL_H

#include <QAbstractListModel>
#include <QMap>
#include <QObject>
#include "InstrumentValueData.h"
#include "QGCApplication.h"
#include "FactSystem.h"
#include <QGridLayout>
#include <QSettings>
#include "Vehicle.h"
#include "MultiVehicleManager.h"

//��QGCCorePlugin.ccʵ����
//�Ҳ���ʾ���в����б�
class InstrumentDisplayListModel:public QObject
{
    Q_OBJECT
public:
    InstrumentDisplayListModel          (QObject* parent = nullptr);
    ~InstrumentDisplayListModel         ();
    //��ӵ��б���
    void   insertFactData               (QString factGroupDataName,QString factDataName);
    void   clear                        ();
    //���Խӿ�
    Q_INVOKABLE  void   printTest       ();
    //qmlʹ�ýӿ�
    Q_INVOKABLE InstrumentValueData* get(QString factName,int index);
private:
    InstrumentValueData* createData();
    //���ݲ�ͬ�ķɻ����ͳ�ʼ����ͬ������
    void setFactValueHY800();
    void vehicleChanged();
    //
private:
    //key  FactName  | value(InstrumentValueData*)
    QMap<QString ,InstrumentValueData*>_instrumentMap;
    //FactValueGrid*          _factValueGrid =    nullptr;
    Vehicle * _activeVehicle;

};

#endif // INSTRUMENTDISPLAYLISTMODEL_H
