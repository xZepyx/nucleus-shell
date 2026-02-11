import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import Quickshell
import Quickshell.Wayland

import qs.config
import qs.services
import qs.modules.components


Scope {
    id: root
    property bool active: false
    property var window: null

    Connections {
        target: Polkit
        function onIsActiveChanged() {
            if (Polkit.isActive) {
                root.active = true;
            } else if (root.active && window) {
                window.closeWithAnimation();
            }
        }
    }

    LazyLoader {
        active: root.active
        component: Prompt {
            id: window

            Component.onCompleted: root.window = window
            Component.onDestruction: root.window = null

            onFadeOutFinished: root.active = false

            Item {
                id: promptContainer
                property bool showPassword: false
                property bool authenticating: false

                anchors.centerIn: parent
                width: promptBg.width
                height: promptBg.height

                Item {
                    Component.onCompleted: {
                        parent.layer.enabled = true;
                        parent.layer.effect = effectComponent;
                    }

                    Component {
                        id: effectComponent
                        MultiEffect {
                            shadowEnabled: true
                            shadowOpacity: 1
                            shadowColor: Appearance.colors.m3shadow
                            shadowBlur: 1
                            shadowScale: 1
                        }
                    }
                }

                Rectangle {
                    id: promptBg
                    width: promptLayout.width + 40
                    height: promptLayout.height + 40
                    color: Appearance.m3colors.m3surface
                    radius: Metrics.radius(20)

                    Behavior on height {
                        NumberAnimation {
                            duration: Metrics.chronoDuration("small")
                            easing.type: Appearance.animation.easing
                        }
                    }
                }

                ColumnLayout {
                    id: promptLayout
                    spacing: Metrics.spacing(10)
                    anchors {
                        left: promptBg.left
                        leftMargin: Metrics.margin(20)
                        top: promptBg.top
                        topMargin: Metrics.margin(20)
                    }

                    ColumnLayout {
                        spacing: Metrics.spacing(5)
                        MaterialSymbol {
                            icon: "security"
                            color: Appearance.m3colors.m3primary
                            font.pixelSize: Metrics.fontSize(22)
                            Layout.alignment: Qt.AlignHCenter
                        }
                        StyledText {
                            text: "Authentication required"
                            font.family: "Outfit SemiBold"
                            font.pixelSize: Metrics.fontSize(20)
                            Layout.alignment: Qt.AlignHCenter
                        }
                        StyledText {
                            text: Polkit.flow.message
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    RowLayout {
                        spacing: Metrics.spacing(5)
                        StyledTextField {
                            id: textfield
                            Layout.fillWidth: true
                            leftPadding: undefined
                            padding: Metrics.padding(10)
                            filled: false
                            enabled: !promptContainer.authenticating
                            placeholder: Polkit.flow.inputPrompt.substring(0, Polkit.flow.inputPrompt.length - 2)
                            echoMode: promptContainer.showPassword ? TextInput.Normal : TextInput.Password
                            inputMethodHints: Qt.ImhSensitiveData
                            focus: true
                            Keys.onReturnPressed: okButton.clicked()
                        }
                        StyledButton {
                            Layout.fillHeight: true
                            width: height
                            radius: Metrics.radius(10)
                            topLeftRadius: Metrics.radius(5)
                            bottomLeftRadius: Metrics.radius(5)
                            enabled: !promptContainer.authenticating
                            checkable: true
                            checked: promptContainer.showPassword
                            icon: promptContainer.showPassword ? 'visibility' : 'visibility_off'
                            onToggled: promptContainer.showPassword = !promptContainer.showPassword
                        }
                    }

                    
                    RowLayout {
                        RowLayout {
                            visible: Polkit.flow.failed && !Polkit.flow.isSuccessful && !promptContainer.authenticating
                            MaterialSymbol {
                                icon: "warning"
                                color: Appearance.m3colors.m3error
                                font.pixelSize: Metrics.fontSize(15)
                            }
                            StyledText {
                                text: "Failed to authenticate, incorrect password."
                                color: Appearance.m3colors.m3error
                                font.pixelSize: Metrics.fontSize(15)
                            }
                        }
                        LoadingIcon {
                            visible: promptContainer.authenticating
                            Layout.alignment: Qt.AlignLeft
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        StyledButton {
                            radius: Metrics.radius(10)
                            topRightRadius: Metrics.radius(5)
                            bottomRightRadius: Metrics.radius(5)
                            secondary: true
                            text: "Cancel"
                            // enabled: !promptContainer.authenticating (Allows to cancel if stuck in loop)
                            onClicked: Polkit.flow.cancelAuthenticationRequest()
                        }
                        StyledButton {
                            id: okButton
                            radius: Metrics.radius(10)
                            topLeftRadius: Metrics.radius(5)
                            bottomLeftRadius: Metrics.radius(5)
                            text: promptContainer.authenticating ? "Authenticating..." : "OK"
                            enabled: !promptContainer.authenticating
                            onClicked: {
                                promptContainer.authenticating = true;
                                Polkit.flow.submit(textfield.text);
                            }
                        }
                    }
                }

                Connections {
                    target: Polkit.flow
                    function onIsCompletedChanged() {
                        if (Polkit.flow.isCompleted) {
                            promptContainer.authenticating = false;
                        }
                    }
                    function onFailedChanged() {
                        if (Polkit.flow.failed) {
                            promptContainer.authenticating = false;
                        }
                    }
                    function onIsCancelledChanged() {
                        if (Polkit.flow.isCancelled) {
                            promptContainer.authenticating = false;
                        }
                    }
                }
            }
        }
    }
}