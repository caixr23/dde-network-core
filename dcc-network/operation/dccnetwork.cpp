// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: GPL-3.0-or-later
#include "dccnetwork.h"

#include "dde-control-center/dccfactory.h"
#include "netitemmodel.h"
#include "netmanager.h"

#include <QClipboard>
#include <QCoreApplication>
#include <QDebug>
#include <QGuiApplication>
#include <QThread>
#include <QtQml/QQmlEngine>

// #include "dccfactory.h"

namespace dde {
namespace network {
DccNetwork::DccNetwork(QObject *parent)
    : QObject(parent)
    , m_manager(nullptr)
{
    qmlRegisterType<NetType>("org.deepin.dcc.network", 1, 0, "NetType");
    qmlRegisterType<NetItemModel>("org.deepin.dcc.network", 1, 0, "NetItemModel");
    QMetaObject::invokeMethod(this, "init", Qt::QueuedConnection);
    qWarning() << __FUNCTION__ << __LINE__ << QThread::currentThread() << qApp->thread() << thread();
}

NetItem *DccNetwork::root() const
{
    return m_manager->root();
}

void DccNetwork::exec(NetManager::CmdType cmd, const QString &id, const QVariantMap &param)
{
    m_manager->exec(cmd, id, param);
}

void DccNetwork::setClipboard(const QString &text)
{
    QGuiApplication::clipboard()->setText(text);
}

void DccNetwork::init()
{
    qWarning() << __FUNCTION__ << __LINE__ << QThread::currentThread() << qApp->thread() << thread();
    m_manager = new NetManager(NetType::Net_DccFlags, this);
    m_manager->updateLanguage(QLocale().name());
    connect(m_manager, &NetManager::request, this, &DccNetwork::request);
    Q_EMIT managerChanged(m_manager);
    Q_EMIT rootChanged();
}
DCC_FACTORY_CLASS(DccNetwork)
} // namespace network
} // namespace dde

#include "dccnetwork.moc"
