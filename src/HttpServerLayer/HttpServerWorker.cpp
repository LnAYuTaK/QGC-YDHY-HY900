#include "HttpServerWorker.h"
#include "QGCApplication.h"
#include "HttpServer.h"
#include "HttpTaskData.h"
#include "QGCToolbox.h"
#include <QtSql/QSqlQuery>
#include <QSqlError>
#include <QVariant>
HttpServerWorker::HttpServerWorker()
    :_db(nullptr)
    ,_valid(false)
    ,_netManager(new QNetworkAccessManager(this))
    ,_serverManager(qgcApp()->toolbox()->httpServerManager())
{

}
//-----------------------------------------------------------------------------
HttpServerWorker::~HttpServerWorker()
{
   _disconnectDB();
}
//-----------------------------------------------------------------------------
void
HttpServerWorker::workInit()
{
//检查数据库查询  加载数据库表
    //检查数据库是否存在

//     if(_connectDB()){
//         _createDB(*_db);
//     }


   if(_connectDB())
   {
      _valid = _createDB(*_db);
   }

}
//-----------------------------------------------------------------------------
void
HttpServerWorker::_disconnectDB()
{
    if (_db) {
        _db.reset();
        QSqlDatabase::removeDatabase("Test");
    }
}
//-----------------------------------------------------------------------------
bool
HttpServerWorker::_connectDB()
{
    _db.reset(new QSqlDatabase(QSqlDatabase::addDatabase("QSQLITE","Test")));
    _db->setDatabaseName(/*_databasePath*/QCoreApplication::applicationDirPath() + "/" + "test.db");
    _db->setConnectOptions("QSQLITE_ENABLE_SHARED_CACHE");
    _valid = _db->open();
    return _valid;
}
//-----------------------------------------------------------------------------
void
HttpServerWorker::setDatabaseFile (const QString& path)
{
    _databasePath = path;
}
//---------------------------------------------------------------------
bool
HttpServerWorker::_createDB(QSqlDatabase& db)
{
    //TUDO
    QSqlQuery query(db);
    if(!query.exec(
        "CREATE TABLE IF NOT EXISTS PlanValue ("
              "PlanID INTEGER PRIMARY KEY NOT NULL, "
              "format TEXT NOT NULL, "
              "time DATETIME NULL, "
              "size INTEGER, "
              "type INTEGER, "
              "date INTEGER DEFAULT 0)"))
    {

        return true;
    }
    else {
        return false;
    }
}
//------------------------------------------------------------------------------------
void  //向后台请求任务
HttpServerWorker::_taskReqJsonData(HttpTask *task)
{
    ReqJsonDataTask *reqTask = static_cast<ReqJsonDataTask*>(task);
    QNetworkRequest  request = reqTask->request();
    Q_UNUSED(reqTask)
    if(!_netManager) {
        _netManager = new QNetworkAccessManager(this);
    }
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, true);
    QNetworkReply* reply = _netManager->get(request);
    connect(reply, &QNetworkReply::finished,reqTask,&ReqJsonDataTask::handleJsonData);
}
//------------------------------------------------------------------------------------
void  //转换成地面站可以解析的文件
HttpServerWorker::_taskHandleDataToGCSFile(HttpTask *task)
{
    HandleDataToGCSFileTask *handleTask = static_cast<HandleDataToGCSFileTask*>(task);
    Q_UNUSED(handleTask)
    qDebug() << handleTask->jsonValue().at(0);
    //释放内存
    handleTask->deleteLater();
}
//------------------------------------------------------------------------------------







































