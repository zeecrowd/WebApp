/*
** Copyright (c) 2014, Jabber Bees
** All rights reserved.
**
** Redistribution and use in source and binary forms, with or without modification,
** are permitted provided that the following conditions are met:
**
** 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
**
** 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer
** in the documentation and/or other materials provided with the distribution.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
** INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
** IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
** HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
** ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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

    property string mainUrl : ""

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
                web.url = mainUrl
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
            inputMessage.setFocus();
        }
    }

    Component.onCompleted:
    {
        inputMessage.setFocus();
    }

    Zc.CrowdActivity
    {
        id : activity


        onStarted :
        {
            mainView.mainUrl = mainView.context.applicationConfiguration.getProperty("HomeUrl","www.zeecrowd.com");
        }

        onContextChanged :
        {
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

            WebAppView
            {
                id : web
                anchors.fill: parent

                url : mainUrl
            }

            Layout.fillWidth : true
            Layout.fillHeight : true
        }

        Item
        {
            id : rightPanel

            width : mainView.width / 3

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
                senderChat.sendMessage(message)
            }
        }

    }

}



onLoaded :
{
    activity.start();
}

onClosed :
{
    activity.stop();
}
}
