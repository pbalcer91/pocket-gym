import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Properties

Item {
	id: control

	implicitHeight: textFieldTimeRow.implicitHeight
	implicitWidth: textFieldTimeRow.implicitWidth

	property int hours: 0
	property int minutes: 0

	function getNumberWithPrefix(number) {
		if (number > 9)
			return number

		return ("0" + number)
	}

	RowLayout {
		id: textFieldTimeRow

		anchors.centerIn: parent

		PTextField {
			text: getNumberWithPrefix(control.hours)
			font: Fonts.clock

			Layout.minimumWidth: 70
			Layout.maximumWidth: 70

			horizontalAlignment: TextInput.AlignHCenter

			topPadding: 5
			bottomPadding: 5
			leftPadding: 5
			rightPadding: 5

			inputMethodHints: Qt.ImhTime
			validator: IntValidator {
				bottom: 0
				top: 23
			}

			maximumLength: 2

			onFocusChanged: {
				if (focus)
					return

				if (!acceptableInput) {
					text = getNumberWithPrefix(control.hours)
					focus = true
					return
				}

				control.hours = Number(text)
				text = getNumberWithPrefix(control.hours)
			}
		}

		PLabel {
			text: ":"
			font: Fonts.clock
			lineHeight: Fonts.clockHeight

			Layout.fillWidth: true

			Layout.fillHeight: true
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter
		}

		PTextField {
			text: getNumberWithPrefix(control.minutes)
			font: Fonts.clock

			Layout.minimumWidth: 70
			Layout.maximumWidth: 70

			horizontalAlignment: TextInput.AlignHCenter

			topPadding: 5
			bottomPadding: 5
			leftPadding: 5
			rightPadding: 5

			inputMethodHints: Qt.ImhTime
			validator: IntValidator {
				bottom: 0
				top: 59
			}

			maximumLength: 2

			onFocusChanged: {
				if (focus)
					return

				if (!acceptableInput) {
					text = getNumberWithPrefix(control.minutes)
					focus = true
					return
				}

				control.minutes = Number(text)
				text = getNumberWithPrefix(control.minutes)
			}
		}
	}
}
