#ifndef NETLAYER_H
#define NETLAYER_H

//QT Head
#include <QObject>
#include <QTcpSocket>
#include <QFile>
#include <QThread>
#include <QDataStream>
#include <QCryptographicHash>
#include <QTimer>
#include <QTime>
#include <QFileInfo>
//QGC Head
#include "QGCApplication.h"
#include "HySettings.h"
//����׼���ع�һ����Ϊ�����������
class NetLayer : public QObject
{
    Q_OBJECT
public:
    explicit NetLayer(QObject *parent = nullptr);
    //����ʱ��
    QTimer*  TaskTimeOut ;
    //�ظ���QML��ʾ�Ĵ�������ö��
private:

public slots:

    //Task
    void SendBinLogFile(QString);
    //Task
    //void SendData();
private slots:


signals:
    void LogSendSuccess();
    void LogSendFail();
};

#endif // NETLAYER_H
