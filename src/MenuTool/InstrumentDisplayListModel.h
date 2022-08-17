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

//在QGCCorePlugin.cc实例化
//右侧显示飞行参数列表
class InstrumentDisplayListModel:public QObject
{
    Q_OBJECT
public:
    InstrumentDisplayListModel          (QObject* parent = nullptr);
    ~InstrumentDisplayListModel         ();
    //添加到列表里
    void   insertFactData               (QString factGroupDataName,QString factDataName);
    void   clear                        ();
    //测试接口
    Q_INVOKABLE  void   printTest       ();
    //qml使用接口
    Q_INVOKABLE InstrumentValueData* get(QString factName,int index);
private:
    InstrumentValueData* createData();
    //根据不同的飞机类型初始化不同参数表
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
