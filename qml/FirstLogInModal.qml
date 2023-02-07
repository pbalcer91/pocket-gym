import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	rejectButton.visible: false
	acceptButton.text: "Rozpocznij"
	acceptButton.flat: false

	acceptButton.visible: opacity != 0.0
	acceptButton.opacity: 0.0

	animationDuration: 1000

	signal confirmed

	acceptButton.onClicked: {
		MainController.changeDatabaseUser(MainController.currentUser.id,
										  MainController.currentUser.email,
										  userNameField.text,
										  trainerAccountTypeButton.checked)
	}

	Component.onCompleted: {
		welcomeInfo.opacity = 1.0
	}

	Connections {
		target: MainController

		function onUsernameVerificationReceived(isAvailable) {
			if (!isAvailable) {
				userNameField.state = "error"
				return
			}

			acceptButton.opacity = 1.0
		}

		function onUserChanged() {
			confirmed()
		}
	}

	Timer {
		id: timer

		interval: 2000

		onTriggered: {
			welcomeAdditionalInfo.opacity = 1.0
		}
	}

	PLabel {
		id: welcomeLabel

		Layout.alignment: Qt.AlignHCenter
		horizontalAlignment: Text.AlignHCenter
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin
		Layout.fillWidth: true

		text: "Witaj w Pocket Gym!"
		font: Fonts.title
		lineHeight: Fonts.titleHeight
	}

	PLabel {
		id: welcomeInfo

		Layout.alignment: Qt.AlignHCenter
		horizontalAlignment: Text.AlignHCenter
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin
		Layout.fillWidth: true

		text: "Twórz plany treningowe, zapisuj i śledź ukończone treningi, zorganizuj swoją pracę jako trener personalny i wiele więcej. To wszystko zawsze pod ręką."
		font: Fonts.caption
		lineHeight: Fonts.captionHeight

		visible: opacity != 0.0
		opacity: 0.0

		onOpacityChanged: {
			if (opacity == 1.0)
				timer.start()
		}

		Behavior on opacity {
			NumberAnimation {
				duration: 1000
			}
		}
	}

	PLabel {
		id: welcomeAdditionalInfo

		Layout.alignment: Qt.AlignHCenter
		horizontalAlignment: Text.AlignHCenter
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin
		Layout.fillWidth: true

		text: "Na początek wybierz typ użytkownika. Będziesz mógł go później zmienić w ustawieniach."
		font: Fonts.caption
		lineHeight: Fonts.captionHeight

		visible: opacity != 0.0
		opacity: 0.0

		Behavior on opacity {
			NumberAnimation {
				duration: 1000
			}
		}
	}

	PLabel {
		id: accountTypeInfo

		Layout.alignment: Qt.AlignHCenter
		Layout.topMargin: Properties.spacing
		Layout.bottomMargin: Properties.spacing

		text: "Typ użytkownika"
		font: Fonts.subTitle
		lineHeight: Fonts.subTitleHeight

		visible: opacity != 0.0
		opacity: welcomeAdditionalInfo.opacity

		Behavior on opacity {
			NumberAnimation {
				duration: 1000
			}
		}
	}

	RowLayout {
		id: accountTypeRow
		Layout.fillWidth: true
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		spacing: 48

		visible: opacity != 0.0
		opacity: accountTypeInfo.opacity

		Behavior on opacity {
			NumberAnimation {
				duration: 1000
			}
		}

		ButtonGroup {
			id: accountTypeGroup

			onClicked: {
				usernameInfo.opacity = 1.0
			}
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

	PLabel {
		id: usernameInfo

		Layout.alignment: Qt.AlignHCenter
		horizontalAlignment: Text.AlignHCenter
		Layout.topMargin: Properties.spacing
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin
		Layout.fillWidth: true

		text: "Podaj unikalną nazwę użytkownika widoczną dla trenerów i Twoich podopiecznych"
		font: Fonts.caption
		lineHeight: Fonts.captionHeight

		visible: opacity != 0.0
		opacity: 0.0

		Behavior on opacity {
			NumberAnimation {
				duration: 1000
			}
		}
	}

	PTextField {
		id: userNameField

		Layout.fillWidth: true
		Layout.bottomMargin: (usernameErrorLabel.visible ? Properties.spacing : Properties.margin)
		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin

		label: "Nazwa użytkownika"
		placeholderText: "Nazwa użytkownika"
		visible: opacity != 0.0
		opacity: usernameInfo.opacity

		Behavior on opacity {
			NumberAnimation {
				duration: 1000
			}
		}

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
