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

			ColumnLayout {
				id: mainColumn

				anchors.fill: parent
				anchors.margins: content.margin
				spacing: Properties.margin

				SettingsSection {
					label: "Ustawienia konta"

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
