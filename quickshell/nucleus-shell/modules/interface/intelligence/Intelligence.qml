import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Io
import qs.config
import qs.modules.functions
import qs.modules.widgets

Scope {
    IpcHandler {
        function openWindow() {
            Globals.states.intelligenceWindowOpen = true;
        }

        target: "intelligence"
    }

    LazyLoader {
        active: Globals.states.intelligenceWindowOpen

        Window {
            id: appWin

            property string currentChat: "default"
            property string currentModel: "gpt-4o-mini"
            property string pendingInput: ""

            function appendMessage(sender, message) {
                messageModel.append({
                    "sender": sender,
                    "message": message
                });
                scrollToBottom();
            }

            function scrollToBottom() {
                // Always scroll to end after appending
                chatView.forceLayout();
                chatView.positionViewAtEnd();
            }

            function sendMessage() {
                if (userInput.text === "" || zenithProcess.running)
                    return ;

                pendingInput = userInput.text;
                appendMessage("You", pendingInput);
                userInput.text = "";
                zenithProcess.running = true;
            }

            function loadChatHistory(chatName) {
                messageModel.clear();
                chatLoadProcess.command = ["cat", FileUtils.trimFileProtocol(Directories.config) + "/zenith/chats/" + chatName + ".txt"];
                chatLoadProcess.running = true;
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
                    appWin.currentChat = "default";
                    loadChatHistory("default");
                } else if (chatListModel.count > 0) {
                    chatSelector.currentIndex = 0;
                    appWin.currentChat = chatListModel.get(0).name;
                    loadChatHistory(appWin.currentChat);
                }
            }

            visible: true
            width: 600
            height: 700
            title: "intelligence"

            ListModel {
                // { sender: "You" | "AI", message: string }

                id: messageModel
            }

            ListModel {
                id: chatListModel
            }

            StyledRect {
                anchors.fill: parent
                color: Appearance.m3colors.m3background

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        StyledDropDown {
                            id: chatSelector

                            Layout.fillWidth: true
                            model: chatListModel
                            textRole: "name"
                            Layout.preferredHeight: 40
                            onCurrentIndexChanged: {
                                if (currentIndex < 0 || currentIndex >= chatListModel.count)
                                    return ;

                                let chatName = chatListModel.get(currentIndex).name;
                                appWin.currentChat = chatName;
                                loadChatHistory(chatName);
                            }
                        }

                        StyledButton {
                            icon: "add"
                            Layout.preferredWidth: 40
                            onClicked: {
                                let name = "New Chat " + chatListModel.count;
                                chatListModel.append({
                                    "name": name
                                });
                                chatSelector.currentIndex = chatListModel.count - 1;
                                appWin.currentChat = name;
                                messageModel.clear();
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
                                FileUtils.removeFile(Directories.config + "/zenith/chats/" + name + ".txt");
                                chatListModel.remove(chatSelector.currentIndex);
                                selectDefaultChat();
                            }
                        }

                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        StyledDropDown {
                            id: modelSelector

                            Layout.fillWidth: true
                            model: ["gpt-4o-mini", "gpt-3.5-turbo"]
                            currentIndex: 0
                            Layout.preferredHeight: 40
                            onCurrentTextChanged: appWin.currentModel = currentText
                        }

                        StyledButton {
                            icon: "expand_more"
                            Layout.preferredWidth: 40
                            enabled: Globals.states.intelligenceWindowOpen
                            onClicked: {
                                Globals.states.intelligenceWindowOpen = false;
                                Globals.visiblility.sidebarLeft = true;
                            }
                        }

                    }

                    StyledRect {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: Appearance.rounding.normal
                        color: Appearance.m3colors.m3surfaceContainerLow

                        ScrollView {
                            anchors.fill: parent
                            clip: true

                            ListView {
                                id: chatView

                                model: messageModel
                                spacing: 8
                                anchors.fill: parent
                                anchors.margins: 12
                                clip: true

                                delegate: Item {
                                    property bool firstOfGroup: index === 0 || messageModel.get(index - 1).sender !== sender
                                    property bool isCodeBlock: message.split("\n").length > 2 && message.includes("import ") // simple heuristic

                                    width: chatView.width
                                    height: bubble.implicitHeight + 6
                                    Component.onCompleted: {
                                        chatView.forceLayout();
                                    }

                                    Row {
                                        width: parent.width
                                        spacing: 8

                                        Item {
                                            width: sender === "AI" ? 0 : parent.width * 0.2
                                        }

                                        StyledRect {
                                            id: bubble

                                            radius: firstOfGroup ? Appearance.rounding.normal : Appearance.rounding.unsharpenmore
                                            color: sender === "You" ? Appearance.m3colors.m3primaryContainer : Appearance.m3colors.m3surfaceContainerHigh
                                            implicitWidth: Math.min(textItem.implicitWidth + 20, chatView.width * 0.8)
                                            implicitHeight: textItem.implicitHeight
                                            anchors.right: sender === "You" ? parent.right : undefined
                                            anchors.left: sender === "AI" ? parent.left : undefined
                                            anchors.topMargin: firstOfGroup ? 6 : 2

                                            TextEdit {
                                                id: textItem

                                                text: StringUtils.markdownToHtml(message)
                                                wrapMode: TextEdit.Wrap
                                                textFormat: TextEdit.RichText
                                                readOnly: true // make it selectable but not editable
                                                font.pixelSize: 16
                                                color: Appearance.syntaxHighlightingTheme
                                                padding: 8
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
                        radius: Appearance.rounding.normal
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
                                font.pixelSize: 14
                                padding: 8
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
                                enabled: userInput.text.trim().length > 0 && !zenithProcess.running
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
                    x: (appWin.width - 360) / 2 // center horizontally
                    y: (appWin.height - 160) / 2 // center vertically
                    width: 360
                    height: 200

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        StyledText {
                            text: "Enter a new name for the chat"
                            font.pixelSize: 18
                            horizontalAlignment: Text.AlignHCenter
                            Layout.fillWidth: true
                        }

                        StyledTextField {
                            id: renameInput

                            Layout.fillWidth: true
                            placeholderText: "New chat name"
                            filled: false
                            highlight: false
                            text: chatSelector.currentText
                            font.pixelSize: 16
                            Layout.preferredHeight: 45
                            padding: 8
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
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
                                    // Rename file
                                    FileUtils.renameFile(oldPath, newPath);
                                    // Update model
                                    chatListModel.set(chatSelector.currentIndex, {
                                        "name": newName
                                    });
                                    appWin.currentChat = newName;
                                    renameDialog.close();
                                }
                            }

                        }

                    }

                    background: StyledRect {
                        color: Appearance.m3colors.m3surfaceContainer
                        radius: Appearance.rounding.normal
                        border.color: Appearance.colors.colOutline
                        border.width: 1
                    }

                    header: StyledRect {
                        color: Appearance.m3colors.m3surfaceContainer
                        radius: Appearance.rounding.normal
                        border.color: Appearance.colors.colOutline
                        border.width: 1
                    }

                }

                StyledText {
                    text: "Thinking…"
                    visible: zenithProcess.running
                    color: Appearance.colors.colSubtext
                    font.pixelSize: 14

                    anchors {
                        left: parent.left
                        bottom: parent.bottom
                        leftMargin: 22
                        bottomMargin: 76
                    }

                }

            }

            Process {
                id: listChatsProcess

                command: ["ls", FileUtils.trimFileProtocol(Directories.config) + "/zenith/chats"]
                running: true

                stdout: StdioCollector {
                    onStreamFinished: {
                        chatListModel.clear();
                        if (text.trim() === "") {
                            chatListModel.append({
                                "name": "default"
                            });
                        } else {
                            let files = text.trim().split("\n");
                            for (let i = 0; i < files.length; i++) {
                                if (files[i].endsWith(".txt"))
                                    chatListModel.append({
                                    "name": files[i].slice(0, -4)
                                });

                            }
                        }
                        selectDefaultChat();
                    }
                }

            }

            Process {
                id: chatLoadProcess

                stdout: StdioCollector {
                    onStreamFinished: {
                        let lines = text.split(/\r?\n/);
                        let batch = [];
                        for (let i = 0; i < lines.length; i++) {
                            let line = lines[i].trim();
                            if (line.length === 0)
                                continue;

                            // Match timestamped User/AI lines: [YYYY-MM-DD HH:MM:SS] User: message
                            let userMatch = line.match(/^\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\] User: (.*)$/);
                            let aiMatch = line.match(/^\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\] AI: (.*)$/);
                            if (userMatch) {
                                batch.push({
                                    "sender": "You",
                                    "message": userMatch[1]
                                });
                            } else if (aiMatch) {
                                batch.push({
                                    "sender": "AI",
                                    "message": aiMatch[1]
                                });
                            } else {
                                // Continuation lines (for multi-line messages)
                                if (batch.length > 0)
                                    batch[batch.length - 1].message += "\n" + line;

                            }
                        }
                        // Append messages to model
                        Qt.callLater(function() {
                            messageModel.clear();
                            for (let i = 0; i < batch.length; i++) messageModel.append(batch[i])
                            chatView.forceLayout();
                            chatView.positionViewAtEnd();
                        });
                    }
                }

            }

            Process {
                id: zenithProcess

                command: ["zenith", "--chat", appWin.currentChat, "-a", "--model", appWin.currentModel, pendingInput]
                running: false

                stdout: StdioCollector {
                    onStreamFinished: {
                        if (text.trim() !== "")
                            appendMessage("AI", text.trim().slice(5));

                    }
                }

            }

        }

    }

}
