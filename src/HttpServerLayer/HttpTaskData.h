#ifndef HTTPTASKDATA_H
#define HTTPTASKDATA_H
#include "HttpServerWorker.h"
#include <QUrl>

class HandleDataToGCSFileTask : public HttpTask
{
    Q_OBJECT
public:
    HandleDataToGCSFileTask(QList<QString>&jsonData);
    //Test
    QList<QString> jsonValue(){return this->_jsonData;}
private:
    QList<QString> _jsonData;
};

class ReqJsonDataTask : public HttpTask
{
    Q_OBJECT
public:
    ReqJsonDataTask(QUrl &url);
    QNetworkRequest request(){return _request;}

public slots:
    void handleJsonData();

signals:
    void _handleJsonDataReady(HttpTask *task);

private:
    QMutex           _mutex;
    QNetworkRequest  _request;
};


#endif // HTTPTASKDATA_H
