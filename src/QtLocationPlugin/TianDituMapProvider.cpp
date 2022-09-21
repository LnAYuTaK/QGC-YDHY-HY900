#include "TianDiTuMapProvider.h"
#include <QNetworkRequest>
TianDiTuMapProvider::TianDiTuMapProvider(const QString &imageFormat,
                                         const quint32 averageSize,
                                         const QGeoMapType::MapStyle mapType,
                                         QObject *parent)
                                         : MapProvider(QString(),
                                                       QString(),
                                                       averageSize,
                                                       mapType, parent)
{

}

QNetworkRequest TianDiTuMapProvider::getTileURL(const int x,
                                                const int y,
                                                const int zoom,
                                                QNetworkAccessManager* networkManager)
{
    //-- Build URL
    QNetworkRequest request;
    const QString url = _getURL(x, y, zoom, networkManager);
    if (url.isEmpty()) {
        return request;
    }
    request.setUrl(QUrl(url));
    return request;
}


QString TianDiTuSatelliteMapProvider::_getURL(const int x, const int y, const int zoom, QNetworkAccessManager* networkManager)
{
    Q_UNUSED(networkManager)
    //最大放大17倍
    if(zoom>17){
        return "";
    }
    return QStringLiteral("http://t2.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST"
                          "=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSE"
                          "T=w&FORMAT=tiles&TILEMATRIX=%1&TILEROW=%2&TILECOL=%3&tk=%4")
                          .arg(zoom).arg(y).arg(x).arg(QStringLiteral("f729f5d20736567e0be3ce26d3b2ef09"));   //网页版密钥
}

QString TianDiTuTextMapProvider::_getURL(const int x, const int y, const int zoom, QNetworkAccessManager* networkManager) {
    Q_UNUSED(networkManager)
    //最大放大17倍
    if(zoom>17){
        return "";
    }
    return QStringLiteral("http://t2.tianditu.gov.cn/cia_w/wmts?SERVICE=WMTS&REQUEST"
                          "=GetTile&VERSION=1.0.0&LAYER=cia&STYLE=default&TILEMATRIXSET"
                          "=w&FORMAT=tiles&TILEMATRIX=%1&TILEROW=%2&TILECOL=%3&tk=%4")
                          .arg(zoom).arg(y).arg(x).arg(QStringLiteral("f729f5d20736567e0be3ce26d3b2ef09"));

}






