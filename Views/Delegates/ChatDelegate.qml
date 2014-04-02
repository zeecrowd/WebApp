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

import ZcClient 1.0 as Zc

import "../Tools.js" as Tools


Rectangle
{
    id : chatDelegate

    property alias contactImageSource : contactImage.source

    height : 50
    width : parent.width

    color : "white"

    /*
    ** Contact Image
    ** default contact image set
    */
    Image
    {
        id : contactImage

        width  : 50
        height : width

        anchors
        {
            top        : parent.top
            topMargin  : 2
            left       : parent.left
            leftMargin : 2
        }

        onStatusChanged:
        {
            if (status === Image.Error)
            {
                source = "qrc:/Crowd.Core/Qml/Ressources/Pictures/DefaultUser.png"
            }
        }
    }

    Item
    {
        id : textZone

        anchors.top : parent.top
        anchors.left : contactImage.right
        anchors.leftMargin : 5


        height : 50
        width : parent.width - 60


        property string url : ""


        function updateDelegate()
        {
            var o = Tools.parseDatas(body);

            textEdit.text = o.text;

            textZone.url = o.viewUrl;


            var ligneHeight =  textEdit.lineCount * 17

            var finalHeight = 28 + ligneHeight;

            if (finalHeight < 70 )
                finalHeight = 70;

            textZone.height = finalHeight;
            chatDelegate.height = finalHeight;
        }


        Component.onCompleted:
        {
            updateDelegate();
            chatView.goToEnd()
        }



        Label
        {
            id                      : fromId
            text                    : from
            color                   : "black"
            font.pixelSize          : appStyleId.baseTextHeigth
            anchors
            {
                top             : parent.top
                topMargin       : 2
                left            : parent.left
                leftMargin      : 5
            }

            maximumLineCount        : 1
            font.bold               : true
            elide                   : Text.ElideRight
            wrapMode                : Text.WrapAnywhere
        }


        Label
        {
            id                      : timeStampId
            text                    : timeStamp
            font.pixelSize          : 10
            font.italic 			: true
            anchors
            {
                top             : parent.top
                horizontalCenter: parent.horizontalCenter
            }
            maximumLineCount        : 1
            elide                   : Text.ElideRight
            wrapMode                : Text.WrapAnywhere
            color                   : "gray"
        }


        Item
        {

            clip : true

            anchors
            {
                top        : fromId.bottom
                left       : parent.left
                leftMargin : 25
                right      : parent.right
                rightMargin: 45
                bottom     : parent.bottom
            }

            TextEdit
            {
                id  : textEdit
                color : "black"

                textFormat: Text.RichText

                anchors
                {
                    top         : parent.top
                    left        : parent.left
                    leftMargin  : 5
                    right       : parent.right
                    bottom      : parent.bottom
                }

                readOnly                : true
                selectByMouse           : true
                font.pixelSize          : 14
                wrapMode                : TextEdit.WrapAtWordBoundaryOrAnywhere

            }

        }

        Label
        {
            height : 20
            width : 100
            anchors.bottom: parent.bottom
            anchors.left: textZone.right
            anchors.leftMargin: - 30
            text : "<a href=\" \">view</a>"

            onLinkActivated:
            {
                web.url = textZone.url
            }
        }



    }
}
