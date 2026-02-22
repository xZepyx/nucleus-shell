import qs.config
import QtQuick
import QtQuick.Layouts

Item {
    id: contentCard

    /* ---- layout-safe implicit sizing ---- */
    implicitWidth: parent ? parent.width : 600
    implicitHeight: contentArea.implicitHeight + verticalPadding

    default property alias content: contentArea.data
    property alias color: bg.color
    property alias radius: bg.radius
    property int cardMargin: Metrics.margin("normal")
    property int cardSpacing: Metrics.margin("small")
    property int verticalPadding: Metrics.margin("verylarge")
    property bool useAnims: true

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Metrics.radius("normal")
        color: Appearance.colors.colLayer1

        Behavior on color {
            enabled: Config.runtime.appearance.animations.enabled
            ColorAnimation {
                duration: !contentCard.useAnims ? 0 : Metrics.chronoDuration("fast")
            }
        }
    }

    ColumnLayout {
        id: contentArea
        anchors.fill: parent
        anchors.margins: cardMargin
        spacing: cardSpacing
    }
}
