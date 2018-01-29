/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AB
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
import QtQuick 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.9
import Qt3D.Extras 2.9
import Qt3D.Input 2.0
import QtQuick.Scene3D 2.0

import animations 1.0

Entity {
    id: root
    Transform {
        id: transform
        property real userAngle: root.open ? -55 : 0
        Behavior on userAngle { DefaultNumberAnimation { duration: 1000 } }
        matrix: {
            var m = Qt.matrix4x4();
            var xOffset = 14.8;
            var yOffset = 11.38;
            var zOffset = 12.20;
            m.scale(vehicle3DView.scaleFactor);
            m.translate( Qt.vector3d(-xOffset, yOffset, zOffset))
            m.rotate(userAngle, Qt.vector3d(0, -1, 0))
            m.translate( Qt.vector3d(xOffset, -yOffset, -zOffset))
            return m;
        }
    }

    property bool open: false

    Entity {
        Mesh {
            id: mesh
            meshName: "^silver_paint_2$"
            source: vehicle3DView.carObjFilePath
        }
        components: [transform, mesh, whiteHood]
    }

    Entity {
        Mesh {
            id: mesh2
            meshName: "^silver_paint_3$"
            source: vehicle3DView.carObjFilePath
        }
        components: [mesh2, whiteHood, transform]
    }

    Entity {
        Mesh {
            id: glass
            meshName: "^glass_2$"
            source: vehicle3DView.carObjFilePath
        }
        components: [glass, glassMaterial, transform]
    }

    Entity {
        Mesh {
            id: chrome
            meshName: "^chrome_3$"
            source: vehicle3DView.carObjFilePath
        }
        components: [chrome, chromeMaterial, transform]
    }

    Entity {
        Mesh {
            id: chrome1
            meshName: "^chrome_4$"
            source: vehicle3DView.carObjFilePath
        }
        components: [chrome1, chromeMaterial, transform]
    }

    Entity {
        Mesh {
            id: black
            meshName: "^black_2$"
            source: vehicle3DView.carObjFilePath
        }
        components: [black, blackMaterial, transform]
    }

    Entity {
        Mesh {
            id: black1
            meshName: "^black_3$"
            source: vehicle3DView.carObjFilePath
        }
        components: [black1, blackMaterial, transform]
    }
}
