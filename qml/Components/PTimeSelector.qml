import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Properties

Item {
	id: root

	implicitWidth: mainRow.implicitWidth
	implicitHeight: mainRow.implicitHeight

	property int minutes: 0
	property int seconds: 0

	function getTimeDescription() {
		var result = ""

		if (minutesTumbler.currentIndex < 10)
			result += "0"

		result += minutesTumbler.currentIndex + ":"

		if (secondsTumbler.currentIndex == 0)
			result += "0"

		result += secondsTumbler.currentIndex * 15 + " min"

		return result
	}

	function getPrefix(value) {
		var prefix = ""

		if (value < 10)
			prefix += "0"

		return prefix
	}

	GridLayout {
		id: mainRow

		anchors.centerIn: parent

		columnSpacing: Properties.spacing

		columns: 3
		rows: 2

		PLabel {
			text: "minuty"

			Layout.column: 0
			Layout.row: 0
			Layout.alignment: Qt.AlignCenter
			Layout.topMargin: 12

			color: Colors.primary
			font: Fonts.info
			lineHeight: Fonts.infoHeight
		}

		PLabel {
			text: "sekundy"

			Layout.column: 2
			Layout.row: 0
			Layout.alignment: Qt.AlignCenter
			Layout.topMargin: 12

			color: Colors.primary
			font: Fonts.info
			lineHeight: Fonts.infoHeight
		}

		PTumbler {
			id: minutesTumbler

			Layout.column: 0
			Layout.row: 1
			Layout.alignment: Qt.AlignCenter

			currentIndex: root.minutes

			listModel: PListModel {
				fillModel: function() {
					for (var i = 0; i <= 10; ++i)
						append({"value": i,
								   "description": getPrefix(i) + i
							   });
				}
			}

			textRole: "description"

			onCurrentIndexChanged: {
				root.minutes = currentIndex
			}
		}

		PLabel {
			text: ":"

			Layout.column: 1
			Layout.row: 1
			Layout.alignment: Qt.AlignCenter

			font: Fonts.tumblerMainLabel
			lineHeight: Fonts.tumblerMainLabelHeight
		}

		PTumbler {
			id: secondsTumbler

			Layout.column: 2
			Layout.row: 1
			Layout.alignment: Qt.AlignCenter

			currentIndex: root.seconds

			listModel: PListModel {
				fillModel: function() {
					for (var i = 0; i < 60; i+=15)
						append({"value": i,
								   "description": getPrefix(i) + i
							   });
				}
			}

			textRole: "description"

			onCurrentIndexChanged: {
				root.seconds = currentIndex * 15
			}
		}
	}
}
