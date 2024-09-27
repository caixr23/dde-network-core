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
    page: DccSettingsView {}

    DccObject {
        name: "body"
        parentName: root.name

        DccObject {
            name: "title"
            parentName: root.name +"/body"
            displayName: root.displayName
            icon: "dcc_network"
            weight: 10
            hasBackground: true
            pageType: DccObject.Editor
            page:         D.Switch {
                checked: item.isEnabled
                enabled: item.enabledable
            }
        }
        DccObject {
            name: "proxyType"
            parentName: root.name +"/body"
            displayName: qsTr("代理设置")
            weight: 20
            hasBackground: true
            pageType: DccObject.Editor
            page:         ComboBox {
            }
        }
    }
    DccObject {
        name: "footer"
        parentName: root.name

        DccObject {
            name: "cancel"
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
                text: qsTr("取消")
                Layout.alignment: Qt.AlignRight
            }
        }
        DccObject {
            name: "Save"
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
                text: qsTr("保存")
                Layout.alignment: Qt.AlignRight
            }
        }
    }
}
