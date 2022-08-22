import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs  1.2
import QtQuick.Layouts  1.2

import QGroundControl                       1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Palette               1.0
import QGroundControl.Controllers           1.0
import QGroundControl.SettingsManager       1.0
//数传界面
Rectangle{
    id:                 _linkRoot
    anchors.fill:       parent
    anchors.margins:    ScreenTools.defaultFontPixelWidth

    property real   _labelWidth:                ScreenTools.defaultFontPixelWidth * 15
    property real   _comboFieldWidth:           ScreenTools.defaultFontPixelWidth * 25
    property real   _valueFieldWidth:           ScreenTools.defaultFontPixelWidth * 8
    property var    _videoSettings:             QGroundControl.settingsManager.videoSettings
    property string _videoSource:               _videoSettings.videoSource.rawValue
    property bool   _isGst:                     QGroundControl.videoManager.isGStreamer
    property bool   _isUDP264:                  _isGst && _videoSource === _videoSettings.udp264VideoSource
    property bool   _isUDP265:                  _isGst && _videoSource === _videoSettings.udp265VideoSource
    property bool   _isRTSP:                    _isGst && _videoSource === _videoSettings.rtspVideoSource
    property bool   _isTCP:                     _isGst && _videoSource === _videoSettings.tcpVideoSource
    property bool   _isMPEGTS:                  _isGst && _videoSource === _videoSettings.mpegtsVideoSource
    property bool   _videoAutoStreamConfig:     QGroundControl.videoManager.autoStreamConfigured
    property bool   _showSaveVideoSettings:     _isGst || _videoAutoStreamConfig
    property bool   _disableAllDataPersistence: QGroundControl.settingsManager.appSettings.disableAllPersistence.rawValue

    property string gpsDisabled: "Disabled"
    property string gpsUdpPort:  "UDP Port"
    readonly property real _internalWidthRatio: 0.6
    ColumnLayout{
        id:         videoGrid
        spacing :   5
        visible:    _videoSettings.visible
        QGCLabel {
            id:         videoSourceLabel
            text:       qsTr("Source")
            visible:    !_videoAutoStreamConfig && _videoSettings.videoSource.visible
        }
        FactComboBox {
            id:                     videoSource
            Layout.preferredWidth:  _comboFieldWidth
            indexModel:             false
            fact:                   _videoSettings.videoSource
            visible:                videoSourceLabel.visible
        }
        QGCLabel {
            id:         udpPortLabel
            text:       qsTr("UDP Port")
            visible:    !_videoAutoStreamConfig && (_isUDP264 || _isUDP265 || _isMPEGTS) && _videoSettings.udpPort.visible
        }
        FactTextField {
            Layout.preferredWidth:  _comboFieldWidth
            fact:                   _videoSettings.udpPort
            visible:                udpPortLabel.visible
        }

        QGCLabel {
            id:         rtspUrlLabel
            text:       qsTr("RTSP URL")
            visible:    !_videoAutoStreamConfig && _isRTSP && _videoSettings.rtspUrl.visible
        }
        FactTextField {
            Layout.preferredWidth:  _comboFieldWidth
            fact:                   _videoSettings.rtspUrl
            visible:                rtspUrlLabel.visible
        }


        QGCLabel {
            id:         tcpUrlLabel
            text:       qsTr("TCP URL")
            visible:    !_videoAutoStreamConfig && _isTCP && _videoSettings.tcpUrl.visible
        }
        FactTextField {
            Layout.preferredWidth:  _comboFieldWidth
            fact:                   _videoSettings.tcpUrl
            visible:                tcpUrlLabel.visible
        }
//        QGCLabel {
//            text:                   qsTr("Aspect Ratio")
//            visible:                !_videoAutoStreamConfig && _isGst && _videoSettings.aspectRatio.visible
//        }
//        FactTextField {
//            Layout.preferredWidth:  _comboFieldWidth
//            fact:                   _videoSettings.aspectRatio
//            visible:                !_videoAutoStreamConfig && _isGst && _videoSettings.aspectRatio.visible
//        }
        QGCLabel {
            id:         videoFileFormatLabel
            text:       qsTr("File Format")
            visible:    _showSaveVideoSettings && _videoSettings.recordingFormat.visible
        }
        FactComboBox {
            Layout.preferredWidth:  _comboFieldWidth
            fact:                   _videoSettings.recordingFormat
            visible:                videoFileFormatLabel.visible
        }
//        QGCLabel {
//            id:         maxSavedVideoStorageLabel
//            text:       qsTr("Max Storage Usage")
//            visible:    _showSaveVideoSettings && _videoSettings.maxVideoSize.visible && _videoSettings.enableStorageLimit.value
//        }
        FactTextField {
            Layout.preferredWidth:  _comboFieldWidth
            fact:                   _videoSettings.maxVideoSize
            visible:                _showSaveVideoSettings && _videoSettings.enableStorageLimit.value && maxSavedVideoStorageLabel.visible
        }
        QGCLabel {
            id:         videoDecodeLabel
            text:       qsTr("Video decode priority")
            visible:    forceVideoDecoderComboBox.visible
        }
        FactComboBox {
            id:                     forceVideoDecoderComboBox
            Layout.preferredWidth:  _comboFieldWidth
            fact:                   _videoSettings.forceVideoDecoder
            visible:                fact.visible
            indexModel:             false
        }


                Item { width: 1; height: 1}
                FactCheckBox {
                    text:       qsTr("Disable When Disarmed")
                    fact:       _videoSettings.disableWhenDisarmed
                    visible:    !_videoAutoStreamConfig && _isGst && fact.visible
                }

//                Item { width: 1; height: 1}
//                FactCheckBox {
//                    text:       qsTr("Low Latency Mode")
//                    fact:       _videoSettings.lowLatencyMode
//                    visible:    !_videoAutoStreamConfig && _isGst && fact.visible
//                }

//                Item { width: 1; height: 1}
//                FactCheckBox {
//                    text:       qsTr("Auto-Delete Saved Recordings")
//                    fact:       _videoSettings.enableStorageLimit
//                    visible:    _showSaveVideoSettings && fact.visible
//                }

    }
}
