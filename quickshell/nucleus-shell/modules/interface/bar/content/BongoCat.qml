import QtQuick
import QtQuick.Layouts
import qs.services
import qs.config
import qs.modules.components

Item {
    id: clockContainer

    property string format: isVertical ? "hh\nmm\nAP" : "hh:mm • dd/MM"
    property bool isVertical: (ConfigResolver.bar(screen?.name ?? "").position === "left" || ConfigResolver.bar(screen?.name ?? "").position === "right")

    Layout.alignment: Qt.AlignVCenter
    implicitWidth: 37
    implicitHeight: 30

    AnimatedImage {
        id: art
        anchors.fill: parent
        source: Directories.assetsPath + "/gifs/bongo-cat.gif"
        cache: false        // this is important
        smooth: true        // smooooooth
        rotation: isVertical ? 270 : 0
    }


}
