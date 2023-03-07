import QtQuick
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	implicitWidth: content.implicitWidth
	implicitHeight: content.implicitHeight

	property string trainerUsername: ""
	property string trainerId: ""

	property alias chatButton: chatButton

	Rectangle {
		id: background

		anchors.fill: parent

		color: "transparent"
		radius: 20
		border.color: Colors.primary_30
		border.width: 2
	}

	ColumnLayout {
		id: content

		anchors.fill: parent

		anchors.topMargin: Properties.smallMargin
		anchors.bottomMargin: Properties.smallMargin
		anchors.leftMargin: Properties.margin
		anchors.rightMargin: Properties.margin

		spacing: Properties.margin

		RowLayout {
			Layout.fillWidth: true

			Layout.topMargin: Properties.margin

			PLabel {
				Layout.fillHeight: true

				text: "Twój trener:"
				color: Colors.text

				font: Fonts.list
				lineHeight: Fonts.listHeight
			}

			Item {
				Layout.fillWidth: true
			}

			PLabel {
				Layout.fillHeight: true

				text: trainerUsername
				color: Colors.text

				horizontalAlignment: Text.AlignRight

				font: Fonts.subTitle
				lineHeight: Fonts.subTitleHeight
			}
		}

		RowLayout {
			Layout.fillWidth: true

			PButton {
				id: removeButton

				text: "Zrezygnuj"

				color: Colors.error

				onClicked: {
					showMessage({"message": "Czy na pewno chcesz zakończyć współpracę z trenerem? Nie będziesz miał możliwości wysłania do niego wiadomości, a historia rozmów zostanie usunięta.",
									"acceptButton.text": "Tak",
									"rejectButton.text": "Nie",
									"acceptAction": function() {
										MainController.deleteTrainerFromUser(trainerId)
										notify("Zakończono współpracę z trenerem")
									}
								})
				}
			}

			Item {
				Layout.fillWidth: true
			}

			PButton {
				id: chatButton

				text: "Wyślij wiadomość"				
			}
		}
	}
}
