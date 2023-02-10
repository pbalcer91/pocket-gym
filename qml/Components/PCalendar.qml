import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Properties

import pl.com.thesis

PCalendarForm {
	id: content

	onCurrentMonthChanged: {
		monthDaysModel.fillModel()
	}

	Component.onCompleted: {
		content.setToday()
	}

	onSelectedDayChanged: {
		MainController.getDatabaseEvents(MainController.currentUser, selectedDay, selectedMonth + 1, selectedYear)
	}

	function monthLength(month) {
		var date = new Date()

		date.setMonth(month + 1)
		date.setDate(0)

		return (date.getDate())
	}

	function firstWeekDayOfMonth(year, month) {
		var date = new Date(year, month, 1)

		return (date.getDay() === 0 ?  7 : date.getDay())
	}

	function setToday() {
		var now = new Date()

		content.nowYear = now.getFullYear()
		content.nowMonth = now.getMonth()
		content.nowDay = now.getDate()

		content.currentYear = content.nowYear
		content.currentMonth = content.nowMonth

		content.selectedYear = content.nowYear
		content.selectedMonth = content.nowMonth
		content.selectedDay = content.nowDay
	}

	currentMonthLabel: Qt.locale().standaloneMonthName(content.currentMonth)

	todayButton.onClicked: {
		setToday()
	}

	previousMonthButton.onClicked: {
		if (content.currentMonth != 0) {
			content.currentMonth -= 1
			return
		}

		content.currentYear -= 1
		content.currentMonth = 11
	}

	nextMonthButton.onClicked: {
		if (content.currentMonth !== 11) {
			content.currentMonth += 1;
			return
		}

		content.currentYear += 1
		content.currentMonth = 0
	}

	weekDaysRow.delegate: PLabel {
		width: GridView.view.cellWidth
		height: GridView.view.cellHeight

		font: Fonts.caption
		lineHeight: Fonts.captionHeight

		text: Qt.locale().standaloneDayName(modelData, Locale.ShortFormat)

		color: Colors.text

		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
	}

	weekDaysRow.model: [Locale.Monday, Locale.Tuesday,
		Locale.Wednesday, Locale.Thursday, Locale.Friday,
		Locale.Saturday, Locale.Sunday]

	ButtonGroup {
		id: daysButtonGroup
	}

	monthDaysGrid.delegate: Item {
		width: GridView.view.cellWidth
		height: GridView.view.cellHeight

		Rectangle {
			id: currentDayBackground

			width: Properties.calendarButtonSize + border.width * 2
			height:  Properties.calendarButtonSize + border.width * 2
			anchors.centerIn: parent

			visible: (content.nowYear === content.currentYear
					  && content.nowMonth === content.currentMonth
					  && content.nowDay === model.value)
			border.color: Colors.white
			border.width: 1
			color: "transparent"
			radius: height * 0.5
		}

		PButton {
			width: Properties.calendarButtonSize
			height:  Properties.calendarButtonSize
			radius: width / 2

			anchors.centerIn: parent

			text: model.value
			checkable: true

			visible: model.visible

			ButtonGroup.group: daysButtonGroup

			checked: (content.currentYear == content.selectedYear
					  && content.currentMonth == content.selectedMonth
					  && model.value === content.selectedDay)

			onClicked: {
				content.selectedYear = content.currentYear
				content.selectedMonth = content.currentMonth
				content.selectedDay = model.value
			}

			flat: !checked
			color: (checked ?
						Colors.black :
						Colors.primary)

		}
	}

	monthDaysGrid.model: PListModel {
		id: monthDaysModel

		fillModel: function() {
			monthDaysModel.clear()

			var firstDay = content.firstWeekDayOfMonth(content.currentYear, content.currentMonth)
			var length = content.monthLength(content.currentMonth)

			for (var i = 1; i < firstDay; i++) {
				monthDaysModel.append({"value": 0,
										  "visible": false})
			}

			for (var d = 1; d <= length; d++) {
				monthDaysModel.append({"value": d,
										  "visible": true})
			}
		}
	}
}
