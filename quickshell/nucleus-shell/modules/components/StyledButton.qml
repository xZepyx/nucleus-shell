import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.modules.functions

Control {
    id: root

    property alias text: label.text
    property string icon: ""
    property int iconSize: Metrics.iconSize(20)
    property alias radius: background.radius
    property alias topLeftRadius: background.topLeftRadius
    property alias topRightRadius: background.topRightRadius
    property alias bottomLeftRadius: background.bottomLeftRadius
    property alias bottomRightRadius: background.bottomRightRadius
    property bool checkable: false
    property bool checked: true
    property bool secondary: false
    property string tooltipText: ""
    property bool usePrimary: secondary ? false : checked
    property color base_bg: usePrimary ? Appearance.m3colors.m3primary : Appearance.m3colors.m3secondaryContainer
    property color base_fg: usePrimary ? Appearance.m3colors.m3onPrimary : Appearance.m3colors.m3onSecondaryContainer
    property color disabled_bg: ColorUtils.transparentize(base_bg, 0.4)
    property color disabled_fg: ColorUtils.transparentize(base_fg, 0.4)
    property color hover_bg: Qt.lighter(base_bg, 1.1)
    property color pressed_bg: Qt.darker(base_bg, 1.2)
    property color backgroundColor: !root.enabled ? disabled_bg : mouse_area.pressed ? pressed_bg : mouse_area.containsMouse ? hover_bg : base_bg
    property color textColor: !root.enabled ? disabled_fg : base_fg
    property bool beingHovered: mouse_area.containsMouse

    signal clicked()
    signal toggled(bool checked)

    implicitWidth: (label.text === "" && icon !== "") ? implicitHeight : row.implicitWidth + implicitHeight
    implicitHeight: 40

    MouseArea {
        id: mouse_area

        anchors.fill: parent
        hoverEnabled: root.enabled
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
        onClicked: {
            if (!root.enabled)
                return ;

            if (root.checkable) {
                root.checked = !root.checked;
                root.toggled(root.checked);
            }
            root.clicked();
        }
    }

    HoverHandler {
        id: hover

        enabled: root.tooltipText !== ""
    }

    LazyLoader {
        active: root.tooltipText !== ""

        StyledPopout {
            hoverTarget: hover
            hoverDelay: Metrics.chronoDuration(500)

            Component {
                StyledText {
                    text: root.tooltipText
                }

            }

        }

    }

    contentItem: Item {
        anchors.fill: parent

        Row {
            id: row

            anchors.centerIn: parent
            spacing: root.icon !== "" && label.text !== "" ? 5 : 0

            MaterialSymbol {
                visible: root.icon !== ""
                icon: root.icon
                font.pixelSize: root.iconSize
                color: root.textColor
                anchors.verticalCenter: parent.verticalCenter

                Behavior on color {
                    ColorAnimation {
                        duration: Metrics.chronoDuration("small") / 2
                        easing.type: Appearance.animation.easing
                    }

                }

            }

            StyledText {
                id: label

                color: root.textColor
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight

                Behavior on color {
                    ColorAnimation {
                        duration: Metrics.chronoDuration("small") / 2
                        easing.type: Appearance.animation.easing
                    }

                }

            }

        }

    }

    background: Rectangle {
        id: background

        radius: Metrics.radius("large") 
        color: root.backgroundColor

        Behavior on color {
            ColorAnimation {
                duration: Metrics.chronoDuration("small") / 2
                easing.type: Appearance.animation.easing
            }

        }

        Behavior on radius {
            NumberAnimation {
                duration: Metrics.chronoDuration("small") / 2
                easing.type: Appearance.animation.easing
            }

        }

        Behavior on topLeftRadius {
            NumberAnimation {
                duration: Metrics.chronoDuration("small")
                easing.type: Appearance.animation.easing
            }

        }

        Behavior on topRightRadius {
            NumberAnimation {
                duration: Metrics.chronoDuration("small") 
                easing.type: Appearance.animation.easing
            }

        }

        Behavior on bottomLeftRadius {
            NumberAnimation {
                duration: Metrics.chronoDuration("small") 
                easing.type: Appearance.animation.easing
            }

        }

        Behavior on bottomRightRadius {
            NumberAnimation {
                duration: Metrics.chronoDuration("small") 
                easing.type: Appearance.animation.easing
            }

        }

    }

}
