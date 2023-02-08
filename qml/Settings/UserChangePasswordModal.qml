import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	title: "Hasło"

	acceptButton.enabled: isValid()

	acceptButton.onClicked: {
		MainController.changeDatabaseUserPassword(passwordField.text)
	}

	rejectButton.onClicked: {
		modal.close()
	}

	autoCloseMode: false

	function isValid() {
		if (passwordField.text == ""
				|| rePasswordField.text == "")
			return false

		if (passwordField.text != rePasswordField.text)
			return false

		if (passwordErrorLabel.visible
				| repasswordErrorLabel.visible)
			return false

		return true
	}

	Connections {
		target: MainController

		function onUserPasswordChangeFailed(errorCode) {
			switch(errorCode) {
				case MainController.PASSWORD_UNKNOWN_ERROR:
					notify("Operacja się nie udała")
					return
				case MainController.PASSWORD_INVALID_ID_TOKEN:
					notify("Błąd połączenia, zaloguj się ponownie")
					return
				case MainController.PASSWORD_WEAK_PASSWORD:
					notify("Zbyt słabe hasło")
					return
				}
		}

		function onUserPasswordChanged() {
			notify("Hasło zostało zmienione")
			modal.close()
		}
	}

	PTextField {
		id: passwordField

		Layout.fillWidth: true
		Layout.topMargin:Properties.margin
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		label: "Hasło"
		placeholderText: "Hasło"

		echoMode: TextInput.Password
		passwordCharacter: "\u2022"
		validator: RegularExpressionValidator {
			regularExpression: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$/
		}

		Keys.onReturnPressed: {
			rePasswordField.focus = true

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
		id: passwordErrorLabel

		Layout.topMargin: -Properties.spacing
		Layout.leftMargin: 48
		Layout.rightMargin: 48
		Layout.fillWidth: true

		font: Fonts.info
		lineHeight: Fonts.infoHeight
		text: "Hasło musi zawierać minimum 6 znaków, w tym co najmniej 1 małą literę, 1 wielką literę, 1 cyfrę i 1 znak specjalny."

		visible: (passwordField.state == "error")
		color: Colors.error
	}

	PTextField {
		id: rePasswordField

		Layout.fillWidth: true
		Layout.topMargin: (passwordErrorLabel.visible ? Properties.spacing : Properties.margin)
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
		Layout.fillWidth: true

		font: Fonts.info
		lineHeight: Fonts.infoHeight
		text: "Błędnie powtórzone hasło"

		visible: (rePasswordField.state == "error")
		color: Colors.error
	}
}
