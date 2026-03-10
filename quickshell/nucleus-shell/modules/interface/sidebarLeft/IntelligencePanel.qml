import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.config
import qs.modules.functions
import qs.modules.components
import qs.services

Item {
    id: root

    property bool initialChatSelected: false

    function appendMessage(sender, message) {
        messageModel.append({
            "sender": sender,
            "message": message
        })
        scrollToBottom()
    }

    function scrollToBottom() {
        chatView.positionViewAtEnd()
    }

    function updateChatsList(files) {
        let existing = {}
        for (let i = 0; i < chatListModel.count; i++)
            existing[chatListModel.get(i).name] = true

        for (let file of files) {
            let name = file.trim()
            if (!name.length)
                continue

            if (name.endsWith(".txt"))
                name = name.slice(0, -4)

            if (!existing[name])
                chatListModel.append({"name": name})

            delete existing[name]
        }

        for (let name in existing) {
            for (let i = 0; i < chatListModel.count; i++) {
                if (chatListModel.get(i).name === name) {
                    chatListModel.remove(i)
                    break
                }
            }
        }

        let hasDefault = false
        for (let i = 0; i < chatListModel.count; i++)
            if (chatListModel.get(i).name === "default")
                hasDefault = true

        if (!hasDefault) {
            chatListModel.insert(0, {"name": "default"})
            FileUtils.createFile(
                FileUtils.trimFileProtocol(Directories.config)
                + "/zenith/chats/default.txt"
            )
        }
    }

    function sendMessage() {
        if (userInput.text === "" || Zenith.loading)
            return

        Zenith.pendingInput = userInput.text
        appendMessage("You", userInput.text)
        userInput.text = ""
        Zenith.loading = true
        Zenith.send()
    }

    function loadChatHistory(chatName) {
        messageModel.clear()
        Zenith.loadChat(chatName)
    }

    function selectDefaultChat() {
        let defaultIndex = -1

        for (let i = 0; i < chatListModel.count; i++) {
            if (chatListModel.get(i).name === "default") {
                defaultIndex = i
                break
            }
        }

        if (defaultIndex !== -1) {
            chatSelector.currentIndex = defaultIndex
            Zenith.currentChat = "default"
            loadChatHistory("default")
        } else if (chatListModel.count > 0) {
            chatSelector.currentIndex = 0
            Zenith.currentChat = chatListModel.get(0).name
            loadChatHistory(Zenith.currentChat)
        }
    }

    ListModel { id: messageModel }
    ListModel { id: chatListModel }

    StyledRect {
        anchors.fill: parent
        anchors.topMargin: Metrics.margin(74)
        radius: Metrics.radius("normal")
        color: "transparent"
        visible: Config.runtime.misc.intelligence.enabled

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Metrics.margin(16)
            spacing: Metrics.spacing(10)

            RowLayout {
                Layout.fillWidth: true
                spacing: Metrics.spacing(10)

                StyledDropDown {
                    id: chatSelector
                    Layout.fillWidth: true
                    model: chatListModel
                    textRole: "name"
                    Layout.preferredHeight: 40

                    onCurrentIndexChanged: {
                        if (!initialChatSelected)
                            return

                        if (currentIndex < 0 || currentIndex >= chatListModel.count)
                            return

                        let chatName = chatListModel.get(currentIndex).name
                        Zenith.currentChat = chatName
                        loadChatHistory(chatName)
                    }
                }
            }

            ChatView {
                id: chatView
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: messageModel
            }

            ChatInput {
                id: userInputContainer
                Layout.fillWidth: true
                onSend: sendMessage()
            }
        }
    }

    Connections {
        target: Zenith

        function onChatsListed(text) {
            let lines = text.split(/\r?\n/)
            updateChatsList(lines)

            if (!initialChatSelected) {
                selectDefaultChat()
                initialChatSelected = true
            }
        }

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
                    batch[batch.length-1].message += "\n" + line
            }

            messageModel.clear()
            for (let m of batch)
                messageModel.append(m)

            scrollToBottom()
        }
    }
}
