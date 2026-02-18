import qs.config
import qs.modules.components
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
	id: root

	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

	Connections {
		target: Pipewire.defaultAudioSink?.audio ?? null

		function onVolumeChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}

		function onMutedChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}
	}


	property bool shouldShowOsd: false

	Timer {
		id: hideTimer
		interval: 3000
		onTriggered: root.shouldShowOsd = false
	}

	LazyLoader {
		active: root.shouldShowOsd

		PanelWindow {
			visible: Config.runtime.overlays.volumeOverlayEnabled && Config.runtime.overlays.enabled
			WlrLayershell.namespace: "nucleus:brightnessOsd"
			exclusiveZone: 0
			anchors.top: Config.runtime.overlays.volumeOverlayPosition.startsWith("top")
            anchors.bottom: Config.runtime.overlays.volumeOverlayPosition.startsWith("bottom")
            anchors.right: Config.runtime.overlays.volumeOverlayPosition.endsWith("right")
            anchors.left: Config.runtime.overlays.volumeOverlayPosition.endsWith("left")
			margins {
                top: Metrics.margin(10)
                bottom: Metrics.margin(10)
                left: Metrics.margin(10)
                right: Metrics.margin(10)
            }
			implicitWidth: 460
			implicitHeight: 105
			color: "transparent"

			mask: Region {}

			Rectangle {
				anchors.fill: parent
				radius: Appearance.rounding.childish
				color: Appearance.m3colors.m3background

				RowLayout {
					spacing: Metrics.spacing(10)
					anchors {
						fill: parent
						leftMargin: Metrics.margin(15)
						rightMargin: Metrics.margin(25)
					}

					MaterialSymbol {
						property real volume: Pipewire.defaultAudioSink?.audio.muted ? 0 : Pipewire.defaultAudioSink?.audio.volume*100
													icon: {
								return volume > 50 ? "volume_up" : volume > 0 ? "volume_down" : 'volume_off'
							}
						iconSize: Metrics.iconSize(34);
					}

					ColumnLayout {
						implicitHeight: 40
						spacing: Metrics.spacing(5)
                        
						StyledText {
							animate: false
							text: Pipewire.defaultAudioSink?.description + " - " + (Pipewire.defaultAudioSink?.audio.muted ? 'Muted' : Math.floor(Pipewire.defaultAudioSink?.audio.volume*100) + '%')
							font.pixelSize: Metrics.fontSize(18)
						}

						StyledSlider {
							implicitHeight: 35
							value: (Pipewire.defaultAudioSink?.audio.muted ? 0 : Pipewire.defaultAudioSink?.audio.volume)*100
						}
					}
				}
			}
		}
	}
}