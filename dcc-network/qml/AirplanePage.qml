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

    visible: item && item.enabledable
    hasBackground: true
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
        name: "menu"
        parentName: root.name
        DccObject {
            name: "title"
            parentName: root.name + "/menu"
            displayName: root.displayName
            icon: "dcc_network"
            weight: 10
            hasBackground: true
            pageType: DccObject.Editor
            page: devCheck
        }
        DccObject {
            name: "airplaneTips"
            parentName: root.name + "/menu"
            weight: 20
            pageType: DccObject.Item
            page: DccLabel {
                text: qsTr("打开飞行模式将关闭无线网络、个人热点和蓝牙功能")
            }
        }
    }
}
