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
    readonly property var c_levelString: ["-signal-no", "-signal-low", "-signal-medium", "-signal-high", "-signal-full"]

    name: "wireless" + item.pathIndex
    parentName: "network"
    displayName: item.name
    hasBackground: true
    icon: "dcc_music"
    weight: 2010 + item.pathIndex
    pageType: DccObject.MenuEditor
    page: devCheck

    Component {
        id: devCheck
        D.Switch {
            checked: item.isEnabled
            enabled: item.enabledable
        }
    }

    Component {
        id: networkList
        ColumnLayout {
            clip: true
            spacing: 0
            Repeater {
                id: repeater
                model: NetItemModel {
                    root: dccObj.item
                }
                delegate: DelegateChooser {
                    role: "type"
                    DelegateChoice {
                        roleValue: NetType.WirelessItem
                        delegate: ItemDelegate {
                            height: 36
                            text: model.item.name
                            checked: true
                            backgroundVisible: false
                            corners: getCornersForBackground(index, repeater.count)
                            cascadeSelected: true
                            Layout.fillWidth: true
                            leftPadding:10
                            rightPadding:10
                            spacing:10
                            icon {
                                name: "network-wireless" + (item.flags & 0x10 ? "-6" : "") + c_levelString[item.strengthLevel] + (item.secure ? "-secure" : "") + "-symbolic"
                                height: 16
                                width: 16
                            }
                            // "network-online-symbolic"
                            // "network-setting"
                            content: RowLayout {
                                spacing:10
                                BusyIndicator {
                                    running: model.item.status === NetType.CS_Connecting
                                    visible: running
                                }
                                DccCheckIcon {
                                    visible: model.item.status === NetType.CS_Connected
                                }
                                IconLabel {
                                    icon.name: "network-setting"
                                }
                            }

                            // checkable: false
                            // indicatorVisible: model.isDefault
                            onClicked: {

                            }
                            background: DccListViewBackground {
                                separatorVisible: true
                                highlightEnable: false
                            }
                        }
                    }
                    DelegateChoice {
                        roleValue: NetType.WirelessHiddenItem
                        delegate: ItemDelegate {
                            implicitHeight: 36
                            checked: true
                            backgroundVisible: false
                            corners: getCornersForBackground(index, repeater.count)
                            cascadeSelected: true
                            Layout.fillWidth: true
                            leftPadding:36
                            contentItem: Label {
                                text: model.item.name
                                color: palette.link
                            }
                            onClicked: {

                            }
                            background: DccListViewBackground {
                                separatorVisible: true
                                highlightEnable: false
                            }
                        }
                    }
                }
            }
        }
    }
    // Component {
    //     id: otherNetwork
    //     DccObject {
    //         checked: item.isEnabled
    //         enabled: item.enabledable
    //     }
    // }
    DccObject {
        name: "page"
        parentName: root.name
        DccObject {
            name: "title"
            parentName: root.name + "/page"
            displayName: item.name
            icon: "dcc_network"
            weight: 10
            hasBackground: true
            pageType: DccObject.Editor
            page: devCheck
        }
        DccObject {
            name: "mineTitle"
            parentName: root.name + "/page"
            displayName: qsTr("我的网络")
            visible: mineNetwork.visible
            weight: 30
            pageType: DccObject.Item
            page: Label {
                font: DccUtils.copyFont(D.DTK.fontManager.t5, {
                                            "bold": true
                                        })
                text: dccObj.displayName
            }
            onParentItemChanged: {
                if (parentItem) {
                    parentItem.topPadding = 5
                    parentItem.bottomPadding = 0
                    parentItem.leftPadding = 10
                }
            }
        }
        DccObject {
            id: mineNetwork
            property var item: null

            name: "mineNetwork"
            parentName: root.name + "/page"
            weight: 40
            pageType: DccObject.Item
            hasBackground: true
            visible: item
            page: networkList
        }
        DccObject {
            name: "otherTitle"
            parentName: root.name + "/page"
            displayName: qsTr("其他网络")
            visible: otherNetwork.visible
            weight: 50
            pageType: DccObject.Item
            page: Label {
                font: DccUtils.copyFont(D.DTK.fontManager.t6, {
                                            "bold": true
                                        })
                text: dccObj.displayName
            }
            onParentItemChanged: {
                if (parentItem) {
                    parentItem.topPadding = 5
                    parentItem.bottomPadding = 0
                    parentItem.leftPadding = 10
                }
            }
        }
        DccObject {
            id: otherNetwork
            property var item: null

            name: "otherNetwork"
            parentName: root.name + "/page"
            weight: 60
            pageType: DccObject.Item
            hasBackground: true
            visible: item
            page: networkList
        }
    }
    function updateItem() {
        let hasNet = 0
        for (let i in item.children) {
            const child = item.children[i]
            switch (child.itemType) {
            case NetType.WirelessMineItem:
                if (mineNetwork.item !== child) {
                    mineNetwork.item = child
                }
                hasNet |= 1
                break
            case NetType.WirelessOtherItem:
                if (otherNetwork.item !== child) {
                    otherNetwork.item = child
                }
                hasNet |= 2
                break
            }
        }
        if (!(hasNet & 1)) {
            mineNetwork.item = null
        }
        if (!(hasNet & 2)) {
            otherNetwork.item = null
        }
    }

    Connections {
        target: item
        function onChildrenChanged() {
            updateItem()
        }
    }
    Component.onCompleted: {
        console.log("=onCompleted")
        updateItem()
    }
}
