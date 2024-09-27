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

    name: "wired" + item.pathIndex
    parentName: "network"
    displayName: item.name
    hasBackground: true
    icon: "dcc_music"
    weight: 1010 + item.pathIndex
    pageType: DccObject.MenuEditor
    page: devCheck

    Component {
        id: devCheck
        D.Switch {
            checked: item.isEnabled
            enabled: item.enabledable
        }
    }

    DccObject {
        name: "page"
        parentName: root.name
        page: DccSettingsView {}
        DccObject {
            name: "body"
            parentName: root.name + "/page"
            DccObject {
                name: "title"
                parentName: root.name + "/page/body"
                displayName: item.name
                icon: "dcc_network"
                weight: 10
                hasBackground: true
                pageType: DccObject.Editor
                page: devCheck
            }
            DccObject {
                name: "nocable"
                parentName: root.name + "/page/body"
                displayName: item.name
                weight: 20
                hasBackground: true
                pageType: DccObject.Item
                visible: item.status === NetType.DS_NoCable
                page: Item {
                    implicitHeight: 80
                    Label {
                        anchors.centerIn: parent
                        text: qsTr("请您先插入网线")
                    }
                }
            }
            DccObject {
                name: "networkList"
                parentName: root.name + "/page/body"
                weight: 30
                pageType: DccObject.Item
                hasBackground: true
                page: ColumnLayout {
                    clip: true
                    spacing: 0
                    Repeater {
                        id: repeater
                        model: NetItemModel {
                            root: item
                        }

                        delegate: ItemDelegate {
                            implicitHeight: 36
                            text: model.item.name
                            // icon.name: model.icon
                            checked: true
                            backgroundVisible: false
                            corners: getCornersForBackground(index, repeater.count)
                            cascadeSelected: true
                            Layout.fillWidth: true
                            icon.name: "network-online-symbolic"
                            // "network-setting"
                            content: RowLayout {
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
        DccObject {
            name: "footer"
            parentName: root.name + "/page"

            DccObject {
                name: "addNetwork"
                parentName: root.name + "/page/footer"
                hasBackground: false
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
                    text: qsTr("添加网络设置")
                    Layout.alignment: Qt.AlignRight
                }
            }
        }
    }
}
