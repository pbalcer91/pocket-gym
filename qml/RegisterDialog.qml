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
		if (emailField.text == "")
			return false

		if (passwordField.text == "")
			return false

		if (rePasswordField.text == "")
			return false

		if (emailField.state == "error")
			return false

		if (rePasswordField.state == "error")
			return false

		return true
	}

	Connections {
		target: MainController

		function onSignUpSucceed() {
			MainController.addDatabaseUser(emailField.text, false)
		}

		function onUserAdded() {
			MainController.signInUser(emailField.text, passwordField.text)
			modal.acceptButton.clicked()
		}

		function onSignUpFailed(errorCode) {
			switch(errorCode) {
			case MainController.SU_EMAIL_EXISTS:
				console.log("EMAIL JUZ ISTNIEJE - NOTIFICATION")
				return
			case MainController.SU_TOO_MANY_ATTEMPTS_TRY_LATER:
				console.log("ZBYT WIELE PROB - NOTIFICATION")
				return
			case MainController.SU_UNKNOWN_ERROR:
				console.log("NIEZNANY BLAD - NOTIFICATION")
				return
			}
		}
	}

	PLabel {
		id: label

		Layout.alignment: Qt.AlignHCenter
		Layout.topMargin: Properties.spacing
		Layout.bottomMargin: Properties.spacing

		text: "Stwórz konto"
		font: Fonts.subTitle
		lineHeight: Fonts.subTitleHeight
	}

	PTextField {
		id: emailField

		Layout.fillWidth: true
		Layout.topMargin: Properties.margin
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
		Layout.fillWidth: true

		font: Fonts.info
		lineHeight: Fonts.infoHeight
		text: "Niepoprawny format adresu email"

		visible: (emailField.state == "error")
		color: Colors.error
	}

	PTextField {
		id: passwordField

		Layout.fillWidth: true
		Layout.topMargin: (emailErrorLabel.visible ? Properties.spacing : Properties.margin)
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

	PButton {
		id: acceptButton

		Layout.alignment: Qt.AlignHCenter
		Layout.topMargin: (repasswordErrorLabel.visible ? Properties.spacing : Properties.margin)

		text: "Załóż konto"
		enabled: isValid()
		flat: false

		onClicked: {
			MainController.signUpUser(emailField.text, passwordField.text)
		}
	}
}
