import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	acceptButton.visible: false

	function isValid() {
		if (accountTypeGroup.checkState == Qt.Unchecked)
			return false

		if (userNameField.text == "")
			return false

		if (emailField.text == "")
			return false

		if (passwordField.text == "")
			return false

		if (rePasswordField.text == "")
			return false

		return true
	}

	PLabel {
		id: accountTypeInfo

		Layout.alignment: Qt.AlignHCenter
		Layout.topMargin: Properties.spacing
		Layout.bottomMargin: Properties.spacing

		text: "Wybierz typ użytkownika"
		font: Fonts.subTitle
		lineHeight: Fonts.subTitleHeight
	}

	RowLayout {
		Layout.fillWidth: true
		Layout.bottomMargin: Properties.margin
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

	PTextField {
		id: userNameField

		Layout.fillWidth: true
		Layout.bottomMargin: 10
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		label: "Nazwa użytkownika"
		placeholderText: "Nazwa użytkownika"

		onEditingFinished: {
			emailField.focus = true
		}
	}

	PTextField {
		id: emailField

		Layout.fillWidth: true
		Layout.bottomMargin: 10
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		label: "Email"
		placeholderText: "Email"

		inputMethodHints: Qt.ImhEmailCharactersOnly
		validator: RegularExpressionValidator {
			regularExpression: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
		}

		onEditingFinished: {
			passwordField.focus = true
		}
	}

	PTextField {
		id: passwordField

		Layout.fillWidth: true
		Layout.bottomMargin: 10
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		label: "Hasło"
		placeholderText: "Hasło"

		echoMode: TextInput.Password
		passwordCharacter: "\u2022"

		onEditingFinished: {
			rePasswordField.focus = true
		}
	}

	PTextField {
		id: rePasswordField

		Layout.fillWidth: true
		Layout.bottomMargin: 10
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		label: "Powtórz hasło"
		placeholderText: "Powtórz hasło"

		echoMode: TextInput.Password
		passwordCharacter: "\u2022"
	}

	PButton {
		id: acceptButton

		Layout.alignment: Qt.AlignHCenter

		text: "Załóż konto"

		enabled: isValid()

		flat: false

		onClicked: {
			modal.acceptButton.clicked()
		}
	}
}
