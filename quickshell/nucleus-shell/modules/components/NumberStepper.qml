import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config

RowLayout {
    id: root

    property string label: ""
    property string description: ""
    property string prefField: ""
    property double step: 1.0
    property double minimum: -2.14748e+09
    property double maximum: 2.14748e+09

    property double value: readValue()

    function readValue() {
        if (!prefField)
            return 0

        var parts = prefField.split('.')
        var cur = Config.runtime

        for (var i = 0; i < parts.length; ++i) {
            if (cur === undefined || cur === null)
                return 0
            cur = cur[parts[i]]
        }

        var n = Number(cur)
        return isNaN(n) ? 0 : n
    }

    function writeValue(v) {
        if (!prefField)
            return

        var nv = Math.max(minimum, Math.min(maximum, v))
        nv = Number(nv.toFixed(2))
        Config.updateKey(prefField, nv)
        root.value = nv
    }

    spacing: Metrics.spacing(16)
    Layout.alignment: Qt.AlignVCenter

    ColumnLayout {
        spacing: Metrics.spacing(3)

        StyledText {
            text: root.label
            font.pixelSize: Metrics.fontSize(15)
        }

        StyledText {
            text: root.description
            font.pixelSize: Metrics.fontSize(11)
            opacity: 0.7
        }
    }

    Item { Layout.fillWidth: true }

    Rectangle {
        radius: Appearance.rounding.normal
        color: Appearance.m3colors.m3surfaceContainer
        implicitHeight: 48
        implicitWidth: 180

        RowLayout {
            anchors.fill: parent
            anchors.margins: 6
            spacing: Metrics.spacing(8)

            StyledButton {
                implicitWidth: 40
                implicitHeight: 36
                icon: "remove"
                iconSize: Metrics.iconSize(18)

                onClicked: writeValue(readValue() - step)
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 36
                radius: Appearance.rounding.small
                color: Appearance.m3colors.m3surface

                StyledText {
                    anchors.centerIn: parent
                    text: root.value.toFixed(2)
                    font.pixelSize: Metrics.fontSize(14)
                }
            }

            StyledButton {
                implicitWidth: 40
                implicitHeight: 36
                icon: "add"
                iconSize: Metrics.iconSize(18)

                onClicked: writeValue(readValue() + step)
            }
        }
    }
}
