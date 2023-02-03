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
		Layout.topMargin: 10
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		label: "Nazwa użytkownika"
		placeholderText: "Nazwa użytkownika"

		Keys.onReturnPressed: {
			emailField.focus = true
		}
	}

	PLabel {
		id: usernameErrorLabel

		Layout.topMargin: -Properties.spacing
		Layout.leftMargin: 48

		font: Fonts.info
		lineHeight: Fonts.infoHeight
		text: "Nazwa użytkownika jest już zajęta"

		visible: (userNameField.state == "error")
		color: Colors.error
	}

	PTextField {
		id: emailField

		Layout.fillWidth: true
		Layout.topMargin: (usernameErrorLabel.visible ? 0 : Properties.spacing)
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		label: "Email"
		placeholderText: "Email"

		inputMethodHints: Qt.ImhEmailCharactersOnly
		validator: RegularExpressionValidator {
			regularExpression: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
		}

		Keys.onReturnPressed: {
			passwordField.focus = true

			if (!acceptableInput) {
				state = "error"
				return
			}
		}

		onFocusChanged: {
			if (!focus && !acceptableInput) {
				state = "error"
				return
			}

			if (state == "error")
				state = ""
		}
	}

	PLabel {
		id: emailErrorLabel

		Layout.topMargin: -Properties.spacing
		Layout.leftMargin: 48

		font: Fonts.info
		lineHeight: Fonts.infoHeight
		text: "Niepoprawny format adresu email"

		visible: (emailField.state == "error")
		color: Colors.error
	}

	PTextField {
		id: passwordField

		Layout.fillWidth: true
		Layout.topMargin: (emailErrorLabel.visible ? 0 : Properties.spacing)
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		label: "Hasło"
		placeholderText: "Hasło"

		echoMode: TextInput.Password
		passwordCharacter: "\u2022"

		Keys.onReturnPressed: {
			rePasswordField.focus = true
		}
	}

	PTextField {
		id: rePasswordField

		Layout.fillWidth: true
		Layout.topMargin: 10
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		label: "Powtórz hasło"
		placeholderText: "Powtórz hasło"

		echoMode: TextInput.Password
		passwordCharacter: "\u2022"

		onFocusChanged: {
			if (!focus && passwordField.text != rePasswordField.text) {
				state = "error"
				return
			}

			if (state == "error")
				state = ""
		}
	}

	PLabel {
		id: repasswordErrorLabel

		Layout.topMargin: -Properties.spacing
		Layout.leftMargin: 48

		font: Fonts.info
		lineHeight: Fonts.infoHeight
		text: "Błędnie powtórzone hasło"

		visible: (rePasswordField.state == "error")
		color: Colors.error
	}

	PButton {
		id: acceptButton

		Layout.alignment: Qt.AlignHCenter
		Layout.topMargin: (repasswordErrorLabel.visible ? 0 : Properties.spacing)

		text: "Załóż konto"
		enabled: isValid()
		flat: false

		onClicked: {
			modal.acceptButton.clicked()
		}
	}
}
