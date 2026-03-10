import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.config
import qs.modules.components

StyledRect {
    id: root

    signal sendMessage(string text)

    Layout.fillWidth: true
    height: 50
    radius: Metrics.radius("normal")
    color: Appearance.m3colors.m3surfaceContainer

    RowLayout {
        anchors.fill: parent
        anchors.margins: 6
        spacing: 10

        StyledTextField {
            id: userInput

            Layout.fillWidth: true
            placeholderText: "Type your message..."
            font.pixelSize: Metrics.fontSize(14)
            padding: Metrics.padding(8)

            Keys.onPressed: {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {

                    if (event.modifiers & Qt.ShiftModifier) {
                        insert("\n")
                    } else {
                        root.sendMessage(userInput.text)
                    }

                    event.accepted = true
                }
            }
        }

        StyledButton {
            text: "Send"
            enabled: userInput.text.trim().length > 0
            opacity: enabled ? 1 : 0.5

            onClicked: root.sendMessage(userInput.text)
        }
    }

    function clear() {
        userInput.text = ""
    }
}