#include "DataController.h"
//��ʼ�� VehicleDataFactPack
//���Ժ�
#define DEBUGINFO

//�ɻ����Ͷ��� ��Ҫ��
#define HY600
//������ʾ�����ݳ�ʼ��
bool      VehicleDataFactPack::_flightState      = false;
QString   VehicleDataFactPack::_flightTime       = "2020-02-20 20:20:20";
uint8_t   VehicleDataFactPack::_sprayStat        = 0;
int       VehicleDataFactPack::_id               = 0;
uint8_t   VehicleDataFactPack::_flowRate         = 0;
double    VehicleDataFactPack::_workArea         = 0;
double    VehicleDataFactPack::_lot              = 0.0;
double    VehicleDataFactPack::_lat              = 0;
double    VehicleDataFactPack::_flightTailTude   = 0;
double    VehicleDataFactPack::_groundSpeed      = 0;
bool      VehicleDataFactPack::_upDataFlightFlag = false;
uint8_t   VehicleDataFactPack::_gaugetype        = 1;
QString   VehicleDataFactPack::_flightMode       = "";

VehicleDataFactPack::VehicleDataFactPack(QObject *parent)
    : QObject{parent}
{
   //��ʼ��vehiclePack���㸳ֵ
    this->_initPackList();
}

void VehicleDataFactPack::_initPackList()
{
    this->vehiclePack.clear();
    vehiclePack.append(packHead);      //֡ͷ   0
    vehiclePack.append(QString(4,'0')); //���ʹ��� 1
    vehiclePack.append(QString(8,'0'));//���ʱ�� 2
    vehiclePack.append(QString(3,'0'));//���˻�ID 3
    vehiclePack.append(QString(3,'0'));//�û�ID  4
    vehiclePack.append(QString(1,'0'));//������������5
    vehiclePack.append(QString(2,'0'));//����С������6
    vehiclePack.append(QString(2,'0'));//��ҵ�����������7
    vehiclePack.append(QString(2,'0'));//��ҵ���С������8
    vehiclePack.append(QString(1,'0'));//����״̬9
    vehiclePack.append(QString(2,'0'));//��������10
    vehiclePack.append(QString(6,'0'));//����С������11
    vehiclePack.append(QString(2,'0'));//ά����������12
    vehiclePack.append(QString(6,'0'));//ά��С������13
    vehiclePack.append(QString(1,'0'));//�߶�����14
    vehiclePack.append(QString(3,'0'));//�߶�����15
    vehiclePack.append(QString(2,'0'));//�߶�С��16
    vehiclePack.append(QString(2,'0'));//���е�������17
    vehiclePack.append(QString(2,'0'));//���е���С��18
    vehiclePack.append(QString(4,'0'));//���ݷ���ʱ��19
    vehiclePack.append(QString(1,'0'));//Һλ��״̬20
    vehiclePack.append(QString(1,'0'));//����ģʽ21
}
//202282
//���ݴ���
void VehicleDataFactPack::_vehicleDataSendNumChanged()
{
    static int dataSendTimes=0;
    dataSendTimes++;
}
void VehicleDataFactPack::_vehicleMsgText(QString messageText)
{
    if(messageText== "No Load RTL") {
        _gaugetype  = 0;
        vehiclePack[20] = QString("%1").arg(_gaugetype,1,16,QLatin1Char('0'));
    }
}

void VehicleDataFactPack::_vehicleFlightTime(QString time)
{
    if(!_upDataFlightFlag) {
       _flightTime       = time;
       _upDataFlightFlag = true;  
    }     
}
//���˻����
void VehicleDataFactPack::_vehicleTakeOff()
{
    _flightState = true;

}
//���˻�����
void VehicleDataFactPack::_vehicleLand()
{
    _flightState= false;
    _upDataFlightFlag= false;
}
//���˻���ͷ��ͷ״̬�Ƿ��
void VehicleDataFactPack::_vehicleSprayState(bool isOpen)
{
    if(isOpen!=true) {
       _sprayStat = 8;
    }
    else{
       _sprayStat = 0;
    }
}
//���˻�ID
void VehicleDataFactPack::_vehicleid(int id)
{
    _id= id;
    vehiclePack[4] = QString("%1").arg(_id,3,16,QLatin1Char('0'));

}
//���˻����ٻ�ȡ֮���Ϊ С������ ��ʱδʹ��
void VehicleDataFactPack::_vehicleFlowRate(uint8_t flowRate)
{
    _flowRate = flowRate;
    QVector <qint64> temp = splitDouble(_flowRate,2);
    qDebug () <<temp[1] <<temp [0] <<"TEMP";
    vehiclePack[5] = QString("%1").arg(temp[0],1,16,QLatin1Char('0'));
    vehiclePack[6] = QString("%1").arg(temp[1],2,16,QLatin1Char('0'));
}
//���˻���ҵ���(ע��Ҫ�ۼ�
void VehicleDataFactPack::_vehicleWorkArea(double workArea)
{
    //�ۼ����
    if(_sprayStat>0){
       _workArea += workArea;
    }
   QVector <qint64> temp = splitDouble(_workArea,2);
   vehiclePack[7] = QString("%1").arg(temp[0],2,16,QLatin1Char('0'));
   vehiclePack[8] = QString("%1").arg(temp[1],2,16,QLatin1Char('0'));
}
//���˻�����
void VehicleDataFactPack::_vehicleLongitude(double lot)
{
    _lot =lot;
    QVector <qint64> temp = splitDouble(_lot,7);
    vehiclePack[10] = QString("%1").arg(temp[0],2,16,QLatin1Char('0'));
    vehiclePack[11] = QString("%1").arg(temp[1],6,16,QLatin1Char('0'));
}
//���˻�ά��
void VehicleDataFactPack::_vehicleLatitude(double lat)
{
    _lat =lat;
    QVector <qint64> temp = splitDouble(_lat,7);
    vehiclePack[12] = QString("%1").arg(temp[0],2,16,QLatin1Char('0'));
    vehiclePack[13] = QString("%1").arg(temp[1],6,16,QLatin1Char('0'));
}
//���˻��߶ȷ��и߶�
void VehicleDataFactPack::_vehicleFlighTaltiTude(double flightTaltiTude)
{
    _flightTailTude = flightTaltiTude;
    if(_flightTailTude<0)
    {
       vehiclePack[14] =  QString("%1").arg(1,1,16,QLatin1Char('0'));
    }
    else{
     vehiclePack[14] =  QString("%1").arg(0,1,16,QLatin1Char('0'));
    }
    QVector <qint64> temp = splitDouble(qAbs(_flightTailTude),2);
    vehiclePack[15] = QString("%1").arg(temp[0],3,16,QLatin1Char('0'));
    vehiclePack[16] = QString("%1").arg(temp[1],2,16,QLatin1Char('0'));
}
//���˻������ٶ�(����)
void VehicleDataFactPack::_vehicleGroundFlightSpeed(double groundSpeed)
{
    _groundSpeed = groundSpeed;
    QVector <qint64> temp =splitDouble(groundSpeed,2);
    vehiclePack[17] = QString("%1").arg(temp[0],2,16,QLatin1Char('0'));
    vehiclePack[18] = QString("%1").arg(temp[1],2,16,QLatin1Char('0'));
}
//���˻����ݷ���ʱ��()//��ʱ����
void VehicleDataFactPack::_vehicleDataSendTime()
{

}
//���˻�Һλ��״̬//��ʱ����
void VehicleDataFactPack::_vehicleLevelGaugeStatus(uint8_t gaugetype)
{

}
//���˻�����ģʽ
void VehicleDataFactPack::_vehicleFlightMode(QString flightmodetype)
{
    _flightMode =flightmodetype;
    qint16 value  = FlightModeType.indexOf(_flightMode);
    if(value < 0 || value > 7){
      vehiclePack[21] = QString("%1").arg(0,1,16,QLatin1Char('0'));
    }
    else{
      vehiclePack[21] = QString("%1").arg(1,1,16,QLatin1Char('0'));
    }
}
//����С������
QVector <qint64> VehicleDataFactPack::splitDouble(double data,qint16 digit)
{
  QVector <qint64> temp ;
  QString data_str = QString::number(data,'f',digit).toUtf8();
  QStringList list = data_str.split(".");
  for(int i =0; i<2 ;i++)
    temp.append(list[i].toInt());
  return temp;
}
//������ݲ�����У��
QString VehicleDataFactPack::pack()
{
    QString  pack;
    for(int i = 0;i<vehiclePack.size();++i){
         pack +=vehiclePack[i];
    }
    QByteArray pack_array = pack.toLatin1();
    long checksumtemp = 0;
    for(int i = 0; i < pack_array.size(); i++){
        checksumtemp +=pack_array[i];
    }
    QString checkSum   = QString("%1").arg(checksumtemp,4,16,QLatin1Char('0'));
    return pack+checkSum;
}
//���¼ܴ���Ϣ
//void VehicleDataFactPack::_updataFlightSorties()
//{
//    QStringList list;
//    QString userName = "010";

//}

DataController::DataController(void)
 : _networkMgr()
{
   dataSendTimer =new  QTimer();
   MultiVehicleManager *manager = qgcApp()->toolbox()->multiVehicleManager();
   connect(manager,&MultiVehicleManager::vehicleAdded, this,&DataController::dataFactAdd);
   connect(manager,&MultiVehicleManager::vehicleRemoved, this,&DataController::dataFactRemove);
   //��ʱ1�뷢��һ�η�����Ϣ����̨
   connect(dataSendTimer,&QTimer::timeout,this,&DataController::sendData);
   //������־��¼
   connect(dataSendTimer,&QTimer::timeout,this,&DataController::saveDataLocal);
   dataSendTimer->setInterval(1000);
   //�������ݿ��¼TUDO



}

VehicleDataFactPack* DataController::createDataFact(Vehicle* vehicle)
{
  if(vehicle!=nullptr){
   //Ϊ��ͬ���ͷɻ�ʵ������ͬ������
   #ifdef HY600
      if(this->_dataPack==nullptr){
          _dataPack =new VehicleDataFactPack();
      }
   #endif
     return _dataPack;
  }
   return nullptr;
}

//����ȽϷ�������ĳɺ���ģ��//
void DataController::dataFactAdd(Vehicle* vehicle)
{
   VehicleDataFactPack * data  =this->createDataFact(vehicle);
   if((data!=nullptr)){
       connect(vehicle,&Vehicle::vehicleTakeOff,data,&VehicleDataFactPack::_vehicleTakeOff);
       connect(vehicle,&Vehicle::vehicleLand,data,&VehicleDataFactPack::_vehicleLand);
       connect(vehicle,&Vehicle::vehicleFlightTime,data,&VehicleDataFactPack::_vehicleFlightTime);
       connect(vehicle,&Vehicle::vehicleSprayState,data,&VehicleDataFactPack::_vehicleSprayState);
       connect(vehicle,&Vehicle::vehicleid,data,&VehicleDataFactPack::_vehicleid);
       connect(vehicle,&Vehicle::vehicleFlowRate,data,&VehicleDataFactPack::_vehicleFlowRate);
       connect(vehicle,&Vehicle::vehicleWorkArea,data,&VehicleDataFactPack::_vehicleWorkArea);
       connect(vehicle,&Vehicle::vehicleLongitude,data,&VehicleDataFactPack::_vehicleLongitude);
       connect(vehicle,&Vehicle::vehicleLatitude,data,&VehicleDataFactPack::_vehicleLatitude);
       connect(vehicle,&Vehicle::vehicleFlighTaltiTude,data,&VehicleDataFactPack::_vehicleFlighTaltiTude);
       connect(vehicle,&Vehicle::vehicleGroundFlightSpeed,data,&VehicleDataFactPack::_vehicleGroundFlightSpeed);
       connect(vehicle,&Vehicle::vehicleDataSendTime,data,&VehicleDataFactPack::_vehicleDataSendTime);
       connect(vehicle,&Vehicle::vehicleMsgText,data,&VehicleDataFactPack::_vehicleMsgText);
       connect(vehicle,&Vehicle::vehicleFlightMode,data,&VehicleDataFactPack::_vehicleFlightMode);     
       connect(this,&DataController::sendDataNumAdd,data,&VehicleDataFactPack::_vehicleDataSendNumChanged);
       dataSendTimer->start();
   }
}

void DataController::dataFactRemove(Vehicle* vehicle)
{
    if(vehicle!=nullptr&&_dataPack!=nullptr){
           _dataPack->deleteLater();
           dataSendTimer->stop();
    }
}

//���͵���̨
void DataController::sendData()
{
      mSocket.connectToHost("192.168.3.113",8901);
      if (mSocket.waitForConnected(100)) {
          if(_dataPack!=nullptr){
             if(mSocket.write(_dataPack->pack().toLocal8Bit())){
                emit sendDataNumAdd();
             }
             mSocket.flush();
             mSocket.close();
          }
      }
}

//TODU ��Ҫ�ع�
//�����Ǵ洢������ ����AppSetting ���ļ��д��
void DataController::saveDataLocal()
{
   if(_dataPack!=nullptr){
   QString min = QDateTime::currentDateTime().toString("yyyyMMdd");
   QString timestr = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss");
#if !defined(__android__)
   QString dir_path =  "../DATA_SAVE";
#else
   QString dir_path =  "/storage/emulated/0/DATA_SAVE";
#endif
   QDir dir;
   if(!dir.exists(dir_path)){
       dir.mkdir(dir_path);
       qDebug() << "Create Dir";
   }
   QString save_filename = dir_path + "/" + min + ".txt";
   QFile f(save_filename);
   QTextStream in(&f);
   if(!f.open( QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text)){
       qDebug()<<"Write Error";
       return;
   }
   in <<_dataPack->pack().toLocal8Bit();
   f.flush();
   f.close();
   }
}





















