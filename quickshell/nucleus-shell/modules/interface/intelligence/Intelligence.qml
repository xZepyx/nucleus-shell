import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Io
import qs.config
import qs.modules.functions
import qs.modules.components
import qs.services

FloatingWindow {
    id: appWin
    color: Appearance.m3colors.m3background

    property bool chatsInitialized: false

    visible: Globals.states.intelligenceWindowOpen

    ListModel { id: messageModel }
    ListModel { id: chatListModel }

    function appendMessage(sender, message) {
        messageModel.append({
            "sender": sender,
            "message": message
        })
        chatView.scrollToBottom()
    }

    function sendMessage(text) {
        if (text === "" || Zenith.loading)
            return

        Zenith.pendingInput = text
        appendMessage("You", text)
        Zenith.loading = true
        Zenith.send()
    }

    function loadChatHistory(name) {
        messageModel.clear()
        Zenith.loadChat(name)
    }

    onVisibleChanged: {
        if (!visible)
            return

        chatsInitialized = false
        messageModel.clear()
    }

    IpcHandler {
        function openWindow() { Globals.states.intelligenceWindowOpen = true }
        function closeWindow() { Globals.states.intelligenceWindowOpen = false }
        target: "intelligence"
    }

    StyledRect {
        anchors.fill: parent
        color: "transparent"
        visible: Config.runtime.misc.intelligence.enabled

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Metrics.margin(16)
            spacing: Metrics.spacing(10)

            ChatHeader {
                id: header

                chatListModel: chatListModel

                onChatSelected: (name) => {
                    Zenith.currentChat = name
                    loadChatHistory(name)
                }
            }

            ChatView {
                id: chatView
                Layout.fillWidth: true
                Layout.fillHeight: true

                messageModel: messageModel
            }

            ChatInput {
                Layout.fillWidth: true

                onSend: (text) => sendMessage(text)
            }
        }
    }

    Connections {
        target: Zenith

        function onAiReply(text) {
            appendMessage("AI", text.slice(5))
            Zenith.loading = false
        }

        function onChatLoaded(text) {
            let lines = text.split(/\r?\n/)
            let batch = []

            for (let l of lines) {
                let line = l.trim()
                if (!line.length)
                    continue

                let u = line.match(/^\[\d{4}-.*\] User: (.*)$/)
                let a = line.match(/^\[\d{4}-.*\] AI: (.*)$/)

                if (u)
                    batch.push({"sender":"You","message":u[1]})
                else if (a)
                    batch.push({"sender":"AI","message":a[1]})
                else if (batch.length)
                    batch[batch.length-1].message += "\n"+line
            }

            messageModel.clear()
            for (let m of batch)
                messageModel.append(m)

            chatView.scrollToBottom()
        }
    }
}
