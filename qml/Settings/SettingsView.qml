import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	implicitWidth: content.implicitWidth
	implicitHeight: content.implicitHeight

	Connections {
		target: MainController

		function onSettingsChanged() {
			trainerSectionVisibleSwitch.checked = MainController.trainerSectionVisible
		}
	}

	ScrollView {
		id: scroll

		anchors.fill: parent

		contentHeight: content.implicitHeight
		contentWidth: content.width

		ScrollBar.vertical.policy: ScrollBar.AlwaysOff

		Flickable {
			id: flickable

			anchors.fill: scroll

			clip: true
			boundsBehavior: Flickable.StopAtBounds
			contentWidth: content.width
			contentHeight: content.implicitHeight

			ColumnLayout {
				id: content

				width: flickable.width

				spacing: Properties.margin

				Rectangle {
					id: header

					Layout.alignment: Qt.AlignTop

					height: Properties.toolBarHeight
					Layout.fillWidth: true

					color: Colors.darkGray

					RowLayout {
						anchors.fill: parent

						anchors.leftMargin: Properties.margin
						anchors.rightMargin: Properties.margin

						PLabel {
							id: title

							font: Fonts.title
							lineHeight: Fonts.titleHeight

							color: Colors.text

							text: "Ustawienia"
						}

						Item {
							Layout.fillWidth: true
						}
					}
				}

				SettingsSection {
					label: "Konto"

					Rectangle {
						id: background

						implicitWidth: accountInfoContent.implicitWidth
						implicitHeight: accountInfoContent.implicitHeight

						Layout.fillWidth: true

						color: "transparent"
						radius: 20
						border.color: Colors.primary_30
						border.width: 2

						ColumnLayout {
							id: accountInfoContent

							anchors.fill: parent

							anchors.topMargin: Properties.smallMargin
							anchors.bottomMargin: Properties.smallMargin
							anchors.leftMargin: Properties.margin
							anchors.rightMargin: Properties.margin

							spacing: Properties.margin

							RowLayout {
								Layout.fillWidth: true

								PLabel {
									Layout.fillHeight: true

									text: "Użytkownik:"
									color: Colors.text

									font: Fonts.list
									lineHeight: Fonts.listHeight
								}

								Item {
									Layout.fillWidth: true
								}

								PLabel {
									Layout.fillHeight: true

									text: MainController.currentUser.name
									color: Colors.text

									horizontalAlignment: Text.AlignRight

									font: Fonts.subTitle
									lineHeight: Fonts.subTitleHeight
								}
							}

							RowLayout {
								Layout.fillWidth: true

								PLabel {
									Layout.fillHeight: true

									text: "Typ użytkownika:"
									color: Colors.text

									font: Fonts.list
									lineHeight: Fonts.listHeight
								}

								Item {
									Layout.fillWidth: true
								}

								PLabel {
									Layout.fillHeight: true

									text: (MainController.currentUser.isTrainer ? "Trener" : "Zwykły")
									color: Colors.text

									horizontalAlignment: Text.AlignRight

									font: Fonts.subTitle
									lineHeight: Fonts.subTitleHeight
								}
							}

							RowLayout {
								Layout.fillWidth: true

								PLabel {
									Layout.fillHeight: true

									text: "Email:"
									color: Colors.text

									font: Fonts.list
									lineHeight: Fonts.listHeight
								}

								Item {
									Layout.fillWidth: true
								}

								PLabel {
									Layout.fillHeight: true

									text: MainController.currentUser.email
									color: Colors.text

									horizontalAlignment: Text.AlignRight

									font: Fonts.caption
									lineHeight: Fonts.captionHeight
								}
							}
						}
					}

					PButton {
						id: changeusernameButton

						Layout.fillWidth: true

						text: "Zmień nazwę użytkownika"
						icon.source: "qrc:/icons/ic_chevronRight.svg"

						isBorder: true
						isRightIcon: true
						horizontalAlignment: Text.AlignLeft

						onClicked: {

						}
					}

					PButton {
						id: changeEmaildButton

						Layout.fillWidth: true

						text: "Zmień adres email"
						icon.source: "qrc:/icons/ic_chevronRight.svg"

						isBorder: true
						isRightIcon: true
						horizontalAlignment: Text.AlignLeft

						onClicked: {

						}
					}

					PButton {
						id: changePasswordButton

						Layout.fillWidth: true

						text: "Zmień hasło"
						icon.source: "qrc:/icons/ic_chevronRight.svg"

						isBorder: true
						isRightIcon: true
						horizontalAlignment: Text.AlignLeft

						onClicked: {

						}
					}

					PButton {
						id: changeAccountTypeButton

						Layout.fillWidth: true

						text: "Zmień typ konta"
						icon.source: "qrc:/icons/ic_chevronRight.svg"

						isBorder: true
						isRightIcon: true
						horizontalAlignment: Text.AlignLeft

						onClicked: {
							loader.setSource("qrc:/qml/Settings/AccountTypeChangeModal.qml")
						}
					}

					PButton {
						id: logoutButton

						Layout.alignment: Qt.AlignHCenter

						color: Colors.error

						text: "Wyloguj"

						onClicked: {
							showMessage({"message": "Czy na pewno chcesz się wylogować?",
											"acceptButton.text": "Tak",
											"rejectButton.text": "Nie",
											"acceptAction": function() {
												MainController.logOut()
											}
										})
						}
					}
				}

				SettingsSection {
					label: "Personalizacja"

					PSwitch {
						id: trainerSectionVisibleSwitch

						Layout.fillWidth: true

						text: "Sekcja trenera widoczna"

						onToggled: {
							MainController.trainerSectionVisible = checked
						}
					}
				}

				SettingsSection {
					label: "O aplikacji"

					PLabel {
						text: "Autor: Piotr Balcer"
					}

					PLabel {
						text: "Wersja: 0.2.1"
					}

					PLabel {
						text: "Licencje: CC0 - ikony i fonty"
					}
				}
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
