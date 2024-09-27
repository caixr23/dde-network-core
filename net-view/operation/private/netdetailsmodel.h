// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: GPL-3.0-or-later
#ifndef NETDETAILSMODEL_H
#define NETDETAILSMODEL_H

#include <QAbstractItemModel>
#include <QObject>

namespace dde {
namespace network {
class NetDetailsModel : public QAbstractItemModel
{
    Q_OBJECT
public:
    explicit NetDetailsModel(QObject *parent = nullptr);
    void setDetails(const QList<QPair<QString, QString> > &details);

signals:
protected:
    QList<QPair<QString, QString> > m_details;
};
} // namespace network
} // namespace dde
#endif // NETDETAILSMODEL_H
