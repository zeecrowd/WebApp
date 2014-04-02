import QtQuick 2.0
import QtQuick.Controls 1.0
import ZcClient 1.0

ZcAppConfigurationView
{
    width: 600
    height: 480

    id : mainView

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
            mainView.dataFormConfiguration.setFieldValue("HomeUrl",homeUrl.text);
            mainView.ok();
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

    onLoaded :
    {
        homeUrl.text = mainView.dataFormConfiguration.getFieldValue("HomeUrl","")
    }
}
