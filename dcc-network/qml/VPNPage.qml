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

    visible: item
    // pageType: DccObject.MenuEditor
    // page: devCheck
    page: DccSettingsView {}
    Component {
        id: devCheck
        D.Switch {
            checked: item.isEnabled
            enabled: item.enabledable
        }
    }

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
            page: devCheck
        }
        DccObject {
            name: "networkList"
            parentName: root.name + "/body"
            weight: 20
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
                        checked: true
                        backgroundVisible: false
                        corners: getCornersForBackground(index, repeater.count)
                        cascadeSelected: true
                        Layout.fillWidth: true
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
        parentName: root.name

        DccObject {
            name: "spacer"
            parentName: root.name + "/footer"
            hasBackground: false
            weight: 20
            pageType: DccObject.Item
            page: Item {
                Layout.fillWidth: true
            }
        }
        DccObject {
            name: "exVpn"
            parentName: root.name + "/footer"
            hasBackground: false
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
                text: qsTr("导入VPN")
                Layout.alignment: Qt.AlignRight
            }
        }
        DccObject {
            name: "addVpn"
            parentName: root.name + "/footer"
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
                text: qsTr("添加新的VPN")
                Layout.alignment: Qt.AlignRight
            }
        }
    }
}
