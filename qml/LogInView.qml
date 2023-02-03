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

	property real globalOpacity: 0.0

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

	Component.onCompleted: {
		logo.opacity = 1.0
	}

	PBusyIndicator {
		size: 350

		onSpinnersStopped: {
			MainController.autoLogIn()
			opacity = 0.0
			logo.state = "ready"
			devLabel.visible = false
			globalOpacity = 1.0
		}
	}

	Image {
		id: logo

		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.right: parent.right

		anchors.topMargin: 72
		anchors.bottomMargin: 72
		anchors.leftMargin: 72
		anchors.rightMargin: 72

		opacity: 0.0

		source: "qrc:/images/logo.png"
		fillMode: Image.PreserveAspectFit
		smooth: true

		transitions: Transition {
			AnchorAnimation {
				duration: 1000
			}
		}

		Behavior on opacity {
			NumberAnimation {
				duration: 2000
			}
		}

		states: State {
			name: "ready"
			AnchorChanges {
				target: logo

				anchors.top: logo.parent.top
				anchors.verticalCenter: undefined
			}
		}
	}

	PLabel {
		id: devLabel

		anchors.bottom: parent.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottomMargin: 72
		horizontalAlignment: Text.AlignHCenter

		font: Fonts.info
		lineHeight: Fonts.infoHeight

		text: "Created by\nPiotr Balcer"
	}

	ColumnLayout {
		id: mainColumn

		width: parent.width

		anchors.top: logo.bottom
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right

		anchors.topMargin: 72
		anchors.bottomMargin: 72

		spacing: Properties.margin

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
