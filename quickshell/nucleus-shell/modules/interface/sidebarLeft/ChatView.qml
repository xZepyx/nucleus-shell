import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.config
import qs.modules.components
import qs.modules.functions

StyledRect {
    id: root

    property var model

    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: Metrics.radius("normal")
    color: Appearance.m3colors.m3surfaceContainerLow

    function scrollToBottom() {
        chatView.positionViewAtEnd()
    }

    ScrollView {
        anchors.fill: parent
        clip: true

        ListView {
            id: chatView

            model: root.model
            spacing: Metrics.spacing(8)
            anchors.fill: parent
            anchors.margins: Metrics.margin(12)
            clip: true

            delegate: Item {
                property bool isCodeBlock: message.split("\n").length > 2 && message.includes("import ")

                width: chatView.width
                height: bubble.implicitHeight + 6

                Row {
                    width: parent.width
                    spacing: Metrics.spacing(8)

                    Item {
                        width: sender === "AI" ? 0 : parent.width * 0.2
                    }

                    StyledRect {
                        id: bubble

                        radius: Metrics.radius("normal")
                        color: sender === "You"
                               ? Appearance.m3colors.m3primaryContainer
                               : Appearance.m3colors.m3surfaceContainerHigh

                        implicitWidth: Math.min(textItem.implicitWidth + 20, chatView.width * 0.8)
                        implicitHeight: textItem.implicitHeight

                        anchors.right: sender === "You" ? parent.right : undefined
                        anchors.left: sender === "AI" ? parent.left : undefined
                        anchors.topMargin: Metrics.margin(2)

                        TextEdit {
                            id: textItem

                            text: StringUtils.markdownToHtml(message)
                            wrapMode: TextEdit.Wrap
                            textFormat: TextEdit.RichText
                            readOnly: true
                            font.pixelSize: Metrics.fontSize(16)

                            color: "white"

                            anchors.fill: parent
                            anchors.leftMargin: Metrics.margin(12)
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

                    Item {
                        width: sender === "You" ? 0 : parent.width * 0.2
                    }
                }
            }
        }
    }
}
