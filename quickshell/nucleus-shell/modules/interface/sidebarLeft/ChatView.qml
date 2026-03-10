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

    function formatMessage(msg) {

        let codeBlocks = []
        let index = 0

        msg = msg.replace(/```(\w+)?\n([\s\S]*?)```/g, function(_, lang, code) {

            let language = lang ? lang : "code"

            let escaped = code
                .replace(/</g,"&lt;")
                .replace(/>/g,"&gt;")

            let html =
                "<div style='background:#1e1e1e;border-radius:10px;margin:8px 0;'>"+
                "<div style='color:#aaa;font-size:12px;padding:6px 10px;border-bottom:1px solid #333;'>"+language+"</div>"+
                "<pre style='margin:0;padding:10px;font-family:monospace;white-space:pre-wrap;color:#e6e6e6;'>"
                + escaped +
                "</pre></div>"

            codeBlocks.push(html)

            return "CODEBLOCK_" + (index++)
        })

        let html = StringUtils.markdownToHtml(msg)

        for (let i = 0; i < codeBlocks.length; i++) {
            html = html.replace("CODEBLOCK_" + i, codeBlocks[i])
        }

        return html
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

                        text: formatMessage(message)
                        textFormat: TextEdit.RichText
                        wrapMode: TextEdit.Wrap
                        readOnly: true

                        color: "white"
                        font.pixelSize: Metrics.fontSize(16)

                        anchors.fill: parent
                        padding: Metrics.padding(8)
                    }

                    StyledButton {
                        icon: "content_copy"
                        visible: message.includes("```")

                        anchors {
                            right: parent.right
                            top: parent.top
                            rightMargin: 10
                            topMargin: 10
                        }

                        implicitWidth: 28
                        implicitHeight: 28

                        onClicked: {
                            let code = message
                                .replace(/```(\w+)?\n/,"")
                                .replace(/```$/,"")

                            let p = Qt.createQmlObject(
                                'import Quickshell; import Quickshell.Io; Process { command: ["wl-copy", "' + code + '"] }',
                                parent
                            )
                            p.running = true
                        }
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
