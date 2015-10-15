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
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0

import ZcClient 1.0 as Zc

import"./Delegates"

import "Main.js" as Presenter


Zc.AppView
{
    id : mainView

    width : 100
    height : 100

    property string mainUrl : ""
    property string useWebView : ""
    property Item webAppView: web

    property var _configuration : null

    anchors
    {
        top : parent.top
        left: parent.left
        leftMargin : 5
        bottom: parent.bottom
        right  : parent.right
    }

    toolBarActions :
        [
        Action {
            id: closeAction
            shortcut: "Ctrl+X"
            iconSource: "qrc:/WebApp/Resources/close.png"
            tooltip : "Close Application"
            onTriggered:
            {
                inputMessage.focus = false
                mainView.close();
            }
        }
        ,
        Action {
            id: homeAction
            shortcut: "Ctrl+X"
            iconSource: "qrc:/WebApp/Resources/home.png"
            tooltip : "Home url"
            onTriggered:
            {
                web.setUrl(mainUrl)
            }
        }
        ,
        Action {
            id: configAction
            shortcut: "Ctrl+X"
            //text: "Config"
            iconSource: context.affiliation >= 3 ? "qrc:/WebApp/Resources/crog.png" : ""
            tooltip : "Configuration"
            enabled : context.affiliation >= 3

            onTriggered:
            {
                if (mainView.application.configuration === undefined)
                {
                    _configuration = {};
                    _configuration.homeUrl = "http://www.zeecrowd.com";
                }
                else
                {
                    _configuration = mainView.application.configuration;
                }

               webApplicationConfiguration.homeUrl =_configuration.homeUrl
               webApplicationConfiguration.visible = true;
            }
        }
    ]

    Zc.AppNotification
    {
        id : appNotification
    }

    /*
    ** Clean all external notifications
    ** Set the focus
    */

    onIsCurrentViewChanged :
    {
        if (isCurrentView == true)
        {
            appNotification.resetNotification();
            web.showWebViewIfNecessary();

            if (Qt.platform.os !== "android")
                inputMessage.setFocus();
        }
        else
        {
            web.hideWebViewIfNecessary();
            if (Qt.platform.os === "android")
                inputMessage.focus = false
        }

    }

    Component.onCompleted:
    {
        if (Qt.platform.os !== "android")
                inputMessage.setFocus();


    }

    Zc.CrowdActivity
    {
        id : activity


        onStarted :
        {
            console.log(">> onStarted mainView.context " + mainView.context )
            console.log(">> onStarted mainView.context.applicationConfiguration " + mainView.context.applicationConfiguration )
            console.log(">> onStarted mainView.context.strApplicationConfiguration " + mainView.context.strApplicationConfiguration )

            mainView.mainUrl = mainView.context.applicationConfiguration.homeUrl;
            if (web.isInitialized)
                web.setUrl(mainView.mainUrl)


        }

        onContextChanged :
        {
            console.log(">> onContextChanged mainView.context " + mainView.context )
            console.log(">> onContextChanged mainView.context.applicationConfiguration " + mainView.context.applicationConfiguration )
            console.log(">> onContextChanged mainView.context.strApplicationConfiguration " + mainView.context.strApplicationConfiguration )

            mainView.mainUrl = mainView.context.applicationConfiguration.homeUrl;
            if (web.isInitialized)
                web.setUrl(mainView.mainUrl)

        }

        Zc.ChatMessageSender
        {
            id      : senderChat
            subject : "Main"
        }

        Zc.ChatMessageListener
        {
            id      : listenerChat
            subject : "*"

            allowGrouping : false

            onMessageChangedOrAdded :
            {
                appNotification.blink();
                //                if (!mainView.isCurrentView)
                //                {
                //                    appNotification.incrementNotification();
                //                }

                //                if ( tabView.getTab(tabView.currentIndex).title !== subject )
                //                {
                //                    if (Presenter.instance["notify" + subject] === undefined)
                //                    {
                //                        Presenter.instance["notify" + subject] = 0;
                //                    }

                //                    Presenter.instance["notify" + subject] ++;
                //                    notify(subject)
                //                }
            }
        }
    }


    SplitView
    {
        width : 100
        height : 100

        anchors.fill: parent
        orientation: Qt.Horizontal

        Component
        {
            id : handleDelegateDelegate
            Rectangle
            {
                width : 10
                color :  styleData.hovered ? "grey" :  "lightgrey"
            }
        }

        handleDelegate : handleDelegateDelegate

        Item
        {
             width : mainView.width * 2 / 3

            WebAppView
            {
                id : web

                width : 100
                height : 100
                anchors.fill: parent
            }

        }

        Item
        {
            id : rightPanel


            Layout.fillWidth : true
            Layout.fillHeight : true

            ScrollView
            {
                id : chatView

                Component.onCompleted:
                {
                    chatView.flickableItem.contentY = height
                }

                function goToEnd()
                {

                    var cy = chatView.flickableItem.contentY > 0 ? chatView.flickableItem.contentY : 0
                    var delta = chatView.flickableItem.contentHeight - (cy + chatView.flickableItem.height);

                    if (delta <= 30)
                    {
                        chatView.flickableItem.contentY = Math.round(column.height - chatView.flickableItem.height);
                    }

                }


                anchors.top: parent.top
                anchors.left : parent.left
                anchors.right: parent.right

                height: rightPanel.height - 65


                clip: true

                Column
                {
                    id : column


                    onHeightChanged :
                    {
                        chatView.goToEnd();
                    }

                    spacing: 5

                    Repeater
                    {
                        model : listenerChat.messages
                        ChatDelegate
                        {
                            width : chatView.flickableItem.width - 5

                            contactImageSource : activity.getParticipantImageUrl(from)
                        }
                    }
                }

        }

        InputMessageWidget
        {
            id : inputMessage
            height: 60;
            anchors.left : parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            onAccepted:
            {
                inputMessage.focus = false
                senderChat.sendMessage(message)
            }
        }

    }

}



onLoaded :
{
    activity.start();

    var webViewVersion =  mainView.context.getQtModuleVersion("QtWebView") !== "";
    var webKitVersion =  mainView.context.getQtModuleVersion("QtWebKit") !== "";
    mainView.useWebView = "WebView";

    if (Qt.platform.os === "windows")
    {
        mainView.useWebView = "WebKit"
    }
    else
    {
         mainView.useWebView = "WebView"
    }

        //if (webViewVersion)
        //    mainView.useWebView = "WebView"
        //else
        //    mainView.useWebView = "WebKit"
    //}
    //else
    //{
     //   if (webViewVersion)
      //  {
       //     mainView.useWebView = "WebView"
      //  }
      //  else if (webKitVersion)
        //    mainView.useWebView = "WebKit"
    //}

    web.initialize();
    web.setUrl(mainUrl)
}

onClosed :
{
    activity.stop();
}

WebApplicationConfiguration
{
    id : webApplicationConfiguration
    anchors.fill: parent
    visible : false

    onValidateUrl: {
        visible : false
        _configuration.homeUrl = url;

        mainView.context.updateConfiguration(_configuration);
        webApplicationConfiguration.visible = false

        mainView.mainUrl = url;
        web.setUrl(mainUrl);
    }

    onCancel: {
        webApplicationConfiguration.visible = false
        visible : false
    }

}

}
