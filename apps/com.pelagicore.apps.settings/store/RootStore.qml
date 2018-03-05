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

import QtQml 2.2
import QtQml.Models 2.3
import utils 1.0
import com.pelagicore.settings 1.0

import "../helper"

QtObject {
    id: root


    readonly property UISettings uiSettings: UISettings {}

    // Time And Date Segment
    readonly property bool twentyFourHourTimeFormat: uiSettings.twentyFourHourTimeFormat !== undefined ?
                                                         uiSettings.twentyFourHourTimeFormat
                                                         // "ap" here indicates the presence of AM/PM suffix;
                                                         // Locale has no other way of telling whether it uses 12 or 24h time format
                                                       : Qt.locale().timeFormat(Locale.ShortFormat).indexOf("ap") === -1


    // Language Segment
    readonly property string currentLanguage: uiSettings.language ? uiSettings.language : Style.languageLocale
    readonly property ListModel languageModel: ListModel {}

    function populateLanguages() {
        languageModel.clear()
        var translations = uiSettings.languages.length !== 0 ? uiSettings.languages : Style.translation.availableTranslations;
        for (var i=0; i<translations.length; i++) {
            var locale = Qt.locale(translations[i]);
            languageModel.append({
                title: locale.nativeLanguageName,
                subtitle: locale.nativeCountryName,
                language: locale.name
            });
        }
    }

    function updateLanguage(language) {
        console.log(Helper.category, 'updateLanguage: ' + language)
        uiSettings.setLanguage(language);
    }

    function update24HourTimeFormat(value) {
        console.log(Helper.category, 'update24HourTimeFormat: ', value)
        uiSettings.setTwentyFourHourTimeFormat(value);
    }

    // Theme Segment
    readonly property int currentTheme: uiSettings.theme !== undefined ? uiSettings.theme : 0 // light

    readonly property ListModel themeModel: ListModel {
        // TODO: This data will be populated from settings server later
        // the server stores the "theme" as an integer
        ListElement { title: QT_TR_NOOP('Light'); theme: 'light' }
        ListElement { title: QT_TR_NOOP('Dark'); theme: 'dark' }
    }

    function updateTheme(value) {
        console.log(Helper.category, 'updateTheme: ', value)
        uiSettings.setTheme(value);
    }

    // Initialization
    Component.onCompleted: {
        populateLanguages();
    }
}
