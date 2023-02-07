import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	title: "Adres email"

	acceptButton.enabled: (emailField.text != ""
						   && !emailErrorLabel.visible)

	acceptButton.onClicked: {
		MainController.changeDatabaseUserEmail((emailField.text).toLowerCase())
	}

	rejectButton.onClicked: {
		modal.close()
	}

	autoCloseMode: false

	Connections {
		target: MainController

		function onUserEmailChangeFailed(errorCode) {
			switch(errorCode) {
				case MainController.EMAIL_EXISTS:
					console.log("EMAIL JUZ ISTNIEJE - NOTIFICATION")
					return
				case MainController.EMAIL_INVALID_ID_TOKEN:
					console.log("ZBYT WIELE PROB - NOTIFICATION")
					return
				case MainController.EMAIL_UNKNOWN_ERROR:
					console.log("NIEZNANY BLAD - NOTIFICATION")
					return
			}
		}

		function onUserEmailChanged(email) {
			MainController.changeDatabaseUser(MainController.currentUser.id,
											  email,
											  MainController.currentUser.name,
											  MainController.currentUser.isTrainer)
			modal.close()
		}
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
			if (!acceptableInput) {
				state = "error"
				return
			}

			focus = false
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
}
