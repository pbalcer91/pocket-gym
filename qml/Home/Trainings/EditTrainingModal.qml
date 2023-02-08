import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	required property User user
	required property Training training

	property bool editMode: false

	title: (editMode ? "" : "Nowy trening")

	function validate() {
		if (nameField.text == "")
			return false

		return true
	}

	function fill() {
		nameField.text = training.name
	}

	function save() {
		if (!modal.validate())
			return

		if (editMode) {
			MainController.editDatabaseTraining(training.id,
												user,
												nameField.text,
												training.planId)

			notify("Zmieniono trening")
			return
		}

		MainController.addDatabaseTraining(user,
										   nameField.text,
										   training.planId)

		notify("Dodano trening")
	}

	Component.onCompleted: {
		modal.fill()
	}

	acceptButton.enabled: modal.validate()
	acceptButton.text: (editMode ? "Zapisz" : "Stwórz")
	acceptButton.onClicked: {
		modal.save()
	}

	onClosed: {
		if (editMode)
			return

		training.removeTraining()
	}

	rejectButton.text: "Anuluj"

	PTextField {
		id: nameField

		Layout.fillWidth: true
		Layout.bottomMargin: Properties.smallMargin

		label: "Nazwa"
		placeholderText: "Wpisz nazwę"
	}
}
