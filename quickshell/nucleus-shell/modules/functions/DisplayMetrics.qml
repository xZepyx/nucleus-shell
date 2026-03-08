pragma Singleton
import Quickshell
import QtQuick
import qs.services

Singleton {
    // Prefer Compositor scales because niri and hyprland have diffrent scaling factors
    function scaledWidth(ratio) {
        return Compositor.screenW * ratio / Compositor.screenScale
    }

    function scaledHeight(ratio) {
        return Compositor.screenH * ratio / Compositor.screenScale
    }
}
