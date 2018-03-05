/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AB
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
import QtQuick 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.9
import Qt3D.Extras 2.9
import Qt3D.Input 2.0
import QtQuick.Scene3D 2.0

import animations 1.0

Entity {
    id: root

    property bool open: false

    Transform {
        id: transform
        property real userAngle: root.open ? 30 : 0
        Behavior on userAngle { DefaultNumberAnimation { duration: 1000 } }
        matrix: {
            var m = Qt.matrix4x4();
            var yOffset = 21;
            var zOffset = 18;
            m.scale(vehicle3DView.scaleFactor);
            m.translate( Qt.vector3d(0, yOffset, -zOffset));
            m.rotate(userAngle, Qt.vector3d(1, 0, 0));
            m.translate( Qt.vector3d(0, -yOffset, zOffset));
            return m;
        }
    }

    Mesh {
        id: rearDoorMesh
        source: "assets/models/back_window.stl"
    }

    components: [transform, rearDoorMesh, glassMaterial]
}
