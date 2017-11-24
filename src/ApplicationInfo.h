/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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
#pragma once

#include <QObject>
#include <QQuickItem>

/*
   A wrapper for AppMan Application that adds some more goodies

   Maybe some of those extra bits could be put into Application itself to reduce or even
   eliminate the need for this wrapper.
 */
class ApplicationInfo : public QObject {
    Q_OBJECT

    // whether the application is active (on foreground / fullscreen)
    // false means it's either invisible, minimized, reduced to a widget geometry
    // or might not even be running at all
    Q_PROPERTY(bool active READ active NOTIFY activeChanged)

    // If false, Application.activated signals won't cause the application to be the active one
    // TODO: try to get rid of this (ie, find a better solution)
    Q_PROPERTY(bool canBeActive READ canBeActive WRITE setCanBeActive NOTIFY canBeActiveChanged)

    //  the main window of this application, if any
    Q_PROPERTY(QQuickItem* window READ window() NOTIFY windowChanged)

    // State of the main window of this application
    //
    // Its value is derived from other properties in this class like active,
    // heightRows, asWidget and window.
    //
    // See also: window
    Q_PROPERTY(WindowState windowState READ windowState NOTIFY windowStateChanged)

    // Whether the application window should be shown as a widget
    Q_PROPERTY(bool asWidget READ asWidget WRITE setAsWidget NOTIFY asWidgetChanged)

    // Widget geometry. Ignored if asWidget === false
    Q_PROPERTY(int heightRows READ heightRows WRITE setHeightRows NOTIFY heightRowsChanged)
    Q_PROPERTY(int minHeightRows READ minHeightRows WRITE setMinHeightRows NOTIFY minHeightRowsChanged)

    // The QtAM::Application object
    Q_PROPERTY(const QObject* application READ application CONSTANT)
    Q_PROPERTY(QString id READ id CONSTANT)

    /*
        The bottom margin of the exposed rectangular are of the apps main window

        The area of the apps main window that is directly visible to the user (ie, exposed) and not occluded
        obstructed by other items in the system ui is defined by a rectangle anchored ti all window's edges
        Its bottom margin is defined by this property
     */
    Q_PROPERTY(qreal exposedRectBottomMargin READ exposedRectBottomMargin WRITE setExposedRectBottomMargin
                                             NOTIFY exposedRectBottomMarginChanged)

public:
    enum WindowState {
        Undefined,
        Widget1Row,
        Widget2Rows,
        Widget3Rows,
        Maximized
    };
    Q_ENUM(WindowState);


    ApplicationInfo(const QObject* application, QObject *parent = nullptr);

    // starts the application. Same as ApplicatioManager.startApplication() but in a object oriented fashion
    Q_INVOKABLE void start();

    void setAsWidget(bool);
    bool asWidget() const;

    void setWindow(QQuickItem *);
    QQuickItem *window() const;

    WindowState windowState() const;

    const QObject *application() const;

    int heightRows() const;
    void setHeightRows(int);

    int minHeightRows() const;
    void setMinHeightRows(int);

    bool active() const;
    void setActive(bool);

    bool canBeActive() const;
    void setCanBeActive(bool);

    QString id() const;

    qreal exposedRectBottomMargin() const;
    void setExposedRectBottomMargin(qreal);

signals:
    void activeChanged();
    void canBeActiveChanged();
    void windowChanged();
    void asWidgetChanged();
    void heightRowsChanged();
    void minHeightRowsChanged();
    void startRequested();
    void windowStateChanged();
    void exposedRectBottomMarginChanged();

private:
    void updateWindowState();

    bool m_active{false};
    bool m_canBeActive{true};
    QQuickItem *m_window{nullptr};
    WindowState m_windowState{Undefined};
    bool m_asWidget{false};
    int m_heightRows{1};
    int m_minHeightRows{1};
    const QObject *m_application{nullptr};
    qreal m_exposedRectBottomMargin{0};
};

Q_DECLARE_METATYPE(ApplicationInfo*)
