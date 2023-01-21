import QtQuick
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	implicitWidth: content.implicitWidth + Properties.margin * 2
	implicitHeight: 56

	property TrainingPlan trainingPlan

	property alias label: label.text
	property alias detailsButton: detailsButton

	property bool isSelected: false

	Rectangle {
		id: background

		anchors.fill: parent

		color: "transparent"
		radius: 20
		border.color: Colors.primary_30
		border.width: 2
	}

	RowLayout {
		id: content

		anchors.fill: parent

		anchors.topMargin: Properties.smallMargin
		anchors.bottomMargin: Properties.smallMargin
		anchors.leftMargin: Properties.margin

		ColumnLayout {
			spacing: 0

			PLabel {
				id: label

				Layout.fillHeight: true

				text: ""
				color: Colors.text

				font: Fonts.list
				lineHeight: Fonts.listHeight
			}

			PLabel {
				id: info

				Layout.fillHeight: true

				Layout.topMargin: 8

				text: "Aktywny plan"
				color: Colors.primary

				visible: form.isSelected

				font: Fonts.info
				lineHeight: Fonts.infoHeight
			}
		}

		Item {
			Layout.fillWidth: true
		}

		PButton {
			id: detailsButton

			icon.source: "qrc:/icons/ic_chevronRight.svg"
		}
	}
}
