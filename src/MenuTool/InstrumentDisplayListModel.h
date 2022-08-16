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

//在QGCCorePlugin.cc实例化
//右侧显示飞行参数列表
class InstrumentDisplayListModel:public QObject
{
        Q_OBJECT
public:
    InstrumentDisplayListModel(QObject* parent = nullptr);
    ~InstrumentDisplayListModel();
    //添加到列表里
    //
    void   insertFactData              (QString factDataName,InstrumentValueData*);
    void   insertFactGroupData         (QString factGroupDataName,InstrumentValueData*);

    void   clear               ();
    //测试接口
    Q_INVOKABLE  void   printTest           ();
    //qml使用接口
    Q_INVOKABLE InstrumentValueData* get(QString factName,int index);

private:
    InstrumentValueData* createData();

    //根据不同的飞机类型初始化不同参数表
    void setFactValueHY800();
    //


private:
    //key  FactName  | value(InstrumentValueData*)
    QMap<QString ,InstrumentValueData*>_instrumentMap;
    //FactValueGrid*          _factValueGrid =    nullptr;



};

#endif // INSTRUMENTDISPLAYLISTMODEL_H
