/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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

import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.calendar 1.0
import animations 1.0
import controls 1.0
import utils 1.0
import "stores"

import com.pelagicore.styles.neptune 3.0

Item {
    id: root

    property CalendarStore store
    property bool bottomWidgetHide: false

    Component.onCompleted: {
        var d = new Date();
        grid.month = d.getMonth();
        grid.year = d.getFullYear();
    }

    CalendarWidgetContent {
        anchors.fill: parent
        state: root.state
        visible: root.state !== "Maximized"
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { } }

        // Generate random number to get contents from calendar model.
        property int randomIndex: Math.floor((Math.random() * root.store.eventModel.count) + 0)

        eventModel: root.store.eventModel
    }

    Image {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: calendarOnTop.height + calendarOnTop.anchors.topMargin + mainControl.anchors.topMargin
        source: Style.gfx2("app-fullscreen-top-bg", NeptuneStyle.theme)
        visible: root.state == "Maximized"
    }

    RowLayout {
        id: calendarOnTop
        anchors.top: parent.top
        anchors.topMargin: Style.vspan(1)
        anchors.left: parent.left
        anchors.leftMargin: Style.hspan(3)
        visible: root.state === "Maximized"
        spacing: Style.hspan(3)
        ColumnLayout {
            DayOfWeekRow {
                locale: grid.locale
                Layout.fillWidth: true
                delegate: Text {
                    text: model.shortName
                    font.pixelSize: NeptuneStyle.fontSizeXS
                    font.family: NeptuneStyle.fontFamily
                    color: NeptuneStyle.primaryTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

            }
            MonthGrid {
                id: grid

                property color labelColor: NeptuneStyle.primaryTextColor

                locale: Qt.locale(Style.languageLocale)
                Layout.fillWidth: true
                delegate: Label {
                    text: model.day
                    color: grid.labelColor
                    font.pixelSize: NeptuneStyle.fontSizeXS
                    font.family: NeptuneStyle.fontFamily
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    opacity: model.month === grid.month ? 1 : 0
                }
            }
            Image {
                source: Style.gfx2("album-art-shadow-widget")
            }
        }

        RowLayout {
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: - Style.vspan(0.5)
            Tool {
                anchors.verticalCenter: parent.verticalCenter
                symbol: Style.symbol("ic_skipprevious")
                onClicked: {
                    if (grid.month === 0) {
                        grid.month = 11;
                        grid.year -= 1;
                    } else {
                        grid.month -= 1
                    }
                }
            }
            Label {
                Layout.preferredWidth: Style.hspan(6)
                text: Qt.locale().standaloneMonthName(grid.month) + " " + grid.year
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Style.fontSizeM
                font.weight: Font.Light
            }
            Tool {
                anchors.verticalCenter: parent.verticalCenter
                symbol: Style.symbol("ic_skipnext")
                onClicked: {
                    if (grid.month === 11) {
                        grid.month = 0;
                        grid.year += 1;
                    } else {
                        grid.month += 1
                    }
                }
            }
        }
    }

    Control {
        id: mainControl
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: calendarOnTop.bottom
        anchors.topMargin: Style.vspan(0.8)
        anchors.bottom: root.bottom
        visible: root.state === "Maximized"

        contentItem: Row {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: Style.hspan(2)
            anchors.leftMargin: Style.hspan(1)
            anchors.rightMargin: Style.hspan(2)
            spacing: Style.hspan(1.5)
            ToolsColumn {
                id: toolsColumn
                height: Style.vspan(4)
                translationContext: "CalendarToolsColumn"
                model: ListModel {
                    id: toolsColumnModel
                    ListElement { icon: "ic-calendar"; text: QT_TRANSLATE_NOOP("CalendarToolsColumn", "year") }
                    ListElement { icon: "ic-calendar"; text: QT_TRANSLATE_NOOP("CalendarToolsColumn", "next") }
                    ListElement { icon: "ic-calendar"; text: QT_TRANSLATE_NOOP("CalendarToolsColumn", "events") }
                }
            }

            Loader {
                id: contentLoader
                width: Style.hspan(15)
                height: parent.height
                Behavior on height { DefaultNumberAnimation { } }
                sourceComponent: {
                    switch (toolsColumn.currentText) {
                        case "year": return year;
                        case "next": return next;
                        case "events": return events;
                    }
                }
            }
        }
    }

    Component {
        id: year
        CalendarGrid { }
    }

    Component {
        id: next
        NextCalendar {
            eventModel: root.store.eventModel
        }
    }

    Component {
        id: events
        EventListView {
            model: root.store.eventModel
        }
    }
}
