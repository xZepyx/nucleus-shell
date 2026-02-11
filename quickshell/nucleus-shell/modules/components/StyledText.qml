pragma ComponentBehavior: Bound

import qs.config
import QtQuick

Text {
  id: root

  // from github.com/yannpelletier/twinshell with modifications

  property bool animate: true
  property string animateProp: "scale"
  property real animateFrom: 0
  property real animateTo: 1
  property int animateDuration: Metrics.chronoDuration("small")

  renderType: Text.NativeRendering
  textFormat: Text.PlainText
  color: Appearance.syntaxHighlightingTheme
  font.family: Metrics.fontFamily("main") 
  font.pixelSize: Metrics.fontSize("normal")

  Behavior on color {
    enabled: Config.runtime.appearance.animations.enabled
    ColorAnimation {
      duration: Metrics.chronoDuration("small")
      easing.type: Easing.BezierSpline
      easing.bezierCurve: Appearance.animation.curves.standard
    }
  }

  Behavior on text {
    enabled: Config.runtime.appearance.animations.enabled && root.animate 
    
    SequentialAnimation {
      Anim {
        to: root.animateFrom
        easing.bezierCurve: Appearance.animation.curves.standardAccel
      }
      PropertyAction {}
      Anim {
        to: root.animateTo
        easing.bezierCurve: Appearance.animation.curves.standardDecel
      }
    }
  }

  component Anim: NumberAnimation {
    target: root
    property: root.animateProp
    duration: root.animateDuration / 2
    easing.type: Easing.BezierSpline
  }
}