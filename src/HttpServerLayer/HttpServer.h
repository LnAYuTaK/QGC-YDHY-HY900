#ifndef HTTPSERVER_H
#define HTTPSERVER_H

#include "QGCToolbox.h"
class HttpServerWorker;
class HttpTask;
class HttpServer : public QGCTool
{
    Q_OBJECT
public:
    HttpServer(QGCApplication* app, QGCToolbox* toolbox);

    void setToolbox (QGCToolbox* toolbox) override;

private:
    HttpServerWorker  * _worker;



signals:
    void _getWebPlanTask(HttpTask *task);
    void _handleJsonData(HttpTask *task);
public slots:
    //

    //测试接口
    void test();




};

#endif // HTTPSERVER_H
