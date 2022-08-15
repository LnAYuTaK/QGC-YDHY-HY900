#include "NetWorkManager.h"

class ParameterEditorController;
//
Task ::Task(){


}
Task ::~Task(){

}

//-------------------------------------------------------------------------------
LogSendTask ::LogSendTask (QString filename,QGCLogEntry* logentry)
{
    this->_logFile  = filename;
    this->_logEntry = logentry;
}

LogSendTask::~LogSendTask()
{
   _logEntry->deleteLater();
}

bool LogSendTask::_ready()
{

    _file.setFileName(_logFile);
    if(_file.exists())
    {
       QFileInfo fileInfo(_logFile);
       QString FileName = fileInfo.baseName();
       _mutex.lock();
       if(_file.open(QIODevice::ReadOnly))
       {
         _filedata = _file.readAll();
         _mutex.unlock();
         _reqPack = "FFFF:"+_md5.toHex()+':'+"Data"+':'+FileName+"\n";
         _md5 = QCryptographicHash::hash(_filedata, QCryptographicHash::Md5);
         _file.close();
         return true;
       }
       return false;
    }
   emit  error("File Not Exists");
   return false;
}
//-------------------------------------------------------------------------------
void LogSendTask::run()
{
     QString IP =  "192.168.3.113";
     qint64 Port =  8901;
     QTcpSocket _targetSocket;
     _targetSocket.connectToHost(IP,Port);
     _targetSocket.waitForConnected(2000);
     if ((_targetSocket.state() != QAbstractSocket::ConnectedState)) {
         _logEntry->setStatus("NET ERROR");
          return;
     }
     //���� �����  ���ļ����� û�ְ�
     _targetSocket.write(_reqPack.toLatin1());
     qint64 sendSize = _targetSocket.write(_filedata);
     qDebug() <<"SendSize:"<< sendSize;
     //ˢ���»�����
     _targetSocket.flush();
     //�����ж��·�������Ϣ  ���Ĳ�ͬ״̬�����ݶ�Ϊ���ͳɹ�
     _logEntry->setStatus("SEND OK");
     _targetSocket.close();
}

void LogSendTask ::work()
{
    if(_ready()) {
       this->start();
    }
}

//-------------------------------------------------------------------------------
NetWorkManager :: NetWorkManager(QGCApplication* app, QGCToolbox* toolbox)
 : QGCTool(app, toolbox)
{

}

void NetWorkManager::setToolbox(QGCToolbox *toolbox)
{
    QGCTool::setToolbox(toolbox);
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qmlRegisterSingletonInstance<NetWorkManager>("QGroundControl.NetWorkManager", 1, 0, "NetWorkManager", qgcApp()->toolbox()->netWorkManager());
}

void NetWorkManager::createLogTask(QString filename,QGCLogEntry* logEntry)
{

     LogSendTask* task = new LogSendTask(filename,logEntry);
     this->addTask(task);
}

bool NetWorkManager::addTask(Task *task)
{
    if(task!=nullptr){
       _mutex.lock();
       _taskQueue.enqueue(task);
       _mutex.unlock();
       return true;
    }
    task->deleteLater();
    return  false;
}

void NetWorkManager::_workerError(QString errorMessage)
{
    _errorMessage = errorMessage;
}

//ִ�ж����������
void NetWorkManager::runTask()
{
    Task* task = nullptr;
    forever{
        if (_taskQueue.isEmpty()) {
           break;
        }
        // ��ȡһ������
       task= _taskQueue.dequeue();
       if (task){
         task->work();
         //
      }
   }
}

