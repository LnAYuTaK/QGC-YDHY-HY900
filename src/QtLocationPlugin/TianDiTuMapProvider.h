#ifndef TIANDITUMAPPROVIDER_H
#define TIANDITUMAPPROVIDER_H

#include "MapProvider.h"
#include <QObject>
class TianDiTuMapProvider : public MapProvider
{
    Q_OBJECT
public:
    TianDiTuMapProvider(const QString &imageFormat,
                        const quint32 averageSize,
                        const QGeoMapType::MapStyle mapType,
                        QObject* parent = nullptr);

    QNetworkRequest getTileURL(const int x, const int y, const int zoom, QNetworkAccessManager* networkManager) override;
};

//天地图底片
class TianDiTuSatelliteMapProvider : public TianDiTuMapProvider {
    Q_OBJECT

  public:
  TianDiTuSatelliteMapProvider(QObject* parent = nullptr)
        : TianDiTuMapProvider(
              QStringLiteral("jpg"),
              AVERAGE_TILE_SIZE,
              QGeoMapType::SatelliteMapDay,
              parent)
  {

  }

    QString _getURL(const int x, const int y, const int zoom, QNetworkAccessManager* networkManager) override;
};

//天地图文字
class TianDiTuTextMapProvider : public TianDiTuMapProvider {
    Q_OBJECT

  public:
      TianDiTuTextMapProvider(QObject* parent = nullptr)
        : TianDiTuMapProvider(
              QStringLiteral("jpg"),
              AVERAGE_TILE_SIZE,
             QGeoMapType::SatelliteMapDay,
              parent)
  {

  }

    QString _getURL(const int x, const int y, const int zoom, QNetworkAccessManager* networkManager) override;
};






#endif // TIANDITUMAPPROVIDER_H
