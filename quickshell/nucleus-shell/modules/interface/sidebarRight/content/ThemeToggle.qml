import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.config
import qs.modules.components

Rectangle {
    id: root

    readonly property bool isDark: Config.runtime.appearance.theme === "dark"
    property string themestatusicon: isDark ? "dark_mode" : "light_mode"

    width: 200
    height: 80
    radius: Metrics.radius("childish")
    color: Appearance.m3colors.m3paddingContainer
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    Layout.margins: 0

    MaterialSymbol {
        anchors.centerIn: parent
        iconSize: Metrics.iconSize(35)
        icon: themestatusicon
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Quickshell.execDetached(["nucleus", "ipc", "global", "toggleTheme"]);
        }
    }

}
