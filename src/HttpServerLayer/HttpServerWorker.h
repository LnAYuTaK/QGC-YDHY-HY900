#ifndef HTTPSERVERWORKER_H
#define HTTPSERVERWORKER_H

#include <QObject>
#include <QString>
#include <QHash>
#include <QDateTime>
#include <QThread>
#include <QQueue>
#include <QMutex>
#include <QWaitCondition>
#include <QMutexLocker>
#include <QtSql/QSqlDatabase>
#include <QHostInfo>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkProxy>
#include <QNetworkRequest>
#include <QJsonParseError>
#include <QJsonObject>
#include <QTime>
class HttpServer;
//HttpTask基类
class HttpTask : public QObject
{
    Q_OBJECT
public:
    enum TaskType {
      //请求规划任务
      taskReqJsonData,
      //转换JSON文件成地面站的JSON文件
      taskHandleDataToGCSFile
    };
    HttpTask(TaskType type)
        : _type(type)
    {}
    virtual ~HttpTask()
    {}
    virtual TaskType    type            () { return _type; }

    void setError(QString errorString = QString())
    {
        emit error(_type, errorString);
    }
    Q_ENUM(TaskType)
signals:
    void error  (HttpTask::TaskType type, QString errorString);
private:
    TaskType    _type;
};

//根据不同请求执行不同的Worker
class HttpServerWorker :  public QObject
{
    Q_OBJECT
public:
    HttpServerWorker();
    ~HttpServerWorker();

public slots:
    void    workInit        ();
    void    setDatabaseFile (const QString& path);
private:
//  void    _runTask                (HttpTask* task);
    bool    _connectDB();
    void    _disconnectDB();
    bool    _createDB(QSqlDatabase& db);

public slots:
    void    _taskReqJsonData(HttpTask *task);
    void    _taskHandleDataToGCSFile(HttpTask *task);
private:
    QMutex                          _taskQueueMutex;
    QWaitCondition                  _waitc;
    QScopedPointer<QSqlDatabase>    _db;
    QString                         _databasePath;
    std::atomic_bool                _valid;
    QNetworkAccessManager*          _netManager;
    HttpServer *                    _serverManager;
signals:

};

#endif // HTTPSERVERWORKER_H
