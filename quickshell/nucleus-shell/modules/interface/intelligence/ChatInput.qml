import QtQuick
import QtQuick.Layouts
import qs.config
import qs.modules.components

StyledRect {

    signal send(string text)

    height: 50
    radius: Metrics.radius("normal")
    color: Appearance.m3colors.m3surfaceContainer

    RowLayout {
        anchors.fill: parent
        anchors.margins: Metrics.margin(6)

        StyledTextField {
            id: userInput

            Layout.fillWidth: true
            placeholderText: "Type your message..."

            Keys.onPressed: {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    send(userInput.text)
                    userInput.text = ""
                    event.accepted = true
                }
            }
        }

        StyledButton {
            text: "Send"

            onClicked: {
                send(userInput.text)
                userInput.text = ""
            }
        }
    }
}
