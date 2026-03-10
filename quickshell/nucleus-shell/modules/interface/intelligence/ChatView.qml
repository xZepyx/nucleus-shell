import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.config
import qs.modules.components
import qs.modules.functions

StyledRect {
    id: root

    property var messageModel

    Layout.fillWidth: true
    Layout.fillHeight: true

    radius: Metrics.radius("normal")
    color: Appearance.m3colors.m3surfaceContainerLow

    function scrollToBottom() {
        if (chatList)
            chatList.positionViewAtEnd()
    }

    ScrollView {
        anchors.fill: parent
        clip: true

        ListView {
            id: chatList

            anchors.fill: parent
            anchors.margins: Metrics.margin(12)

            model: root.messageModel
            spacing: Metrics.spacing(8)
            clip: true

            delegate: Item {
                width: chatList.width
                height: bubble.implicitHeight + 6

                Item {
                    anchors.fill: parent

                    StyledRect {
                        id: bubble

                        radius: Metrics.radius("normal")

                        color: sender === "You"
                               ? Appearance.m3colors.m3primaryContainer
                               : Appearance.m3colors.m3surfaceContainerHigh

                        anchors {
                            right: sender === "You" ? parent.right : undefined
                            left: sender === "AI" ? parent.left : undefined
                            top: parent.top
                        }

                        width: Math.min(textItem.implicitWidth + 20, chatList.width * 0.8)
                        implicitHeight: textItem.implicitHeight + 16

                        TextEdit {
                            id: textItem

                            text: StringUtils.markdownToHtml(message)
                            wrapMode: TextEdit.Wrap
                            textFormat: TextEdit.RichText
                            readOnly: true

                            color: "white"
                            font.pixelSize: Metrics.fontSize(16)

                            anchors.fill: parent
                            padding: Metrics.padding(8)
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.RightButton

                            onClicked: {
                                let p = Qt.createQmlObject(
                                    'import Quickshell; import Quickshell.Io; Process { command: ["wl-copy", "' + message + '"] }',
                                    parent
                                )
                                p.running = true
                            }
                        }
                    }
                }
            }
        }
    }
}