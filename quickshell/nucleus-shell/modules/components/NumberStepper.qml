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
    property double minimum: -2.14748e+09 // Largest num I could find and type ig
    property double maximum: 2.14748e+09

    // Floating-point value
    property double value: readValue()

    function readValue() {
        if (!prefField)
            return 0;

        var parts = prefField.split('.');
        var cur = Config.runtime;

        for (var i = 0; i < parts.length; ++i) {
            if (cur === undefined || cur === null)
                return 0;
            cur = cur[parts[i]];
        }

        var n = Number(cur);
        return isNaN(n) ? 0 : n;
    }

    function writeValue(v) {
        if (!prefField)
            return;

        var nv = Math.max(minimum, Math.min(maximum, v));
        nv = Number(nv.toFixed(2)); // precision control (adjust if needed)
        Config.updateKey(prefField, nv);
    }

    spacing: Metrics.spacing(8)
    Layout.alignment: Qt.AlignVCenter

    ColumnLayout {
        spacing: Metrics.spacing(2)

        StyledText {
            text: root.label
            font.pixelSize: Metrics.fontSize(14)
        }

        StyledText {
            text: root.description
            font.pixelSize: Metrics.fontSize(10)
        }
    }

    Item { Layout.fillWidth: true }

    RowLayout {
        spacing: Metrics.spacing(6)

        StyledButton {
            text: "-"
            implicitWidth: 36
            onClicked: writeValue(readValue() - step)
        }

        StyledText {
            text: value.toFixed(2)
            font.pixelSize: Metrics.fontSize(14)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: 72
            elide: Text.ElideRight
        }

        StyledButton {
            text: "+"
            implicitWidth: 36
            onClicked: writeValue(readValue() + step)
        }
    }
}
