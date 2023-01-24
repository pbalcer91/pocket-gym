import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	required property TrainingPlan plan

	property bool editMode: false

	title: (editMode ? "" : "Nowy plan treningowy")

	function validate() {
		if (nameField.text == "")
			return false

		return true
	}

	function fill() {
		nameField.text = plan.name
		descriptionField.text = plan.description
		isDefaultSwitch.checked = plan.isDefault
	}

	function save() {
		if (!modal.validate())
			return

		if (editMode) {
			MainController.editDatabaseTrainingPlan(plan.id,
													plan.owner,
													nameField.text,
													descriptionField.text,
													isDefaultSwitch.checked)

			return
		}

		MainController.addDatabaseTrainingPlan(plan.owner,
											   nameField.text,
											   descriptionField.text,
											   isDefaultSwitch.checked)
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

		plan.removeExercise()
	}


	rejectButton.text: "Anuluj"

	PTextField {
		id: nameField

		Layout.fillWidth: true
		Layout.bottomMargin: Properties.smallMargin

		label: "Nazwa"
		placeholderText: "Wpisz nazwę"
	}

	PTextField {
		id: descriptionField

		Layout.fillWidth: true
		Layout.bottomMargin: Properties.smallMargin

		isMultiline: true

		label: "Opis (opcjonalnie)"
		placeholderText: "Wpisz opis"
	}


	PSwitch {
		id: isDefaultSwitch

		Layout.fillWidth: true

		text: "Ustaw jako domyślny"
	}
}
