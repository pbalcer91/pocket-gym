import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	required property int day
	required property int month
	required property int year

	property alias name: nameField.text
	property alias hour: timePicker.hours
	property alias minute: timePicker.minutes

	property string eventId: ""

	autoCloseMode: false

	property bool editMode: false

	title: getDateString(day, month, year)

	acceptButton.enabled: nameField.text != ""
	acceptButton.onClicked: {
		if (!editMode) {
			MainController.addDatabaseEvent(MainController.currentUser,
											nameField.text,
											day,
											month + 1,
											year,
											timePicker.hours,
											timePicker.minutes)
			return
		}

		MainController.editDatabaseEvent(MainController.currentUser,
										 eventId,
										 nameField.text,
										 day,
										 month + 1,
										 year,
										 timePicker.hours,
										 timePicker.minutes)
	}

	rejectButton.onClicked: {
		modal.close()
	}

	Connections {
		target: MainController

		function onEventAdded() {
			notify("Dodano wydarzenie")
			modal.close()
		}

		function onEventChanged() {
			notify("Zmieniono wydarzenie")
			modal.close()
		}
	}

	function getDateString(day, month, year) {
		var dayString = ""

		if (day < 10)
			dayString += "0"
		dayString += day

		var monthString = ""

		if (month < 10)
			monthString += "0"
		monthString += month + 1

		return (dayString + "/" + monthString + "/" + year)
	}

	PLabel {
		id: timeLabel

		Layout.alignment: Qt.AlignHCenter

		text: "Godzina"

		font: Fonts.info
		lineHeight: Fonts.infoHeight
	}

	PTimePicker {
		id: timePicker

		Layout.alignment: Qt.AlignHCenter
		Layout.bottomMargin: Properties.margin	
	}

	PTextField {
		id: nameField

		Layout.fillWidth: true

		label: "Nazwa"
		placeholderText: "Wpisz nazwę"
	}

}
