import QtQuick
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	implicitWidth: content.implicitWidth + Properties.margin * 2
	implicitHeight: 72

	property alias label: label.text
	property alias inviteButton: inviteButton

	property bool isSelected

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

		PLabel {
			id: label

			Layout.fillHeight: true

			text: ""
			color: Colors.text

			font: Fonts.list
			lineHeight: Fonts.listHeight
		}

		Item {
			Layout.fillWidth: true
		}

		PButton {
			id: inviteButton

			icon.source: (form.isSelected ?
							  "qrc:/icons/ic_delete.svg"
							: "qrc:/icons/ic_add.svg")
		}
	}
}
