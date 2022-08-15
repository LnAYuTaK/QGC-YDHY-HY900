#ifndef DATAMANAGER_H
#define DATAMANAGER_H

//QT Head
#include <QObject>
#include <QDateTime>
#include <QMap>
#include <QVector>
#include <QByteArray>
#include <QString>
#include <QTcpSocket>
//QGC Head
#include "QGCMAVLink.h"
#include "QGCApplication.h"
#include "Vehicle.h"
#include  "Settings/HySettings.h"
#include "NetWorkLayer/NetWorkManager.h"
#include "FactGroup.h"

#define   PACKHEAD  "EB90"

//�������ͷɻ����ݰ�����// Fact  �ع�
class  VehicleDataFactPack:public QObject
{
    Q_OBJECT
public:
      explicit VehicleDataFactPack(QObject *parent = nullptr);
      //��ȡУ����ɵ�����
      Q_INVOKABLE QString     pack          () ;

      //��ȡ�ܴ���Ϣ
      //Q_INVOKABLE QStringList get           (int index);
      //�б��ܳ���
      Q_INVOKABLE int         listSize      () {return  flightMsgPack.size();}

      //����ģʽ����// ���б�����ͺ������
      const QStringList FlightModeType {
              "PreFlight",
              "Stabilize",
              "Guided",
              "Auto",
              "Test",
              "Altitude Hold",
              "RTL",
              "Loiter"
      };
//�����Vehcile���յ�����
public slots:
      void _vehicleTakeOff();
      void _vehicleLand();
      void _vehicleFlightTime(QString time);
      void _vehicleSprayState(bool isOpen);
      void _vehicleid(int id);
      void _vehicleFlowRate(uint8_t flowRate);
      void _vehicleWorkArea(double workArea);
      void _vehicleLongitude(double lot);
      void _vehicleLatitude(double lat);
      void _vehicleFlighTaltiTude(double flightTaltiTude);
      void _vehicleGroundFlightSpeed(double groundSpeed);
      void _vehicleDataSendTime();
      void _vehicleLevelGaugeStatus(uint8_t gaugetype);
      void _vehicleFlightMode(QString flightmodetype);
      void _vehicleMsgText(QString messageText);
      void _vehicleDataSendNumChanged();
//private slots:
//      //���·��мܴ�
//       void _updataFlightSorties();
//signals:
//       void updata();
private:
      //��ʼ��PackList
      void  _initPackList();
      //����С������
      QVector <qint64> splitDouble(double data,qint16 digit);
      static bool      _flightState;
      static QString   _flightTime;
      static uint8_t   _sprayStat;
      static int       _id ;
      static uint8_t   _flowRate;
      static double    _workArea;
      static double    _lot;
      static double    _lat;
      static double    _flightTailTude;
      static double    _groundSpeed;
      static uint8_t   _gaugetype;
      static QString   _flightMode;
      //�Ƿ���·��мܴ�flag
      static bool      _upDataFlightFlag;
      //֡ͷ
      const  QString  packHead =PACKHEAD;
      //�汾�͹̼���ͨ����ʱ��ȡͨ��HySetting��ȡ
      const QString    _softWareVersion;
      const QString    _fireWareVersion;
      //���������Ϣ
      QVector <QString>vehiclePack;
      //���ÿһ�ܴεķ��м�¼��Ϣ   QStringList << |�û��˺�|���ʱ��|������ʱ|��������|����Ķ��|����ũҩ����|���п��ƺ���|���о���|��������
      QVector <QStringList> flightMsgPack;
};
//���ݹ�����
class DataController: public QObject
{
    Q_OBJECT
public:
     DataController(void);
     //������־���ݵ���̨
     void  sendData();
     //�洢��̨�������ݵ������ı�TXT
     void  saveDataLocal();
    //Test

private:
    VehicleDataFactPack* createDataFact(Vehicle* vehicle);
    //�Զ���Vehicle ��dataFact
    void dataFactAdd(Vehicle* vehicle);
    //�ɻ��Ƴ��Զ�ɾ��dataFact
    void dataFactRemove(Vehicle* vehicle);
    //��������
    //void LoadSetting();
    //Vehicle ID  ---  VehicleDataFactPack pointer
    //Test ��ʱ�����ӻ�Ծ��Vehicle
    VehicleDataFactPack * _dataPack    = nullptr;
    QTimer              * dataSendTimer =nullptr;
    QThread   mThread;
    QTcpSocket mSocket;
protected:

signals:
    //���ʹ�������
    void sendDataNumAdd();
    //
private:
     NetWorkManager  *   _networkMgr =nullptr;
};

#endif // DATAMANAGER_H
