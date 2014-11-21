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

Item
{
    id : rootId

    anchors.fill: parent

    function getUrl()
    {
        if (webViewId.item === null)
            return "";
        return webViewId.item.url
    }

    function setUrl(url)
    {
        if (webViewId.item !== null)
           webViewId.item.url = url
    }

    property alias webViewWidth     : webViewId.width
    property alias webViewHeight    : webViewId.height

    signal urlHasChanged();


    Rectangle
    {
        id          : progressBarContainerId

        color : "black"
        anchors
        {
            top     : parent.top
            right   : parent.right
            left    : parent.left
        }

        height  : 3


        Rectangle
        {
            id          : progressBarId


            width : webViewId.item === null ? 0 : parent.width * webViewId.item.loadProgress / 100

            color       : "red"
            anchors
            {
                top     : parent.top
                left    : parent.left
            }

            height  : 3
        }
    }

    Loader
    {
        id : webViewId

        anchors.top         : progressBarContainerId.bottom
        anchors.topMargin   : 1
        anchors.bottom      : parent.bottom
        anchors.left        : parent.left
        anchors.right       : parent.right

        Component.onCompleted:
        {
            if (Qt.platform.os === "osx")
            {
                source = "qrc:/WebApp/Views/WebView/WebView1.1.qml"
            }
            else
            {
                source = "qrc:/WebApp/Views/WebView/WebView3.0.qml"
            }
        }


    }
}

