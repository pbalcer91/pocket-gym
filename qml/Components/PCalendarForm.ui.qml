import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Properties

ColumnLayout {
	id: form

	property int currentYear
	property int currentMonth
	property int currentDay

	property int nowYear
	property int nowMonth
	property int nowDay

	property alias previousMonthButton: previousMonth
	property alias nextMonthButton: nextMonth

	property alias currentMonthLabel: currentMonth.text

	property alias weekDaysRow: weekDaysRow
	property alias monthDaysGrid: monthDaysGrid

	property alias todayButton: todayButton

	Rectangle {
		id: header

		height: Properties.toolBarHeight
		width: parent.width

		color: Colors.darkGray

		RowLayout {
			anchors.fill: parent

			anchors.leftMargin: Properties.margin
			anchors.rightMargin: Properties.margin

			PLabel {
				id: title

				font: Fonts.title
				lineHeight: Fonts.titleHeight

				color: Colors.text

				text: "Kalendarz"
			}

			Item {
				Layout.fillWidth: true
			}

			PButton {
				id: todayButton

				height: title.implicitHeight
				width: implicitHeight

				isBorder: true
				text: form.nowDay

				radius: Properties.radius
			}
		}
	}

	RowLayout {
		id: monthRow

		Layout.topMargin: Properties.smallMargin
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		PButton {
			id: previousMonth

			flat: true
			icon.source: "qrc:/icons/ic_chevronLeft.svg"

			Layout.alignment: Qt.AlignVCenter
		}

		Item {
			Layout.fillWidth: true
		}

		PLabel {
			id: currentMonth

			Layout.alignment: Qt.AlignVCenter

			font: Fonts.subTitle
			lineHeight: Fonts.subTitleHeight

			color: Colors.text
		}

		PLabel {
			id: currentYear

			Layout.alignment: Qt.AlignVCenter

			font: Fonts.subTitle
			lineHeight: Fonts.subTitleHeight

			text: form.currentYear

			color: Colors.text
		}

		Item {
			Layout.fillWidth: true
		}

		PButton {
			id: nextMonth

			flat: true
			icon.source: "qrc:/icons/ic_chevronRight.svg"

			Layout.alignment: Qt.AlignVCenter
		}
	}

	GridView {
		id: weekDaysRow

		topMargin: Properties.smallMargin
		leftMargin: 0
		bottomMargin: 0
		rightMargin: 0

		boundsBehavior: Flickable.StopAtBounds

		implicitWidth: monthDaysGrid.implicitWidth
		implicitHeight: contentHeight + topMargin + bottomMargin

		cellWidth: monthDaysGrid.cellWidth
		cellHeight: Properties.calendarButtonSize
	}

	GridView {
		id: monthDaysGrid

		topMargin: 0
		leftMargin: 0
		bottomMargin: 0
		rightMargin: 0

		cellWidth: (parent.width / 7).toFixed()
		cellHeight: cellWidth

		implicitWidth: cellWidth * 7
		implicitHeight: contentHeight + topMargin + bottomMargin

		boundsBehavior: Flickable.StopAtBounds
	}
}
