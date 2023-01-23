import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

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
												training.owner,
												nameField.text,
												training.planId)

			return
		}

		MainController.addDatabaseTraining(training.owner,
										   nameField.text,
										   training.planId)
	}

	Component.onCompleted: {
		modal.fill()
	}

	acceptButton.enabled: modal.validate()
	acceptButton.text: (editMode ? "Zapisz" : "Stwórz")
	acceptButton.onClicked: {
		modal.save()
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
