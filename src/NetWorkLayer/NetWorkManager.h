#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H
#include <QTcpSocket>
#include <QObject>
#include <QMap>
#include <QQueue>
#include <QMutex>
#include "GeoTagController.h"
#include "QGCToolbox.h"
#include "DataHandle/DataController.h"
#include "LogDownloadController.h"
class QGCLogEntry;
struct LogDownloadData;
//Task ��������������ļ̳�
class Task    :public QThread
{
     Q_OBJECT
public :
    Task();
    //��Ҫ�Լ�ʵ��work������
    virtual void work() = 0;
    virtual ~Task() =0 ;
};
//��־����
class LogSendTask  :public Task
{
    Q_OBJECT
public:
    LogSendTask (QString filename , QGCLogEntry*  logEntry);
    ~LogSendTask();
    //Task Overrride
    void work               ();
protected:
    // Qthread Overrride
    void run                ();
signals:
    void error              (QString errorMsg);
    //���ͳɹ�����������ʾ���ͳɹ�
    void stateChanged       (QString stat);
private slots:
    //����׼������
    bool _ready              (void);
private:
    QMutex                  _mutex;
    QString                 _logFile;
    QFile                   _file;
    QByteArray              _md5;
    QString                 _reqPack;
    QByteArray              _filedata;
    QGCLogEntry *           _logEntry;
};

class NetWorkManager  :public QGCTool {

   Q_OBJECT
public:
   NetWorkManager                      (QGCApplication* app, QGCToolbox* toolbox);
   //QGCTool overrides
   void setToolbox                     (QGCToolbox* toolbox) final;
   //ʵ������ͬ������
   bool                  addTask       (Task * task);
   //ִ����������
   Q_INVOKABLE void      runTask       ();
   //ʵ������־����
   Q_INVOKABLE void      createLogTask (QString filename , QGCLogEntry*  logEntry);
private:
   QMutex                              _mutex;
   //������Ϣ
   QString                             _errorMessage;
   //��־���������
   QQueue<Task*>                       _taskQueue;

private slots:
   void _workerError                  (QString errorMsg);

};
#endif // NETWORKMANAGER_H
