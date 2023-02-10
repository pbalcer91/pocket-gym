import QtQuick
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	implicitWidth: content.implicitWidth + Properties.margin * 2
	implicitHeight: 72

	property alias name: nameLabel.text
	property alias date: dateLabel.text

	property alias editButton: editButton
	property alias removeButton: removeButton

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
		anchors.rightMargin: Properties.smallMargin

		ColumnLayout {
			Layout.fillHeight: true
			Layout.fillWidth: true

			PLabel {
				id: dateLabel

				Layout.fillHeight: true

				text: ""
				color: Colors.primary

				font: Fonts.subTitle
				lineHeight: Fonts.subTitleHeight
			}

			PLabel {
				id: nameLabel

				Layout.fillHeight: true

				text: ""
				color: Colors.text

				font: Fonts.list
				lineHeight: Fonts.listHeight
			}
		}

		Item {
			Layout.fillWidth: true
		}

		PButton {
			id: editButton

			icon.source: "qrc:/icons/ic_edit.svg"

			Layout.rightMargin: Properties.spacing
		}

		PButton {
			id: removeButton

			icon.source: "qrc:/icons/ic_delete.svg"
			color: Colors.error
		}
	}
}
