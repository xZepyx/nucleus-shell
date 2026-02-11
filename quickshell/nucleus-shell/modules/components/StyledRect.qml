import qs.config
import QtQuick

Rectangle {
  id: root

  Behavior on color {
    enabled: Config.runtime.appearance.animations.enabled
    ColorAnimation {
      duration: Metrics.chronoDuration(600)
      easing.type: Easing.BezierSpline
      easing.bezierCurve: Appearance.animation.curves.standard
    }
  }
}