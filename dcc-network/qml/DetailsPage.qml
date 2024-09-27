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
    property var detailsItems: []

    visible: item
    page: DccSettingsView {}
    Component {
        id: detailsInfo
        DccObject {
            property var infoItem: null

            name: infoItem.name
            parentName: root.name + "/body"
            weight: 10 + infoItem.index
            pageType: DccObject.Item
            page: DccGroupView {
                isGroup: false
            }
            DccObject {
                name: "title"
                parentName: root.name + "/body/" + infoItem.name
                displayName: infoItem.name
                weight: 10
                pageType: DccObject.Item
                page: RowLayout {
                    Label {
                        Layout.alignment: Qt.AlignLeft
                        font: DccUtils.copyFont(D.DTK.fontManager.t4, {
                                                    "bold": true
                                                })
                        text: dccObj.displayName
                    }
                    IconLabel {
                        property bool clipboard: false
                        Layout.alignment: Qt.AlignRight
                        icon.name: "network"
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton
                            onClicked: {
                                let text = [infoItem.name]
                                for (let i in infoItem.details) {
                                    text.push(infoItem.details[i][0] + "\t" + infoItem.details[i][1])
                                }
                                dccData.setClipboard(text.join("\n"))
                                ToolTip.show(qsTr("信息已复制"), 2000)
                            }
                        }
                    }
                }
            }
            DccObject {
                name: "details"
                parentName: root.name + "/body/" + infoItem.name
                weight: 20
                // hasBackground: true
                pageType: DccObject.Item
                onParentItemChanged: {
                    if (parentItem) {
                        parentItem.topPadding = 0
                        parentItem.bottomPadding = 0
                        parentItem.leftPadding = 0
                        parentItem.rightPadding = 0
                    }
                }
                page: ColumnLayout {
                    clip: true
                    spacing: 0
                    Repeater {
                        id: repeater
                        model: infoItem.details

                        delegate: ItemDelegate {
                            implicitHeight: 36
                            text: modelData[0]
                            checked: false
                            backgroundVisible: true
                            corners: getCornersForBackground(index, repeater.count)
                            cascadeSelected: true
                            Layout.fillWidth: true
                            leftPadding: 10
                            rightPadding: 10
                            content: TextInput {
                                text: modelData[1]
                                color: palette.text
                                selectedTextColor: palette.highlightedText
                                selectionColor: palette.highlight
                                readOnly: true
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

    DccObject {
        name: "body"
        parentName: root.name
    }
    DccObject {
        name: "footer"
        parentName: root.name

        DccObject {
            name: "checkNetwork"
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
                text: qsTr("网络检测")
                Layout.alignment: Qt.AlignRight
            }
        }
    }

    function updateDetailsItems() {
        if (item) {
            const delDetailsItems = detailsItems.concat()
            for (let i in item.children) {
                let child = item.children[i]
                console.log("=======child details:", child, child.name, child.details)
                let index = delDetailsItems.findIndex(tmpItem => tmpItem.infoItem === child)
                if (index >= 0) {
                    delDetailsItems.splice(index, 1)
                    console.log("con-----", child)
                } else {
                    let details = detailsInfo.createObject(root, {
                                                               "infoItem": child
                                                           })
                    console.log("addObject", details)
                    DccApp.addObject(details)
                    detailsItems.push(details)
                }
            }
            for (const delItem of delDetailsItems) {
                DccApp.removeObject(delItem)
                let index = detailsItems.findIndex(item => delItem === item)
                if (index >= 0) {
                    detailsItems.splice(index, 1)
                }
                console.log("============remove details:", delItem, delItem.name)
                delItem.destroy()
            }
        }
    }

    onItemChanged: updateDetailsItems()
    Connections {
        target: item
        function onChildrenChanged() {
            updateDetailsItems()
        }
    }
}
