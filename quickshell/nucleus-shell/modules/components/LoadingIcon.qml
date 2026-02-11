import QtQuick
import qs.config

Item {
    id: root
    property alias icon: mIcon.icon
    property real size: Metrics.iconSize(28)
    width: size
    height: size
    MaterialSymbol {
        id: mIcon
        anchors.centerIn: parent
        icon: "progress_activity"
        font.pixelSize: root.size
        color: Appearance.m3colors.m3primary
        renderType: Text.QtRendering
    }
    RotationAnimator on rotation {
        target: mIcon
        running: true
        loops: Animation.Infinite
        from: 0
        to: 360
        duration: Metrics.chronoDuration(1000)
    }
}