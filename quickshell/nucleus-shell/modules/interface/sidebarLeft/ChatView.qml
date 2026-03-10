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
                "<div style='margin:8px 0;border-radius:16px;background:#1e1e1e;'>"+
                    "<div style='background:#2b2b2b;color:#b0b0b0;font-size:12px;padding:6px 12px;border-top-left-radius:16px;border-top-right-radius:16px;'>"+
                    language+
                    "</div>"+
                    "<div style='background:#1e1e1e;border-bottom-left-radius:16px;border-bottom-right-radius:16px;'>"+
                        "<pre style='margin:0;padding:12px;font-family:monospace;white-space:pre-wrap;color:#e6e6e6;'>"+
                        escaped+
                        "</pre>"+
                    "</div>"+
                "</div>"

            codeBlocks.push(html)

            return "CODEBLOCK_" + (index++)
        })

        let html = StringUtils.markdownToHtml(msg)

        for (let i = 0; i < codeBlocks.length; i++)
            html = html.replace("CODEBLOCK_" + i, codeBlocks[i])

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

            delegate: ChatBubble {
                sender: model.sender
                message: model.message
                chatView: chatView
                formatMessage: root.formatMessage
            }
        }
    }
}