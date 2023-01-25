import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	title: "Nowy pomiar ciała"

	//TODO: Zrobic z tego repeatera z modelem

	function validate() {
		return true
	}

	function save() {
		if (!modal.validate())
			return

		MainController.addDatabaseMeasurement(Number(weightField.text),
											  Number(chestField.text),
											  Number(shouldersField.text),
											  Number(armField.text),
											  Number(forearmField.text),
											  Number(waistField.text),
											  Number(hipsField.text),
											  Number(peaceField.text),
											  Number(calfField.text))
	}

	acceptButton.enabled: modal.validate()
	acceptButton.text: "Dodaj"
	acceptButton.onClicked: {
		modal.save()
	}

	rejectButton.text: "Anuluj"

	RowLayout {
		id: weightRow

		Layout.fillWidth: true
		Layout.bottomMargin: Properties.spacing

		PLabel {
			text: "Waga (kg)"
		}

		Item {
			Layout.fillWidth: true
		}

		PTextField {
			id: weightField

			implicitWidth: modal.width / 5

			inputMethodHints: Qt.ImhDigitsOnly
			maximumLength: 5

			placeholderText: "0"

			onEditingFinished: {
				chestField.focus = true
			}
		}
	}

	RowLayout {
		id: chestRow

		Layout.fillWidth: true
		Layout.bottomMargin: Properties.spacing

		PLabel {
			text: "Obwód klatki piersiowej (cm)"
		}

		Item {
			Layout.fillWidth: true
		}

		PTextField {
			id: chestField

			implicitWidth: modal.width / 5

			inputMethodHints: Qt.ImhDigitsOnly
			maximumLength: 5

			placeholderText: "0"

			onEditingFinished: {
				shouldersField.focus = true
			}
		}
	}

	RowLayout {
		id: shouldersRow

		Layout.fillWidth: true
		Layout.bottomMargin: Properties.spacing

		PLabel {
			text: "Obwód barków (cm)"
		}

		Item {
			Layout.fillWidth: true
		}

		PTextField {
			id: shouldersField

			implicitWidth: modal.width / 5

			inputMethodHints: Qt.ImhDigitsOnly
			maximumLength: 5

			placeholderText: "0"

			onEditingFinished: {
				armField.focus = true
			}
		}
	}

	RowLayout {
		id: armRow

		Layout.fillWidth: true
		Layout.bottomMargin: Properties.spacing

		PLabel {
			text: "Obwód ramienia (cm)"
		}

		Item {
			Layout.fillWidth: true
		}

		PTextField {
			id: armField

			implicitWidth: modal.width / 5

			inputMethodHints: Qt.ImhDigitsOnly
			maximumLength: 5

			placeholderText: "0"

			onEditingFinished: {
				forearmField.focus = true
			}
		}
	}

	RowLayout {
		id: forearmRow

		Layout.fillWidth: true
		Layout.bottomMargin: Properties.spacing

		PLabel {
			text: "Obwód przedramienia (cm)"
		}

		Item {
			Layout.fillWidth: true
		}

		PTextField {
			id:forearmField

			implicitWidth: modal.width / 5

			inputMethodHints: Qt.ImhDigitsOnly
			maximumLength: 5

			placeholderText: "0"

			onEditingFinished: {
				waistField.focus = true
			}
		}
	}

	RowLayout {
		id: waistRow

		Layout.fillWidth: true
		Layout.bottomMargin: Properties.spacing

		PLabel {
			text: "Obwód talii (cm)"
		}

		Item {
			Layout.fillWidth: true
		}

		PTextField {
			id: waistField

			implicitWidth: modal.width / 5

			inputMethodHints: Qt.ImhDigitsOnly
			maximumLength: 5

			placeholderText: "0"

			onEditingFinished: {
				hipsField.focus = true
			}
		}
	}

	RowLayout {
		id: hipsRow

		Layout.fillWidth: true
		Layout.bottomMargin: Properties.spacing

		PLabel {
			text: "Obwód bioder (cm)"
		}

		Item {
			Layout.fillWidth: true
		}

		PTextField {
			id: hipsField

			implicitWidth: modal.width / 5

			inputMethodHints: Qt.ImhDigitsOnly
			maximumLength: 5

			placeholderText: "0"

			onEditingFinished: {
				peaceField.focus = true
			}
		}
	}

	RowLayout {
		id: peaceRow

		Layout.fillWidth: true
		Layout.bottomMargin: Properties.spacing

		PLabel {
			text: "Obwód uda (cm)"
		}

		Item {
			Layout.fillWidth: true
		}

		PTextField {
			id: peaceField

			implicitWidth: modal.width / 5

			inputMethodHints: Qt.ImhDigitsOnly
			maximumLength: 5

			placeholderText: "0"

			onEditingFinished: {
				calfField.focus = true
			}
		}
	}

	RowLayout {
		id: calfRow

		Layout.fillWidth: true
		Layout.bottomMargin: Properties.spacing

		PLabel {
			text: "Obwód łydki (cm)"
		}

		Item {
			Layout.fillWidth: true
		}

		PTextField {
			id: calfField

			implicitWidth: modal.width / 5

			inputMethodHints: Qt.ImhDigitsOnly
			maximumLength: 5

			placeholderText: "0"
		}
	}
}
