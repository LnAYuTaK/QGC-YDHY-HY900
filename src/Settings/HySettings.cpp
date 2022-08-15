#include "HySettings.h"
#include "SettingsManager.h"

HySettings * HySettings::instance =nullptr;

QSettings * HySettings::NetSetting =nullptr;
QSettings * HySettings::UserSetting =nullptr;

const char* HySettings::NetWorkConfigFile = "NetConfig.ini";
const char* HySettings::UserConfigFile = "User.ini";

HySettings::HySettings()
{

}
HySettings *HySettings::getSettings()
{
//   if(instance==nullptr)
//   {
//        instance  = new HySettings();
//        QString SettingPath = qgcApp()->toolbox()->settingsManager()->appSettings()->settingSavePath();
//        �����ж���Ϊini�Ƚ���Ҫ���Զ��μ���
//        QDir dir(SettingPath);
//        if(!dir.exists()){
//            dir.mkdir(SettingPath);
//        }
//        QStringList Settinglist= dir.entryList(QStringList()<<"*.ini",  QDir::Files | QDir::Readable, QDir::Name);
//        foreach(QString filename , Settinglist)
//        {
//            if(filename == NetWorkConfigFile){
//               NetSetting = new QSettings(dir.absoluteFilePath(filename),QSettings::IniFormat);
//            }
//            if(filename == UserConfigFile){
//               UserSetting = new QSettings(dir.absoluteFilePath(filename),QSettings::IniFormat);
//            }
//        }
//    }
    return instance;
}

QVariant HySettings::getNetValue(QString configtype,const QString &section,const QString &key)
{
   QString query  = section +'/'+ key;
   if((configtype=="Net")&&(NetSetting!=nullptr))
   {
    return NetSetting->value(query);
   }
   if((configtype=="User")&&(UserSetting!=nullptr))
   {
    return UserSetting->value(query);
   }
   return 0;
}












