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
#include "client.h"
#include <QQmlContext>

Q_LOGGING_CATEGORY(remoteSettingsDynamicApp, "remotesettings.dynamicApp")

const QString Client::settingsLastUrlsPrefix = "lastUrls";
const QString Client::settingsLastUrlsItem = "url";
const int Client::numOfUrlsStored = 5;
const QString Client::defaultUrl = "tcp://127.0.0.1:9999";

Client::Client(QObject *parent) : QObject(parent),
    m_repNode(nullptr),
    m_settings("Pelagicore", "TritonControlApp")
{
    setStatus(tr("Not connected"));
    connect(&m_UISettings, &UISettingsDynamic::connectedChanged,
            this, &Client::onReplicaConnectionChanged);
    connect(&m_instrumentCluster, &UISettingsDynamic::connectedChanged,
            this, &Client::onReplicaConnectionChanged);
    readSettings();
}

Client::~Client()
{
    delete m_repNode;
}

void Client::setContextProperties(QQmlContext *context)
{
    context->setContextProperty(QStringLiteral("uiSettings"), &m_UISettings);
    context->setContextProperty(QStringLiteral("instrumentCluster"), &m_instrumentCluster);
}

QUrl Client::serverUrl() const
{
    return m_serverUrl;
}

QString Client::status() const
{
    return m_status;
}

QStringList Client::lastUrls() const
{
    if (m_lastUrls.isEmpty())
        return {defaultUrl};
    return m_lastUrls;
}

void Client::connectToServer(const QString &serverUrl)
{
    QUrl url(serverUrl);
    if (!url.isValid()) {
        setStatus(tr("Invalid URL: %1").arg(url.toString()));
        return;
    }

    if (url==m_serverUrl)
        return;

    if (m_repNode)
        QObject::disconnect(m_repNode, &QRemoteObjectNode::error, this, &Client::onError);

    delete m_repNode;

    m_repNode = new QRemoteObjectNode();
    connect(m_repNode, &QRemoteObjectNode::error, this, &Client::onError);

    if (m_repNode->connectToNode(url)) {
        m_UISettings.resetReplica(m_repNode->acquireDynamic("settings.UISettings"));
        m_instrumentCluster.resetReplica(m_repNode->acquireDynamic("settings.InstrumentCluster"));
        setStatus(tr("Connecting to %1...").arg(url.toString()));
        updateLastUrls(url.toString());
    } else {
        setStatus(tr("Connection to %1 failed").arg(url.toString()));
        m_UISettings.resetReplica(nullptr);
        m_instrumentCluster.resetReplica(nullptr);
    }

    if (m_serverUrl!=url) {
        m_serverUrl=url;
        emit serverUrlChanged(m_serverUrl);
    }
}

void Client::onError(QRemoteObjectNode::ErrorCode code)
{
    qCWarning(remoteSettingsDynamicApp) << "Remote objects error, code:" << code;
}

void Client::onReplicaConnectionChanged(bool connected)
{
    Q_UNUSED(connected)
    if (m_UISettings.connected() || m_instrumentCluster.connected())
        setStatus(tr("Connected to %1").arg(serverUrl().toString()));
    else
        setStatus(tr("Disconnected"));
}

void Client::setStatus(const QString &status)
{
    if (status==m_status)
        return;
    m_status=status;
    qCWarning(remoteSettingsDynamicApp) << "Client status: " << status;
    emit statusChanged(m_status);
}

void Client::readSettings()
{
    int size=m_settings.beginReadArray("lastUrls");
    for (int i=0; i<size;i++) {
        m_settings.setArrayIndex(i);
        m_lastUrls.append(m_settings.value("url").toString());
    }
    m_settings.endArray();
    emit lastUrlsChanged(m_lastUrls);
}

void Client::writeSettings()
{
    m_settings.beginWriteArray("lastUrls");
    for (int i=0; i<m_lastUrls.size();i++) {
        m_settings.setArrayIndex(i);
        m_settings.setValue("url",m_lastUrls.at(i));
    }
    m_settings.endArray();
}

void Client::updateLastUrls(const QString &url)
{
    m_lastUrls.removeOne(url);
    m_lastUrls.push_front(url);
    while (m_lastUrls.size()>numOfUrlsStored)
        m_lastUrls.pop_back();
    writeSettings();
    emit lastUrlsChanged(m_lastUrls);
}
