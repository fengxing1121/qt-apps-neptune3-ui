/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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

import QtQuick 2.10
import QtQuick.Templates 2.3 as T
import QtQuick.Controls 2.3
import QtQuick.Controls.impl 2.3
import com.pelagicore.styles.neptune 3.0

T.ItemDelegate {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    spacing: NeptuneStyle.dp(12)
    padding: NeptuneStyle.dp(12)

    topPadding: padding - NeptuneStyle.dp(1)
    bottomPadding: padding + NeptuneStyle.dp(1)

    font.pixelSize: NeptuneStyle.fontSizeM
    font.family: NeptuneStyle.fontFamily
    font.weight: Font.Light

    contentItem: NeptuneIconLabel {
        iconScale: NeptuneStyle.scale

        leftPadding: !control.mirrored ? (control.indicator ? control.indicator.width + control.spacing : 0) : 0
        rightPadding: control.mirrored ? (control.indicator ? control.indicator.width + control.spacing : 0) : 0

        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: control.display === IconLabel.IconOnly || control.display === IconLabel.TextUnderIcon ? Qt.AlignCenter : Qt.AlignLeft

        icon: control.icon
        text: control.text
        font: control.font
        opacity: enabled ? NeptuneStyle.fontOpacityHigh : NeptuneStyle.fontOpacityDisabled
        color: enabled ? NeptuneStyle.contrastColor : NeptuneStyle.disabledTextColor
    }
}
