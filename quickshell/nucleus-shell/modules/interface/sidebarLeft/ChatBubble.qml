import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.config
import qs.modules.components
import qs.modules.functions

Item {

    property string sender
    property string message
    property var chatView
    property var formatMessage

    width: parent ? parent.width : 0
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

        width: Math.min(
                   textItem.implicitWidth + Metrics.padding(20),
                   (parent ? parent.width : 0) * 0.8
               )

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

        HoverHandler {
            id: hover
        }

        StyledButton {
    id: copyButton

    property bool copied: false

    icon: copied ? "check" : "content_copy"

    visible: hover.hovered && message.includes("```")

    anchors {
        right: parent.right
        top: parent.top
        rightMargin: 12
        topMargin: 38
    }

    implicitWidth: 26
    implicitHeight: 26
    z: 10

    onClicked: {

        let match = message.match(/```(\w+)?\n([\s\S]*?)```/)
        let code = match ? match[2] : message

        let escaped = JSON.stringify(code)

        let p = Qt.createQmlObject(
            'import Quickshell; import Quickshell.Io; Process { command: ["wl-copy", ' + escaped + '] }',
            parent
        )

        p.running = true

        copied = true
        resetTimer.start()
    }

    Timer {
        id: resetTimer
        interval: 1500
        running: false
        repeat: false
        onTriggered: copyButton.copied = false
    }
}

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton

            onClicked: {

                let escaped = JSON.stringify(message)

                let p = Qt.createQmlObject(
                    'import Quickshell; import Quickshell.Io; Process { command: ["wl-copy", ' + escaped + '] }',
                    parent
                )

                p.running = true
            }
        }
    }
}