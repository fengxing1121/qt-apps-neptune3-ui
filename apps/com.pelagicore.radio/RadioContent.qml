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
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2

import controls 1.0
import utils 1.0
import "stores"

import com.pelagicore.styles.neptune 3.0

Item {
    id: root

    property RadioStore store

    Connections {
        target: root.store

        onCurrentStationIndexChanged: {
            stationsGrid.currentIndex = root.store.currentStationIndex;
        }

        onCurrentFrequencyChanged: {
            if (!slider.dragging) {
                stationInfo.tuningMode = false
            }
        }
    }

    ColumnLayout {
        id: stationControl
        width: root.width
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Style.vspan(2)

        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter

            ToolButton {
                Layout.preferredWidth: Style.hspan(1)
                Layout.preferredHeight: Style.vspan(1)
                icon.name: "ic_skipprevious"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: root.store.prevStation()
                onPressAndHold: root.store.scanBack()
            }

            Label {
                Layout.preferredWidth: Style.hspan(5)
                text: root.store.currentFreqPreset
                font.pixelSize: NeptuneStyle.fontSizeXXL
                horizontalAlignment: Text.AlignHCenter
            }

            StationInfo {
                id: stationInfo
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: Style.vspan(0.25)
                title: root.store.currentStationName
                numberOfDecimals: root.store.freqPresets === 2 ? 0 : 1
                frequency: stationInfo.tuningMode ? slider.value : root.store.currentFrequency
            }

            Label {
                Layout.preferredWidth: Style.hspan(5)
                text: root.store.freqUnit
                font.pixelSize: NeptuneStyle.fontSizeXXL
                horizontalAlignment: Text.AlignHCenter
            }

            ToolButton {
                Layout.preferredWidth: Style.hspan(1)
                Layout.preferredHeight: Style.vspan(1)
                icon.name: "ic_skipnext"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: root.store.nextStation()
                onPressAndHold: root.store.scanForward()
            }
        }

        TunerSlider {
            id: slider

            Layout.preferredWidth: Style.hspan(20)
            Layout.preferredHeight: Style.vspan(1)
            anchors.horizontalCenter: parent.horizontalCenter

            readonly property real minFrequency: root.store.minimumFrequency
            readonly property real maxFrequency: root.store.maximumFrequency

            value: root.store.currentFrequency
            minimum: minFrequency
            maximum: maxFrequency
            useAnimation: true
            numberOfDecimals: root.store.freqPresets === 2 ? 0 : 1

            onActiveValueChanged: value = activeValue

            onDraggingChanged: {
                if (dragging) {
                    stationInfo.tuningMode = true
                } else {
                    stationInfo.tuningMode = false
                    root.store.setFrequency(value)
                }
            }
        }
    }
    ToolsColumn {
        id: toolsColumn
        width: NeptuneStyle.dp(264)
        anchors.left: parent.left
        anchors.top: stationControl.bottom
        anchors.topMargin: NeptuneStyle.dp(2)
        model: store.toolsColumnModel
        onClicked: {
            if (currentText === "music") {
                Qt.openUrlExternally("x-music://");
            } else if (currentText === "web radio") {
                Qt.openUrlExternally("x-webradio://");
            } else if (currentText === "spotify") {
                Qt.openUrlExternally("x-spotify://");
            }
        }
    }

    GridView {
        id: freqPresetsGrid

        width: root.width * 0.6
        height: Style.vspan(2.5)
        anchors.top: stationControl.bottom
        anchors.topMargin: Style.vspan(2)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: toolsColumn.width / 3

        model: root.store.freqPresetsModel
        cellWidth: Style.hspan(4.8); cellHeight: Style.hspan(2.2)
        currentIndex: 0

        delegate: DelegatedGrid {
            width: Style.hspan(4.65)
            height: Style.hspan(2)
            text: name
            checked: index === freqPresetsGrid.currentIndex
            onClicked: {
                freqPresetsGrid.currentIndex = index;
                root.store.freqPresets = index;
            }
        }
    }

    GridView {
        id: stationsGrid
        width: root.width * 0.8
        height: Style.vspan(5)
        anchors.top: freqPresetsGrid.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: toolsColumn.width / 3

        cellWidth: Style.hspan(4.8); cellHeight: cellWidth
        interactive: false
        highlightFollowsCurrentItem: false
        currentIndex: 0
        onCurrentIndexChanged: {
            root.store.setFrequency(stationsGrid.currentItem.frequency);
        }

        model: root.store.currentPresetModel

        delegate: DelegatedGrid {
            width: Style.hspan(4.65)
            height: Style.hspan(4)
            readonly property real frequency: freq
            readonly property int numberOfDecimals: root.store.freqPresets === 2 ? 0 : 1
            text: frequency.toLocaleString(Qt.locale(), 'f', numberOfDecimals)
            checked: index === stationsGrid.currentIndex
            onClicked: {
                stationsGrid.currentIndex = index;
                root.store.currentStationIndex = index;
            }
        }
    }
}
