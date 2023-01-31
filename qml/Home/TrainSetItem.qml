import QtQuick
import QtQuick.Layouts

import Components
import Properties

Item {
	id: form

	implicitWidth: content.implicitWidth + Properties.smallMargin
	implicitHeight: 120

	property alias indexLabel: setLabel.text
	property alias repeats: repeatsField.text
	property alias weight: weightField.text
	property alias isMax: isMaxLabel.visible

	property alias deleteButton: deleteButton

	property bool isActive: false

	signal repeatsValueChanged(var repeats)
	signal weightValueChanged(var weight)

	Rectangle {
		id: background

		anchors.fill: parent

		color: "transparent"
		radius: 20
		border.color: (isActive ? Colors.primary : Colors.primary_30)
		border.width: 1
	}

	PLabel {
		id: setLabel

		font: Fonts.info
		lineHeight: Fonts.infoHeight

		color: (isActive ? Colors.text : Colors.text_50)

		anchors.top: background.top
		anchors.topMargin: 4
		anchors.horizontalCenter: content.horizontalCenter
	}

	PLabel {
		id: isMaxLabel

		anchors.top: form.top
		anchors.topMargin: Properties.smallMargin

		x: reapeatsLabel.x + reapeatsLabel.width / 2 - width / 2 + Properties.smallMargin

		text: "MAX"
		horizontalAlignment: Text.AlignHCenter
		font: Fonts.captionBold
		lineHeight: Fonts.captionBoldHeight

		color: (isActive ? Colors.text : Colors.text_50)
	}

	RowLayout {
		id: content

		anchors.fill: parent

		anchors.leftMargin: Properties.smallMargin
		anchors.topMargin: Properties.margin

		spacing: 0

		ColumnLayout {
			Layout.fillHeight: true

			PLabel {
				id: reapeatsLabel

				Layout.alignment: Qt.AlignHCenter

				text: "Powtórzenia"
				font: Fonts.captionBold
				lineHeight: Fonts.captionBoldHeight

				color: (isActive ? Colors.text : Colors.text_50)
			}

			PTextField {
				id: repeatsField

				Layout.alignment: Qt.AlignHCenter
				maximumLength: 2
				inputMethodHints: Qt.ImhDigitsOnly
				horizontalAlignment: Text.AlignHCenter

				implicitWidth: 55
				enabled: isActive
				placeholderText: "0"

				onEditingFinished: {
					repeatsValueChanged(Number(repeatsField.text))
				}
			}
		}

		Item {
			width: 50

			PLabel {
				Layout.fillWidth: true
				horizontalAlignment: Text.AlignHCenter

				text: "x"
				font: Fonts.captionBold
				lineHeight: Fonts.captionBoldHeight

				color: (isActive ? Colors.text : Colors.text_50)
			}
		}

		ColumnLayout {
			Layout.fillHeight: true

			PLabel {
				Layout.alignment: Qt.AlignHCenter

				text: "Obciążenie"
				font: Fonts.captionBold
				lineHeight: Fonts.captionBoldHeight

				color: (isActive ? Colors.text : Colors.text_50)
			}

			RowLayout {
				PTextField {
					id: weightField

					Layout.alignment: Qt.AlignHCenter
					maximumLength: 3
					inputMethodHints: Qt.ImhDigitsOnly
					horizontalAlignment: Text.AlignHCenter

					implicitWidth: 70
					enabled: isActive
					text: "0"


					onEditingFinished: {
						if (Number(weightField.text) > 255)
							weightField.text = "255"

						weightValueChanged(Number(weightField.text))
					}
				}

				PLabel {
					text: "kg"
					font: Fonts.captionBold
					lineHeight: Fonts.captionBoldHeight

					color: (isActive ? Colors.text : Colors.text_50)
				}
			}
		}

		Item {
			Layout.fillWidth: true
		}

		PButton {
			id: deleteButton

			Layout.alignment: Qt.AlignVCenter
			Layout.rightMargin: Properties.smallMargin

			iconSize: 20
			color: Colors.error

			enabled: isActive

			icon.source: "qrc:/icons/ic_delete.svg"
		}
	}
}
