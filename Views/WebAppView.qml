import QtQuick 2.0
import QtWebKit 3.0


Item
{
    id : rootId

    anchors.fill: parent

    property alias url              : webViewId.url
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


            width : parent.width * webViewId.loadProgress / 100

            color       : "red"
            anchors
            {
                top     : parent.top
                left    : parent.left
            }

            height  : 3
        }
    }

    WebView
    {
        id : webViewId

        anchors.top         : progressBarContainerId.bottom
        anchors.topMargin   : 1
        anchors.bottom      : parent.bottom
        anchors.left        : parent.left
        anchors.right       : parent.right
    }
}

