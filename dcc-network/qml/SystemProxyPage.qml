// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1
import Qt.labs.qmlmodels 1.2

import org.deepin.dtk 1.0 as D

import org.deepin.dcc 1.0
import org.deepin.dcc.network 1.0

DccObject {
    id: root
    property var item: null
    property var method: item.method

    visible: item
    page: DccSettingsView {}

    DccObject {
        name: "body"
        parentName: root.name

        DccObject {
            name: "title"
            parentName: root.name + "/body"
            displayName: root.displayName
            icon: "dcc_network"
            weight: 10
            hasBackground: true
            pageType: DccObject.Editor
            page: D.Switch {
                checked: item.isEnabled
                enabled: item.enabledable
                onClicked: {
                    if (checked) {
                        method = NetType.Auto
                    } else {
                        method = NetType.None
                    }
                }
            }
        }
        DccObject {
            id: methodObj

            name: "method"
            parentName: root.name + "/body"
            displayName: qsTr("代理设置")
            weight: 20
            hasBackground: true
            visible: method !== NetType.None
            pageType: DccObject.Editor
            page: ComboBox {
                textRole: "text"
                valueRole: "value"
                currentIndex: indexOfValue(method)
                onActivated: method = currentValue
                model: [{
                        "value": NetType.Auto,
                        "text": qsTr("Auto")
                    }, {
                        "value": NetType.Manual,
                        "text": qsTr("Manual")
                    }]
                Component.onCompleted: {
                    method = item.method
                }
                Connections {
                    target: root
                    function onMethodChanged() {
                        currentIndex = indexOfValue(method)
                    }
                }
            }
            Connections {
                target: item
                function onMethodChanged(m) {
                    method = m
                }
            }
        }
        DccObject {
            id: autoUrl
            property var config: item.autoProxy
            name: "autoUrl"
            parentName: root.name + "/body"
            displayName: qsTr("配置URL")
            weight: 30
            hasBackground: true
            pageType: DccObject.Editor
            visible: method === NetType.Auto
            page: D.LineEdit {
                topInset: 4
                bottomInset: 4
                text: dccObj.config
                Layout.fillWidth: true
                onTextChanged: {
                    if (dccObj.config !== text) {
                        dccObj.config = text
                    }
                }
            }
        }
        SystemProxyConfigItem {
            id: http
            name: "http"
            parentName: root.name + "/body"
            displayName: qsTr("HTTP代理")
            visible: method === NetType.Manual
            weight: 40
            config: root.item.manualProxy.http
        }
        SystemProxyConfigItem {
            id: https
            name: "https"
            parentName: root.name + "/body"
            displayName: qsTr("HTTPS代理")
            visible: method === NetType.Manual
            weight: 50
            config: root.item.manualProxy.https
        }
        SystemProxyConfigItem {
            id: ftp
            name: "ftp"
            parentName: root.name + "/body"
            displayName: qsTr("FTP代理")
            visible: method === NetType.Manual
            weight: 60
            config: root.item.manualProxy.ftp
        }
        SystemProxyConfigItem {
            id: socks
            name: "socks"
            parentName: root.name + "/body"
            displayName: qsTr("SOCKS代理")
            visible: method === NetType.Manual
            weight: 70
            config: root.item.manualProxy.socks
        }
        DccObject {
            id: ignoreHosts
            property var config: root.item.manualProxy.ignoreHosts

            name: "ignoreHosts"
            parentName: root.name + "/body"
            displayName: qsTr("SOCKS代理")
            visible: method === NetType.Manual
            weight: 80
            pageType: DccObject.Item
            page: TextArea {
                wrapMode: TextEdit.WordWrap
                text: dccObj.config
                onTextChanged: {
                    if (dccObj.config !== text) {
                        dccObj.config = text
                    }
                }
            }
        }
        DccObject {
            name: "ignoreHostsTips"
            parentName: root.name + "/body"
            displayName: qsTr("忽略以上主机和域的代理配置")
            weight: 90
            visible: ignoreHosts.visibleToApp
            pageType: DccObject.Item
            page: Label {
                text: dccObj.displayName
            }
        }
    }
    DccObject {
        name: "footer"
        parentName: root.name

        DccObject {
            name: "spacer"
            parentName: root.name + "/footer"
            visible: method !== NetType.None
            weight: 20
            pageType: DccObject.Item
            page: Item {
                Layout.fillWidth: true
            }
        }
        DccObject {
            name: "cancel"
            parentName: root.name + "/footer"
            visible: method !== NetType.None
            displayName: qsTr("取消")
            weight: 30
            pageType: DccObject.Item
            page: Button {
                implicitHeight: implicitContentHeight + 10
                implicitWidth: implicitContentWidth + 10
                topPadding: 0
                bottomPadding: 0
                leftPadding: 0
                rightPadding: 0
                spacing: 0
                text: dccObj.displayName
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    method = root.item.method
                    autoUrl.config = root.item.autoProxy
                    http.config = root.item.manualProxy.http
                    https.config = root.item.manualProxy.https
                    ftp.config = root.item.manualProxy.ftp
                    socks.config = root.item.manualProxy.socks
                    ignoreHosts.config = root.item.manualProxy.ignoreHosts
                }
            }
        }
        DccObject {
            name: "Save"
            parentName: root.name + "/footer"
            displayName: qsTr("保存")
            visible: method !== NetType.None
            weight: 40
            pageType: DccObject.Item
            page: Button {
                implicitHeight: implicitContentHeight + 10
                implicitWidth: implicitContentWidth + 10
                topPadding: 0
                bottomPadding: 0
                leftPadding: 0
                rightPadding: 0
                spacing: 0
                text: dccObj.displayName
                Layout.alignment: Qt.AlignRight
                function printfObj(obj) {
                    for (let k in obj) {
                        console.log(k, obj[k])
                    }
                }

                onClicked: {
                    console.log("save:", method)
                    console.log("autoUrl.config :", autoUrl.config)
                    console.log("http.config:", http.config)
                    printfObj(http.config)
                    console.log("https.config:", https.config)
                    printfObj(https.config)
                    console.log("ftp.config:", ftp.config)
                    printfObj(ftp.config)
                    console.log("socks.config:", socks.config)
                    printfObj(socks.config)
                    console.log("ignoreHosts.config:", ignoreHosts.config)
                    // method = root.item.method
                    // autoUrl.config = root.item.autoProxy
                    // http.config = root.item.manualProxy.http
                    // https.config = root.item.manualProxy.https
                    // ftp.config = root.item.manualProxy.ftp
                    // socks.config = root.item.manualProxy.socks
                    // ignoreHosts.config = root.item.manualProxy.ignoreHosts
                }
            }
        }
    }
}
