/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import controls 1.0
import utils 1.0

Item {
    id: root
    anchors.horizontalCenter: parent ? parent.horizontalCenter : null
    anchors.top: parent ? parent.top : null
    anchors.topMargin: Style.vspan(0.5)
    anchors.bottom: parent ? parent.bottom : null

    Flickable {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: Style.hspan(17)
        contentHeight: columnContent.height
        contentWidth: columnContent.width
        flickableDirection: Flickable.VerticalFlick
        clip: true
        ColumnLayout {
            id: columnContent
            spacing: Style.vspan(0.05)

            ListItem {
                implicitWidth: Style.hspan(17)
                implicitHeight: Style.vspan(1.3)
                text: "Basic ListItem"
                dividerVisible: false
            }

            ListItem {
                implicitWidth: Style.hspan(17)
                implicitHeight: Style.vspan(1.3)
                text: "ListItem Text"
                subText: "ListItem Subtext"
            }

            ListItem {
                implicitWidth: Style.hspan(17)
                implicitHeight: Style.vspan(1.3)
                text: "ListItem with an image"
                imageSource: Style.gfx("fan-speed-5")
            }

            ListItem {
                implicitWidth: Style.hspan(17)
                implicitHeight: Style.vspan(1.3)
                symbol: Style.symbol("ic-update")
                text: "ListItem with Icon"
            }

            ListItem {
                implicitWidth: Style.hspan(17)
                implicitHeight: Style.vspan(1.3)
                symbol: Style.symbol("ic-update")
                text: "ListItem with Secondary Text"
                secondaryText: "Company"
            }

            ListItem {
                implicitWidth: Style.hspan(17)
                implicitHeight: Style.vspan(1.3)
                symbol: Style.symbol("ic-update")
                rightToolSymbol: Style.symbol("ic-close")
                text: "ListItem with Secondary Text"
                secondaryText: "68% of 14 MB"
            }

            ListItem {
                implicitWidth: Style.hspan(17)
                implicitHeight: Style.vspan(1.3)
                symbol: Style.symbol("ic-update")
                rightToolSymbol: Style.symbol("ic-close")
                text: "ListItem with Looooooooooonnngggg Text"
                secondaryText: "Loooooooong Secondary Text"
            }

            ListItemProgress {
                id: listItemProgress
                implicitWidth: Style.hspan(17)
                implicitHeight: Style.vspan(1.3)
                minimumValue: 0
                maximumValue: 100
                symbol: Style.symbol("ic-placeholder")
                text: "Downloading application"
                secondaryText: value + " % of 46 MB"
                cancelable: timerDowloading.running
                value: 0
                onProgressCanceled: {
                    timerDowloading.stop()
                    value = 0
                }
                onClicked: {
                    timerDowloading.start()
                }

                Timer {
                    id: timerDowloading
                    interval: 1000
                    repeat: true
                    running: true
                    onTriggered: {
                        if (listItemProgress.value === listItemProgress.maximumValue) {
                            listItemProgress.value = 0
                        } else {
                            listItemProgress.value += 5
                        }
                    }
                }
            }
            ListItemProgress {
                id: listItemProgressIndeterminate
                implicitWidth: Style.hspan(17)
                implicitHeight: Style.vspan(1.3)
                indeterminate: true
                symbol: Style.symbol("ic-placeholder")
                cancelable: indeterminate
                text: indeterminate ? "Downloading pending" : "Downloading canceled"
                onProgressCanceled: indeterminate = false
                onClicked: indeterminate = true
            }

            ListItemSwitch {
                id: listItemSwitch
                implicitWidth: Style.hspan(17)
                implicitHeight: Style.vspan(1.3)
                symbol: Style.symbol("ic-placeholder")
                text: "List item with a switch " + (listItemSwitch.switchOn ? "(ON)" : "(OFF)")
                onSwitchClicked: console.log("Switch is clicked")
                onSwitchToggled: console.log("Switch is toggled")
            }

            ListItemTwoButtons {
                id: listItemTwoButtons
                implicitWidth: Style.hspan(17)
                implicitHeight: Style.vspan(1.3)
                symbol: Style.symbol("ic-placeholder")
                text: "List item with two accessory buttons"
                symbolAccessoryButton1: Style.symbol("ic-call-contrast")
                symbolAccessoryButton2: Style.symbol("ic-message-contrast")
                onAccessoryButton1Clicked: listItemTwoButtons.text = "Call clicked"
                onAccessoryButton2Clicked: listItemTwoButtons.text = "Message clicked"
                onClicked: listItemTwoButtons.text = "List item with two accessory buttons"
            }
        }
    }
}

