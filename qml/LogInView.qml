import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

Page {
	id: window

	background: Rectangle {
		color: Colors.background
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

			flat: false

			onClicked: {

			}
		}

		PLabel {
			id: registerInfo

			Layout.alignment: Qt.AlignHCenter

			text: "Nie masz jeszcze konta?"
			font: Fonts.caption
			lineHeight: Fonts.captionHeight
		}

		PButton {
			id: registerButton

			Layout.alignment: Qt.AlignHCenter

			text: "Załóż konto"

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
}
