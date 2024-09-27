// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: GPL-3.0-or-later
#include "netdetailsmodel.h"

namespace dde {
namespace network {
NetDetailsModel::NetDetailsModel(QObject *parent)
    : QAbstractItemModel(parent)
{
}

void NetDetailsModel::setDetails(const QList<QPair<QString, QString> > &details)
{
    beginResetModel();
    m_details = details;
    endResetModel();
}
} // namespace network
} // namespace dde
