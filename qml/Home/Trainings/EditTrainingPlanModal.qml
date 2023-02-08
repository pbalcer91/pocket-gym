import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	required property User user
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
													user,
													nameField.text,
													descriptionField.text,
													isDefaultSwitch.checked)

			notify("Zmieniono plan treningowy")
			return
		}

		MainController.addDatabaseTrainingPlan(user,
											   nameField.text,
											   descriptionField.text,
											   isDefaultSwitch.checked)

		notify("Dodano plan treningowy")
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

		plan.removeTrainingPlan()
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

		text: "Ustaw jako aktywny"
	}
}
