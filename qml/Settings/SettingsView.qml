import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

Item {
	id: content

	property int margin: Properties.margin

	ScrollView {
		id: scroll

		anchors.fill: parent

		Flickable {
			id: flickable

			clip: (contentHeight > height)
			boundsBehavior: Flickable.StopAtBounds

			contentWidth: width
			contentHeight: mainColumn.implicitHeight + content.margin * 2

			Component.onCompleted: {
				console.log("CONTENT HEIGHT:", content.height)
				console.log("CONTENT WIDTH:", content.width)

				console.log("SCROLL HEIGHT:", scroll.height)
				console.log("SCROLL WIDTH:", scroll.width)

				console.log("FLICKABLE HEIGHT:", height)
				console.log("FLICKABLE WIDTH:", width)

				console.log("FLICKABLE CONTENT HEIGHT:", contentHeight)
				console.log("FLICKABLE CONTENT WIDTH:", contentWidth)
			}

			ColumnLayout {
				id: mainColumn

				anchors.fill: parent
				anchors.margins: content.margin
				spacing: Properties.margin

				Component.onCompleted: {
					console.log("COLUMN WIDTH:", mainColumn.width)
				}

				SettingsSection {
					label: "Ustawienia konta"

					Component.onCompleted: {
						console.log("SECTION HEAD WIDTH:", width)
					}

					PInfoButton {
						Layout.fillWidth: true

						label: "Nazwa użytkownika"
					}

					PLabel {
						text: "Adres email"
					}

					PLabel {
						text: "Zmień hasło"
					}

					PLabel {
						text: "Typ konta"
					}

					// model (label, url, isButton)
					// + konkretne przyciski w ListView / repeaterze w settingsSection
				}

				SettingsSection {
					label: "Ustawienia treningów"

					PLabel {
						text: "Czas przerw"
					}

					PLabel {
						text: "Jednostki"
					}

					PLabel {
						text: "Ilość treningów w tygodniu"
					}
				}

				SettingsSection {
					label: "Ustawienia aplikacji"

					PLabel {
						text: "Powiadomienia"
					}

					PLabel {
						text: "Tryb ciemny"
					}

					PLabel {
						text: "Kolor motywu"
					}

					PLabel {
						text: "Język"
					}
				}

				SettingsSection {
					label: "O aplikacji"

					PLabel {
						text: "Autor: Piotr Balcer"
					}

					PLabel {
						text: "Wersja: 0.1.0"
					}

					PLabel {
						text: "Licencje: CC0 - ikony i fonty"
					}
				}
			}
		}
	}
}
