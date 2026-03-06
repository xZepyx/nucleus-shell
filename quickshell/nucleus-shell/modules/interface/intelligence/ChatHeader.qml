import QtQuick
import QtQuick.Layouts
import qs.modules.components

RowLayout {
    property var chatListModel
    signal chatSelected(string name)

    StyledDropDown {
        id: chatSelector
        Layout.fillWidth: true

        model: chatListModel
        textRole: "name"

        onCurrentIndexChanged: {
            if (currentIndex < 0) return
            chatSelected(chatListModel.get(currentIndex).name)
        }
    }

    StyledDropDown {
        id: modelSelector
        Layout.fillWidth: true

        model: [
            "openai/gpt-4o",
            "openai/gpt-4",
            "openai/gpt-3.5-turbo",
            "openai/gpt-4o-mini",
            "anthropic/claude-3.5-sonnet"
        ]

        onCurrentTextChanged: Zenith.currentModel = currentText
    }

    StyledButton {
        icon: "close_fullscreen"

        onClicked: {
            Quickshell.execDetached(["nucleus","ipc","call","intelligence","closeWindow"])
            Globals.visiblility.sidebarLeft = false
        }
    }
}
