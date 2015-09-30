/**
* Copyright (c) 2010-2014 "Jabber Bees"
*
* This file is part of the WebApp application for the Zeecrowd platform.
*
* Zeecrowd is an online collaboration platform [http://www.zeecrowd.com]
*
* WebApp is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import QtQuick.Controls 1.0
import ZcClient 1.0

Rectangle
{
    width: 600
    height: 480

    color : "lightgrey"

    id : mainViewWebApp

    signal validateUrl(string url);
    signal cancel()

    property alias homeUrl: homeUrl.text

    // Labels
    Column
    {
        id                  : columnLabelId
        width               : parent.width / 4
        anchors.top         : parent.top
        anchors.topMargin   : 60
        anchors.left        : parent.left
        spacing             : 5

        Label
        {
            font.pixelSize  : 24
            height:         30
            anchors.right   : columnLabelId.right
            color           : "white"
            text            : "URL "
        }
    }

    Button
    {
        id                  : okId

        anchors.top         : columnLabelId.top
        anchors.topMargin   : 0
        anchors.left        : columnValuesId.right
        anchors.leftMargin  : 20

        text                : "ok"

        onClicked   :
        {
          mainViewWebApp.validateUrl(mainViewWebApp.homeUrl)
        }

    }

    Button
    {
        id                  : cancelId

        anchors.top         : okId.bottom
        anchors.topMargin   : 10
        anchors.left        : okId.left

        text                : "Cancel"

        onClicked   :
        {
          mainViewWebApp.cancel();
        }

    }

    // Edits
    Column
    {
        id                  : columnValuesId
        anchors.top         : columnLabelId.top
        anchors.left        : columnLabelId.right
        anchors.leftMargin  : 10
        width               : 240
        spacing             : 5

        TextField
        {
            id                  : homeUrl

            height:         30
            font.pixelSize  : 24
            anchors.right       : parent.right
            anchors.left        : parent.left
            focus            : true
        }

    }
}
