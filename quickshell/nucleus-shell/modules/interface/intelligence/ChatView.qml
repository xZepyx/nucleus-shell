import QtQuick
import QtQuick.Controls
import qs.modules.components

StyledRect {
    property var messageModel

    radius: Metrics.radius("normal")
    color: Appearance.m3colors.m3surfaceContainerLow

    ScrollView {
        anchors.fill: parent

        ListView {
            id: chatView
            anchors.fill: parent

            model: messageModel
            spacing: Metrics.spacing(8)

            function scrollToBottom() {
                forceLayout()
                positionViewAtEnd()
            }

            delegate: Item {
                width: chatView.width
                height: bubble.implicitHeight + 6

                Row {

                    StyledRect {
                        id: bubble

                        radius: Metrics.radius("normal")
                        color: sender === "You"
                               ? Appearance.m3colors.m3primaryContainer
                               : Appearance.m3colors.m3surfaceContainerHigh

                        implicitWidth: Math.min(textItem.implicitWidth+20, chatView.width*0.8)

                        TextEdit {
                            id: textItem
                            text: StringUtils.markdownToHtml(message)

                            wrapMode: TextEdit.Wrap
                            readOnly: true
                            textFormat: TextEdit.RichText

                            padding: Metrics.padding(8)
                        }
                    }
                }
            }
        }
    }
}
