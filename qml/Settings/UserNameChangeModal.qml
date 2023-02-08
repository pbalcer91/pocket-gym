import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	title: "Nazwa użytkownika"

	acceptButton.enabled: (userNameField.text != ""
						   && !usernameErrorLabel.visible)

	acceptButton.onClicked: {
		MainController.changeDatabaseUser(MainController.currentUser.id,
										  MainController.currentUser.email,
										  userNameField.text,
										  MainController.currentUser.isTrainer)

		notify("Zmieniono nazwę użytkownika")
	}

	PTextField {
		id: userNameField

		Layout.fillWidth: true
		Layout.bottomMargin: (usernameErrorLabel.visible ? Properties.spacing : Properties.margin)
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		label: "Nazwa użytkownika"
		placeholderText: "Nazwa użytkownika"

		onFocusChanged: {
			if (!focus && text != "") {
				MainController.checkIsUsernameAvailable(userNameField.text)
				return
			}

			if (state == "error")
				state = ""
		}
	}

	PLabel {
		id: usernameErrorLabel

		Layout.topMargin: -Properties.spacing
		Layout.bottomMargin: Properties.spacing
		Layout.leftMargin: 48
		Layout.fillWidth: true

		font: Fonts.info
		lineHeight: Fonts.infoHeight
		text: "Nazwa użytkownika jest już zajęta"

		visible: (userNameField.state == "error")
		color: Colors.error
	}
}
