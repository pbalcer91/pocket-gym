import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

Popup {
	id: popup

	parent: Overlay.overlay

	property alias message: messageLabel.text

	y: Properties.margin
	x: parent.width / 2 - contentWidth / 2 - padding
	z: 99

	focus: false
	modal: false
	closePolicy: Popup.NoAutoClose

	background: Rectangle {
		color: "transparent"
	}

	onOpened: {
		timer.start()
	}

	enter: Transition {
		ParallelAnimation {
			NumberAnimation {
				property: "opacity";
				from: 0.0;
				to: 1.0;
				duration: 500
			}
			NumberAnimation {
				property: "scale";
				from: 0.4;
				to: 1.0;
				easing.type: Easing.OutBack
				duration: 500
			}
		}
	}
	exit: Transition {
		ParallelAnimation {
			NumberAnimation {
				property: "opacity";
				from: 1.0
				to: 0.0;
				duration: 500
			}
			NumberAnimation {
				property: "scale";
				from: 1.0
				to: 0.8;
				duration: 500
			}
		}
	}

	Timer {
		id: timer
		interval: 2000

		onTriggered: {
			popup.close()
		}
	}

	Rectangle {
		id: pane

		radius: 20
		color: Colors.black_70

		implicitWidth: Math.min(popup.parent.width
								- popup.leftMargin - popup.rightMargin
								- popup.leftPadding - popup.rightPadding - 32,
								row.implicitWidth
								+ row.anchors.leftMargin
								+ row.anchors.rightMargin,
								400)

		implicitHeight: row.implicitHeight
						+ row.anchors.topMargin
						+ row.anchors.bottomMargin


		RowLayout {
			id: row
			anchors.fill: parent
			anchors.margins: 16

			PLabel {
				id: messageLabel

				text: ""
				font: Fonts.input
				lineHeight: Fonts.inputHeight
				color: Colors.text
				Layout.fillWidth: true

			}
		}
	}
}
