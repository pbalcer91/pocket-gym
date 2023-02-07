import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	title: "Typ użytkownika"

	Component.onCompleted: {
		if (MainController.currentUser.isTrainer) {
			trainerAccountTypeButton.checked = true
			return
		}

		regularAccountTypeButton.checked = true
	}

	acceptButton.onClicked: {
		// TODO: zmianma typu uzytkownika
	}

	RowLayout {
		id: accountTypeRow
		Layout.fillWidth: true
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		spacing: 48

		ButtonGroup {
			id: accountTypeGroup
		}

		PButton {
			id: regularAccountTypeButton
			Layout.fillWidth: true

			implicitWidth: modal.width / 2
			isBorder: true
			text: "Zwykły"
			ButtonGroup.group: accountTypeGroup
			checkable: true

			flat: (!checked)
		}

		PButton {
			id: trainerAccountTypeButton
			Layout.fillWidth: true

			implicitWidth: modal.width / 2
			isBorder: true
			text: "Trener"
			ButtonGroup.group: accountTypeGroup
			checkable: true

			flat: (!checked)
		}
	}
}
