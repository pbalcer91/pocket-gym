import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

Page {
	id: window

	background: Rectangle {
		color: Colors.background
	}

	signal loggedIn

	property real globalOpacity: 1.0

	Behavior on globalOpacity {
		NumberAnimation {
			duration: 500
		}
	}

	Connections {
		target: MainController

		function onCurrentUserReady() {
			if (MainController.currentUser.name == "") {
				modalLoader.setSource("qrc:/qml/FirstLogInModal.qml")
				return
			}

			window.loggedIn()
		}

		function onSignInSucceed(email) {
			MainController.getDatabaseUserByEmail(email)
			globalOpacity = 0.0
		}

		function onSignInFailed(errorCode) {
			switch(errorCode) {
			case MainController.SI_EMAIL_NOT_FOUND:
				console.log("BRAK KONTA - NOTIFICATION")
				return
			case MainController.SI_INVALID_PASSWORD:
				console.log("NIEPOPRAWNE HASLO - NOTIFICATION")
				return
			case MainController.SU_UNKNOWN_ERROR:
				console.log("NIEZNANY BLAD - NOTIFICATION")
				return
			case MainController.SI_USER_DISABLED:
				console.log("UZYTKOWNIK ZABLOKOWANY - NOTIFICATION")
				return
			}
		}
	}

	ColumnLayout {
		id: mainColumn

		width: parent.width

		anchors.centerIn: parent

		spacing: Properties.margin

		Image {
			id: logo

			Layout.alignment: Qt.AlignHCenter

			Layout.fillWidth: true
			Layout.leftMargin: 72
			Layout.rightMargin: 72

			height: implicitWidth

			source: "qrc:/images/logo.png"
			fillMode: Image.PreserveAspectFit
			smooth: true
		}

		PTextField {
			id: emailField

			Layout.fillWidth: true

			Layout.leftMargin: 48
			Layout.rightMargin: 48

			opacity: globalOpacity

			label: "Email"
			placeholderText: "Email"

			inputMethodHints: Qt.ImhEmailCharactersOnly

			onEditingFinished: {
				passwordField.focus = true
			}
		}

		PTextField {
			id: passwordField

			Layout.fillWidth: true

			Layout.leftMargin: 48
			Layout.rightMargin: 48

			opacity: globalOpacity

			label: "Hasło"
			placeholderText: "Hasło"

			echoMode: TextInput.Password
			passwordCharacter: "\u2022"
		}

		PButton {
			id: logInButton

			Layout.alignment: Qt.AlignHCenter
			Layout.bottomMargin: 50

			text: "Zaloguj"

			opacity: globalOpacity

			flat: false

			onClicked: {
				MainController.signInUser(emailField.text, passwordField.text)
			}
		}

		PLabel {
			id: registerInfo

			Layout.alignment: Qt.AlignHCenter

			opacity: globalOpacity

			text: "Nie masz jeszcze konta?"
			font: Fonts.caption
			lineHeight: Fonts.captionHeight
		}

		PButton {
			id: registerButton

			Layout.alignment: Qt.AlignHCenter

			text: "Załóż konto"

			opacity: globalOpacity

			onClicked: {
				loader.setSource("qrc:/qml/RegisterDialog.qml")
			}
		}
	}

	Loader {
		id: loader

		onLoaded: {
			loader.item.closed.connect(function() {
				if (!loader)
					return
				loader.source = ""
			})
			loader.item.open()
		}
	}

	Loader {
		id: modalLoader

		onLoaded: {
			modalLoader.item.closed.connect(function() {
				if (!modalLoader)
					return
				modalLoader.source = ""
			})

			modalLoader.item.confirmed.connect(function() {
				window.loggedIn()
			})

			modalLoader.item.open()
		}
	}

}
