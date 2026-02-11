import QtQuick
import Quickshell
import qs.config

Item {
    id: root

    property real value: 0.65 // 0.0 → 1.0
    property real strokeWidth: 2
    property color bgColor: Appearance.m3colors.m3secondaryContainer
    property color fgColor: Appearance.m3colors.m3primary
    property string icon: "battery_full"
    property int iconSize: Metrics.iconSize(20)
    property bool fillIcon: false

    width: 22
    height: 24
    onValueChanged: canvas.requestPaint()

    Canvas {
        id: canvas

        anchors.fill: parent
        onPaint: {
            const ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            const cx = width / 2;
            const cy = height / 2;
            const r = (width - root.strokeWidth) / 2;
            const start = -Math.PI / 2;
            const end = start + 2 * Math.PI * root.value;
            ctx.lineWidth = root.strokeWidth;
            ctx.lineCap = "round";
            // background ring
            ctx.strokeStyle = root.bgColor;
            ctx.beginPath();
            ctx.arc(cx, cy, r, 0, 2 * Math.PI);
            ctx.stroke();
            // progress ring
            ctx.strokeStyle = root.fgColor;
            ctx.beginPath();
            ctx.arc(cx, cy, r, start, end);
            ctx.stroke();
        }
    }

    // CENTER ICON
    MaterialSymbol {
        anchors.centerIn: parent
        icon: root.icon
        iconSize: root.iconSize
        font.variableAxes: {
            "FILL": root.fillIcon ? 1 : 0
        }
    }

}
