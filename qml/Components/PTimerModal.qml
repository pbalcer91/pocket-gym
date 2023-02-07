import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	title: "Odpoczynek"

	rejectButton.visible: false
	acceptButton.text: "Koniec przerwy"

	required property int breakTime
	property int beginningBreakTime

	Component.onCompleted: {
		timerLabel.text = breakTimeToString(breakTime)
		beginningBreakTime = breakTime
	}

	onBreakTimeChanged: {
		timerLabel.text = breakTimeToString(breakTime)

		if (beginningBreakTime != 0)
			colorArc.sweepAngle = 360 - (1 - breakTime / beginningBreakTime) * 360

		if (breakTime == 0)
			acceptButton.clicked()
	}

	function breakTimeToString(breakTime) {
		var minutes = Math.floor(breakTime / 60)
		if (minutes < 10)
			minutes = "0" + minutes

		var seconds = breakTime % 60
		if (seconds < 10)
			seconds = "0" + seconds

		return (minutes + ":" + seconds)
	}

	Timer {
		id: timer

		interval: 1000
		running: true
		repeat: true

		onTriggered: {
			breakTime--

			if (breakTime == 0)
				timer.stop()
		}
	}

	RowLayout {
		Layout.fillWidth: true
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		PButton {
			Layout.alignment: Qt.AlignVCenter
			text: "- 00:15"

			onClicked: {
				if (breakTime <= 15) {
					breakTime = 0
					return
				}

				breakTime -= 15
				beginningBreakTime -= 15
			}
		}

		Shape {
			width: 150
			height: 150

			ShapePath {
				fillColor: "transparent"
				strokeColor: Colors.primary
				strokeWidth: 7
				capStyle: ShapePath.RoundCap

				PathAngleArc {
					id: colorArc

					centerX: 75; centerY: 75
					radiusX: 75; radiusY: 75
					startAngle: -90
					sweepAngle: 360

					Behavior on sweepAngle {
						NumberAnimation {
							duration: 1000
						}
					}
				}
			}

			PLabel {
				id: timerLabel

				anchors.centerIn: parent

				horizontalAlignment: Text.AlignHCenter

				font: Fonts.tumblerMainLabel
				lineHeight: Fonts.tumblerMainLabelHeight

				color: Colors.primary
			}
		}

		PButton {
			Layout.alignment: Qt.AlignVCenter
			text: "+ 00:15"

			onClicked: {
				breakTime += 15
				beginningBreakTime += 15
			}
		}
	}
}
