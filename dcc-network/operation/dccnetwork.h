// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: GPL-3.0-or-later
#ifndef DCCNETWORK_H
#define DCCNETWORK_H
#include "netitem.h"
#include "netmanager.h"

#include <QObject>

namespace dde {
namespace network {

class DccNetwork : public QObject
{
    Q_OBJECT
    Q_PROPERTY(NetManager* manager READ manager NOTIFY managerChanged)
    Q_PROPERTY(NetItem* root READ root NOTIFY rootChanged)

public:
    explicit DccNetwork(QObject *parent = nullptr);
    NetItem *root() const;

    NetManager *manager() const { return m_manager; }

public Q_SLOTS:
    void exec(NetManager::CmdType cmd, const QString &id, const QVariantMap &param = QVariantMap()); // 执行操作
    void setClipboard(const QString &text);

Q_SIGNALS:
    void request(NetManager::CmdType cmd, const QString &id, const QVariantMap &param);

    void managerChanged(NetManager *manager);
    void rootChanged();

protected Q_SLOTS:
    void init();

protected:
    NetManager *m_manager;
};
} // namespace network
} // namespace dde

#endif // DCCNETWORK_H
