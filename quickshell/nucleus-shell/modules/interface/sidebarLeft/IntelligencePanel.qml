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
        });
        scrollToBottom();
    }

    function updateChatsList(files) {
        let existing = {
        };
        for (let i = 0; i < chatListModel.count; i++) existing[chatListModel.get(i).name] = true
        for (let file of files) {
            let name = file.trim();
            if (!name.length)
                continue;

            if (name.endsWith(".txt"))
                name = name.slice(0, -4);

            if (!existing[name])
                chatListModel.append({
                "name": name
            });

            delete existing[name];
        }
        // remove chats that no longer exist
        for (let name in existing) {
            for (let i = 0; i < chatListModel.count; i++) {
                if (chatListModel.get(i).name === name) {
                    chatListModel.remove(i);
                    break;
                }
            }
        }
        // ensure default exists
        let hasDefault = false;
        for (let i = 0; i < chatListModel.count; i++) if (chatListModel.get(i).name === "default") {
            hasDefault = true;
        }
        if (!hasDefault) {
            chatListModel.insert(0, {
                "name": "default"
            });
            FileUtils.createFile(FileUtils.trimFileProtocol(Directories.config) + "/zenith/chats/default.txt");
        }
    }

    function scrollToBottom() {
        chatView.positionViewAtEnd();
    }

    function sendMessage() {
        if (userInput.text === "" || Zenith.loading)
            return ;

        Zenith.pendingInput = userInput.text;
        appendMessage("You", userInput.text);
        userInput.text = "";
        Zenith.loading = true;
        Zenith.send();
    }

    function loadChatHistory(chatName) {
        messageModel.clear();
        Zenith.loadChat(chatName);
    }

    function selectDefaultChat() {
        let defaultIndex = -1;
        for (let i = 0; i < chatListModel.count; i++) {
            if (chatListModel.get(i).name === "default") {
                defaultIndex = i;
                break;
            }
        }
        if (defaultIndex !== -1) {
            chatSelector.currentIndex = defaultIndex;
            Zenith.currentChat = "default";
            loadChatHistory("default");
        } else if (chatListModel.count > 0) {
            chatSelector.currentIndex = 0;
            Zenith.currentChat = chatListModel.get(0).name;
            loadChatHistory(Zenith.currentChat);
        }
    }

    ListModel {
        // { sender: "You" | "AI", message: string }

        id: messageModel
    }

    ListModel {
        id: chatListModel
    }

    ColumnLayout {
        spacing: Metrics.spacing(8)
        anchors.centerIn: parent

        StyledText {
            visible: !Config.runtime.misc.intelligence.enabled
            text: "Intelligence is disabled!"
            Layout.leftMargin: Metrics.margin(24)
            font.pixelSize: Appearance.font.size.huge
        }

        StyledText {
            visible: !Config.runtime.misc.intelligence.enabled
            text: "Go to the settings to enable intelligence"
        }

    }

    StyledRect {
        anchors.topMargin: Metrics.margin(74)
        radius: Metrics.radius("normal")
        anchors.fill: parent
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
                            return ;

                        if (currentIndex < 0 || currentIndex >= chatListModel.count)
                            return ;

                        let chatName = chatListModel.get(currentIndex).name;
                        Zenith.currentChat = chatName;
                        loadChatHistory(chatName);
                    }
                }

                StyledButton {
                    icon: "add"
                    Layout.preferredWidth: 40
                    onClicked: {
                        let name = "new-chat-" + chatListModel.count;
                        let path = FileUtils.trimFileProtocol(Directories.config) + "/zenith/chats/" + name + ".txt";
                        FileUtils.createFile(path, function(success) {
                            if (success) {
                                chatListModel.append({
                                    "name": name
                                });
                                chatSelector.currentIndex = chatListModel.count - 1;
                                Zenith.currentChat = name;
                                messageModel.clear();
                            }
                        });
                    }
                }

                StyledButton {
                    icon: "edit"
                    Layout.preferredWidth: 40
                    enabled: chatSelector.currentIndex >= 0
                    onClicked: renameDialog.open()
                }

                StyledButton {
                    icon: "delete"
                    Layout.preferredWidth: 40
                    enabled: chatSelector.currentIndex >= 0 && chatSelector.currentText !== "default"
                    onClicked: {
                        let name = chatSelector.currentText;
                        let path = FileUtils.trimFileProtocol(Directories.config) + "/zenith/chats/" + name + ".txt";
                        FileUtils.removeFile(path, function(success) {
                            if (success) {
                                chatListModel.remove(chatSelector.currentIndex);
                                selectDefaultChat();
                            }
                        });
                    }
                }

            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Metrics.spacing(10)

                StyledDropDown {
                    id: modelSelector

                    Layout.fillWidth: true
                    model: ["openai/gpt-4o","openai/gpt-4","openai/gpt-3.5-turbo","openai/gpt-4o-mini","anthropic/claude-3.5-sonnet","anthropic/claude-3-haiku","meta-llama/llama-3.3-70b-instruct:free","deepseek/deepseek-r1-0528:free","qwen/qwen3-coder:free"]
                    currentIndex: 0
                    Layout.preferredHeight: 40
                    onCurrentTextChanged: Zenith.currentModel = currentText
                }

                StyledButton {
                    icon: "fullscreen"
                    Layout.preferredWidth: 40
                    onClicked: {
                        Quickshell.execDetached(["nucleus", "ipc", "intelligence", "openWindow"]);
                        Globals.visiblility.sidebarLeft = false;
                    }
                }

            }

            StyledRect {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: Metrics.radius("normal")
                color: Appearance.m3colors.m3surfaceContainerLow

                ScrollView {
                    anchors.fill: parent
                    clip: true

                    ListView {
                        id: chatView

                        model: messageModel
                        spacing: Metrics.spacing(8)
                        anchors.fill: parent
                        anchors.margins: Metrics.margin(12)
                        clip: true

                        delegate: Item {
                            property bool isCodeBlock: message.split("\n").length > 2 && message.includes("import ") // simple heuristic

                            width: chatView.width
                            height: bubble.implicitHeight + 6
                            Component.onCompleted: {
                                chatView.forceLayout();
                            }

                            Row {
                                width: parent.width
                                spacing: Metrics.spacing(8)

                                Item {
                                    width: sender === "AI" ? 0 : parent.width * 0.2
                                }

                                StyledRect {
                                    id: bubble

                                    radius: Metrics.radius("normal")
                                    color: sender === "You" ? Appearance.m3colors.m3primaryContainer : Appearance.m3colors.m3surfaceContainerHigh
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
                                        readOnly: true // make it selectable but not editable
                                        font.pixelSize: Metrics.fontSize(16)
                                        anchors.leftMargin: Metrics.margin(12)
                                        color: Appearance.syntaxHighlightingTheme
                                        padding: Metrics.padding(8)
                                        anchors.fill: parent
                                    }

                                    MouseArea {
                                        id: ma

                                        anchors.fill: parent
                                        acceptedButtons: Qt.RightButton
                                        onClicked: {
                                            let p = Qt.createQmlObject('import Quickshell; import Quickshell.Io; Process { command: ["wl-copy", "' + message + '"] }', parent);
                                            p.running = true;
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

            StyledRect {
                Layout.fillWidth: true
                height: 50
                radius: Metrics.radius("normal")
                color: Appearance.m3colors.m3surfaceContainer

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 10

                    StyledTextField {
                        // Shift+Enter → insert newline
                        // Enter → send message

                        id: userInput

                        Layout.fillWidth: true
                        placeholderText: "Type your message..."
                        font.pixelSize: Metrics.fontSize(14)
                        padding: Metrics.padding(8)
                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                if (event.modifiers & Qt.ShiftModifier)
                                    insert("\n");
                                else
                                    sendMessage();
                                event.accepted = true;
                            }
                        }
                    }

                    StyledButton {
                        text: "Send"
                        enabled: userInput.text.trim().length > 0 && !Zenith.loading
                        opacity: enabled ? 1 : 0.5
                        onClicked: sendMessage()
                    }

                }

            }

        }

        Dialog {
            id: renameDialog

            title: "Rename Chat"
            modal: true
            visible: false
            standardButtons: Dialog.NoButton
            x: (root.width - 360) / 2 // center horizontally
            y: (root.height - 160) / 2 // center vertically
            width: 360
            height: 200

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Metrics.margin(16)
                spacing: Metrics.spacing(12)

                StyledText {
                    text: "Enter a new name for the chat"
                    font.pixelSize: Metrics.fontSize(18)
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                StyledTextField {
                    id: renameInput

                    Layout.fillWidth: true
                    placeholderText: "New name"
                    filled: false
                    highlight: false
                    text: chatSelector.currentText
                    font.pixelSize: Metrics.iconSize(16)
                    Layout.preferredHeight: 45
                    padding: Metrics.padding(8)
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Metrics.spacing(12)
                    Layout.alignment: Qt.AlignRight

                    StyledButton {
                        text: "Cancel"
                        Layout.preferredWidth: 80
                        onClicked: renameDialog.close()
                    }

                    StyledButton {
                        text: "Rename"
                        Layout.preferredWidth: 100
                        enabled: renameInput.text.trim().length > 0 && renameInput.text !== chatSelector.currentText
                        onClicked: {
                            let oldName = chatSelector.currentText;
                            let newName = renameInput.text.trim();
                            let oldPath = FileUtils.trimFileProtocol(Directories.config) + "/zenith/chats/" + oldName + ".txt";
                            let newPath = FileUtils.trimFileProtocol(Directories.config) + "/zenith/chats/" + newName + ".txt";
                            FileUtils.renameFile(oldPath, newPath, function(success) {
                                if (success) {
                                    chatListModel.set(chatSelector.currentIndex, {
                                        "name": newName
                                    });
                                    Zenith.currentChat = newName;
                                    renameDialog.close();
                                }
                            });
                        }
                    }

                }

            }

            background: StyledRect {
                color: Appearance.m3colors.m3surfaceContainer
                radius: Metrics.radius("normal")
                border.color: Appearance.colors.colOutline
                border.width: 1
            }

            header: StyledRect {
                color: Appearance.m3colors.m3surfaceContainer
                radius: Metrics.radius("normal")
                border.color: Appearance.colors.colOutline
                border.width: 1
            }

        }

        StyledText {
            text: "Thinking…"
            visible: Zenith.loading
            color: Appearance.colors.colSubtext
            font.pixelSize: Metrics.fontSize(14)

            anchors {
                left: parent.left
                bottom: parent.bottom
                leftMargin: Metrics.margin(22)
                bottomMargin: Metrics.margin(76)
            }

        }

    }

    Connections {
        function onChatsListed(text) {
            let lines = text.split(/\r?\n/);
            updateChatsList(lines);
            // only auto-select once
            if (!initialChatSelected) {
                selectDefaultChat();
                initialChatSelected = true;
            }
        }

        function onAiReply(text) {
            appendMessage("AI", text.slice(5));
            Zenith.loading = false;
        }

        function onChatLoaded(text) {
            let lines = text.split(/\r?\n/);
            let batch = [];
            for (let l of lines) {
                let line = l.trim();
                if (!line.length)
                    continue;

                let u = line.match(/^\[\d{4}-.*\] User: (.*)$/);
                let a = line.match(/^\[\d{4}-.*\] AI: (.*)$/);
                if (u)
                    batch.push({
                    "sender": "You",
                    "message": u[1]
                });
                else if (a)
                    batch.push({
                    "sender": "AI",
                    "message": a[1]
                });
                else if (batch.length)
                    batch[batch.length - 1].message += "\n" + line;
            }
            messageModel.clear();
            for (let m of batch) messageModel.append(m)
            scrollToBottom();
        }

        target: Zenith
    }

}
