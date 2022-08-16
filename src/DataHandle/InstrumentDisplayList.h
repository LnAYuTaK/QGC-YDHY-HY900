#ifndef INSTRUMENTDISPLAYLIST_H
#define INSTRUMENTDISPLAYLIST_H

#include <QObject>
//右侧仪表显示数据管理显示
class InstrumentDisplayList : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit InstrumentDisplayList(QObject *parent = nullptr);



signals:

//    2.仪表盘在右上角，俯仰角（0.0°）、滚转角、偏航角、设备状态（已锁定）、
//    飞行模式（定高、定点、自动、返航，点击可以设置）、



    //卫星定位（fix 10，float 20）、



//    电池电压（0.0V）、高度（0.0m）、水平速度（0.0m/s）、升降速度（0.0m/s）、
//    飞行时间（0.0min）、返航距离（0.0m）、


    //链路信号（0%）、电机温度1-6（0℃ 1℃）、电调温度1-6。


private:

   QList<QObject*> _objectList;


};

#endif // INSTRUMENTDISPLAYLIST_H
