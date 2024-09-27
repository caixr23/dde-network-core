// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.15

import org.deepin.dtk 1.0 as D

import org.deepin.dcc 1.0
import org.deepin.dcc.network 1.0

DccObject {
    id: root
    property var wiredDevs: []
    property var wirelessDevs: []

    Component {
        id: wiredComponent
        WiredDevicePage {}
    }
    Component {
        id: wirelessComponent
        WirelessDevicePage {}
    }

    VPNPage {
        id: vpnPage
        name: "vpn"
        parentName: "network"
        displayName: qsTr("VPN")
        icon: "dcc_music"
        weight: 3010
    }
    SystemProxyPage {
        id: systemProxyPage
        name: "systemProxy"
        parentName: "network"
        displayName: qsTr("System Proxy")
        icon: "dcc_system_agent"
        weight: 3020
    }
    AppProxyPage {
        id: appProxyPage
        name: "applicationProxy"
        parentName: "network"
        displayName: qsTr("Application Proxy")
        icon: "dcc_app_proxy"
        weight: 3030
    }
    DccObject {
        name: "personalHotspot"
        parentName: "network"
        displayName: qsTr("Personal Hotspot")
        icon: "dcc_hotspot"
        weight: 3040
        pageType: DccObject.MenuEditor
        hasBackground: true
        page: D.Switch {}
        DccObject {
            name: "hotspotPage"
            parentName: "network/personalHotspot"
        }
    }
    AirplanePage {
        name: "airplaneMode"
        parentName: "network"
        displayName: qsTr("Airplane mode")
        description: qsTr("Turn off wireless communication")
        icon: "dcc_hotspot"
        weight: 3050
        item: dccData.root
    }
    DSLPage {
        id: dslPage
        name: "dsl"
        parentName: "network"
        displayName: qsTr("DSL")
        icon: "dcc_text"
        weight: 3060
    }
    // DccObject {
    //     name: "dsl"
    //     parentName: "network"
    //     displayName: qsTr("DSL")
    //     icon: "dcc_text"
    //     weight: 3060
    // }
    DetailsPage {
        id: detailsPage
        name: "networkDetails"
        parentName: "network"
        displayName: qsTr("Network Details")
        icon: "dcc_network"
        weight: 3070
    }
    function updateDevice() {
        const delWiredDevs = wiredDevs.concat()
        const delWirelessDevs = wirelessDevs.concat()
        console.log("==delWiredDevs==", delWiredDevs)
        for (let i in dccData.root.children) {
            let item = dccData.root.children[i]
            console.log("item=======", item, item.id, item.name, item.itemType)
            switch (item.itemType) {
            case NetType.WiredDeviceItem:
            {
                let index = delWiredDevs.findIndex(d => d.item === item)
                if (index >= 0) {
                    delWiredDevs.splice(index, 1)
                } else {
                    console.log("==createObject=123=", item)
                    let dev = wiredComponent.createObject(root, {
                                                              "item": item
                                                          })
                    console.log("==createObject==", (dev))
                    DccApp.addObject(dev)
                    wiredDevs.push(dev)
                }
            }
            break
            case NetType.WirelessDeviceItem:
            {
                let index = delWirelessDevs.findIndex(d => d.item === item)
                if (index >= 0) {
                    delWirelessDevs.splice(index, 1)
                } else {
                    console.log("==createObject=w=", item)
                    let dev = wirelessComponent.createObject(root, {
                                                                 "item": item
                                                             })
                    console.log("==createObject=ww=", dev)
                    DccApp.addObject(dev)
                    wirelessDevs.push(dev)
                }
            }
            break
            case NetType.VPNControlItem:
            {
                console.log("====vpn=========", item, vpnPage.item)
                if (vpnPage.item !== item) {
                    vpnPage.item = item
                }
            }
            break
            case NetType.SystemProxyControlItem:
            {
                console.log("====SystemProxy=========", item, systemProxyPage.item)
                if (systemProxyPage.item !== item) {
                    systemProxyPage.item = item
                }
                for(let k in item){
                    console.log("=SystemProxy=",k,item[k])
                }
                for(let k in item.manualProxy){
                    console.log("=SystemProxy.manualProxy=",k,item.manualProxy[k])
                }
            }
            break
            case NetType.AppProxyControlItem:
            {
                console.log("====AppProxy=========", item, appProxyPage.item)
                if (appProxyPage.item !== item) {
                    appProxyPage.item = item
                }
                for(let k in item){
                    console.log("=AppProxy=",k,item[k])
                }
            }
            break
            case NetType.DSLControlItem:
            {
                console.log("====dsl=========", item, dslPage.item)
                if (dslPage.item !== item) {
                    dslPage.item = item
                }
            }
            break
            case NetType.DetailsItem:
            {
                console.log("====details=========", item, detailsPage.item)
                if (detailsPage.item !== item) {
                    detailsPage.item = item
                }
            }
            break
            }
        }
        console.log("==delWiredDevs==", delWiredDevs)
        for (const delDev of delWiredDevs) {
            DccApp.removeObject(delDev)
            let index = wiredDevs.findIndex(item => delDev === item)
            if (index >= 0) {
                wiredDevs.splice(index, 1)
            }
            console.log("============remove:", delDev, delDev.name)
            delDev.destroy()
        }
        for (const delDev of delWirelessDevs) {
            DccApp.removeObject(delDev)
            let index = wirelessDevs.findIndex(item => delDev === item)
            if (index >= 0) {
                wirelessDevs.splice(index, 1)
            }
            console.log("remove:", delDev, delDev.name)
            delDev.destroy()
        }
    }
    Connections {
        target: dccData.root
        function onChildrenChanged() {
            updateDevice()
        }
    }
    Component.onCompleted: {
        console.log("=onCompleted")
        updateDevice()
    }
}
