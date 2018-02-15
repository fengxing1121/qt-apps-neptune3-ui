/****************************************************************************
**
** Copyright (C) 2017, 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
**
** $QT_BEGIN_LICENSE:GPL-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: GPL-3.0
**
****************************************************************************/
#ifndef CLIENT_H
#define CLIENT_H

#include <QObject>
#include <QSettings>
#include <QTimer>
#include "uisettingsdynamic.h"
#include "instrumentclusterdynamic.h"
#include "systemuidynamic.h"
#include "connectionmonitoringdynamic.h"

class QQmlContext;

Q_DECLARE_LOGGING_CATEGORY(remoteSettingsDynamicApp)

class Client : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl serverUrl READ serverUrl NOTIFY serverUrlChanged)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
    Q_PROPERTY(QStringList lastUrls READ lastUrls NOTIFY lastUrlsChanged)
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)

    static const QString settingsLastUrlsPrefix;
    static const QString settingsLastUrlsItem;
    static const int numOfUrlsStored;
    static const int timeoutToleranceMS;

public:
    static const QString defaultUrl;

    explicit Client(QObject *parent = nullptr);
    ~Client();

    void setContextProperties(QQmlContext *context);
    QUrl serverUrl() const;
    QString status() const;
    QStringList lastUrls() const;
    bool connected() const;

signals:
    void serverUrlChanged(const QUrl &url);
    void statusChanged(const QString &status);
    void lastUrlsChanged(const QStringList &lastUrls);
    void connectedChanged(bool connected);

public slots:
    void connectToServer(const QString &url);

protected slots:
    void onError(QRemoteObjectNode::ErrorCode code);
    void updateConnectionStatus();
    void onCMCounterChanged();
    void onCMTimeout();

private:
    void setStatus(const QString &status);
    void readSettings();
    void writeSettings();
    void updateLastUrls(const QString &url);

    QRemoteObjectNode *m_repNode;
    QUrl m_serverUrl;
    QStringList m_lastUrls;
    bool m_connected;
    bool m_timedOut;
    QString m_status;
    QSettings m_settings;

    UISettingsDynamic m_UISettings;
    InstrumentClusterDynamic m_instrumentCluster;
    SystemUIDynamic m_systemUI;
    ConnectionMonitoringDynamic m_connectionMonitoring;

    QTimer m_connectionMonitoringTimer;
};

#endif // CLIENT_H
