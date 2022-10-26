#include "HttpServer.h"
#include "HttpServerWorker.h"
#include "HttpTaskData.h"
#include <QtQml>
HttpServer::HttpServer(QGCApplication* app, QGCToolbox* toolbox)
    : QGCTool           (app, toolbox)
    , _worker(nullptr)
{

}
//-----------------------------------------------------------------------------
void
HttpServer::setToolbox(QGCToolbox *toolbox)
{
    QGCTool::setToolbox(toolbox);
    //实例化worker
    QThread * workerThread = new QThread(nullptr);   //为保证实时性，移动到子线程中进行调用
    _worker = new HttpServerWorker();
    QObject::connect(workerThread, &QThread::finished, _worker, &QObject::deleteLater);      // 清理线程
    connect(workerThread, SIGNAL(started()), _worker, SLOT(workInit()));
    _worker->moveToThread(workerThread);
    if(_worker){
        workerThread->start();
    }
    //这里绑定信号
    QObject::connect(this, &HttpServer::_getWebPlanTask,_worker,&HttpServerWorker::_taskReqJsonData);
    QObject::connect(this, &HttpServer::_handleJsonData,_worker,&HttpServerWorker::_taskHandleDataToGCSFile);

}
//-----------------------------------------------------------------------------
void
HttpServer::test()
{
  //Test
  QUrl url("http://api.bilibili.com/x/relation/stat?vmid=21228933");
  emit  _getWebPlanTask(new ReqJsonDataTask(url));
}
//-----------------------------------------------------------------------------



















