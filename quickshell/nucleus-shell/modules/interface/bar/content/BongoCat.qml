import QtQuick
import QtQuick.Layouts
import qs.services
import qs.config
import qs.modules.widgets

Item {
    id: clockContainer

    property string format: isVertical ? "hh\nmm\nAP" : "hh:mm • dd/MM"
    property bool isVertical: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right")

    Layout.alignment: Qt.AlignVCenter
    implicitWidth: 42
    implicitHeight: 35

    AnimatedImage {
        id: art
        anchors.fill: parent
        source: "../../../../assets/gifs/bongo-cat.gif"
        cache: false        // this is important
        smooth: true        // smooooooth
        rotation: isVertical ? 270 : 0
    }


}
