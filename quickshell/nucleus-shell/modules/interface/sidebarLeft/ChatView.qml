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
            spacing: Metrics.spacing(10)
            anchors.fill: parent
            anchors.margins: Metrics.margin(12)
            clip: true

            delegate: Item {
                width: chatView.width
                height: bubble.implicitHeight + Metrics.margin(4)

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

                    width: Math.min(textItem.implicitWidth + Metrics.padding(20),
                                    chatView.width * 0.8)

                    implicitHeight: textItem.implicitHeight + Metrics.padding(16)

                    TextEdit {
                        id: textItem

                        text: StringUtils.markdownToHtml(message)
                        textFormat: TextEdit.RichText
                        wrapMode: TextEdit.Wrap
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