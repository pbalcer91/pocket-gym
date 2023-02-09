import QtQuick
import QtQuick.Layouts

import Components
import Properties

Item {
	id: form

	implicitWidth: content.implicitWidth + Properties.margin + Properties.spacing
	implicitHeight: 72

	property alias label: label.text
	property alias detailsButton: detailsButton


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
		anchors.rightMargin: Properties.spacing

		PLabel {
			id: label

			Layout.fillHeight: true
			Layout.fillWidth: true

			text: ""
			color: Colors.text

			font: Fonts.list
			lineHeight: Fonts.listHeight
		}

		Item {
			Layout.fillWidth: true
		}

		PButton {
			id: detailsButton

			Layout.fillWidth: true

			icon.source: "qrc:/icons/ic_chevronRight.svg"
		}
	}
}
