#include "HttpTaskData.h"
#include <QObject>
#include "QGCApplication.h"
#include "HttpServer.h"
#include <QList>
#include <QString>
//-----------------------------------------------------------------------------
HandleDataToGCSFileTask::HandleDataToGCSFileTask(QList<QString>&jsonData)
    :HttpTask(HttpTask::taskHandleDataToGCSFile)
    ,_jsonData(jsonData)
{

}
//-----------------------------------------------------------------------------
ReqJsonDataTask::ReqJsonDataTask(QUrl &url)
    :HttpTask(HttpTask::taskReqJsonData)
{
    _request.setUrl(url);
    QObject::connect(this,&ReqJsonDataTask::_handleJsonDataReady,qgcApp()->toolbox()->httpServerManager(),&HttpServer::_handleJsonData);
}
//-----------------------------------------------------------------------------
void
ReqJsonDataTask::handleJsonData()
{
    QMutexLocker lock(&_mutex);
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
    if(!reply) {
        return;
    }
    QByteArray data = reply->readAll();
    //这里解析JsonData
    //
    //原始数据传入
    QJsonParseError err;
    QJsonDocument json_recv = QJsonDocument::fromJson(data,&err);
    reply->deleteLater();
    lock.unlock();
    //Test
    QList<QString> json;
    json.append("list");
    emit _handleJsonDataReady(new HandleDataToGCSFileTask(json));
    //发送完信号后销毁释放
    this->deleteLater();
}
//-----------------------------------------------------------------------------












