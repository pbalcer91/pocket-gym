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

	property bool isConfirmed

	property alias rejectButton: rejectButton
	property alias acceptButton: acceptButton
	property alias detailsButton: detailsButton

	Rectangle {
		id: background

		anchors.fill: parent

		color: "transparent"
		radius: 20
		border.color: (isConfirmed ?
						   Colors.primary_30
						 : Colors.primary)
		border.width: 2
	}

	PLabel {
		Layout.fillHeight: true

		text: "oczekuje na zatwierdzenie"
		color: Colors.text

		visible: !isConfirmed

		anchors.top: background.top
		anchors.horizontalCenter: background.horizontalCenter
		anchors.topMargin: 2

		font: Fonts.info
		lineHeight: Fonts.infoHeight
	}

	RowLayout {
		id: content

		anchors.fill: parent

		anchors.topMargin: Properties.smallMargin
		anchors.bottomMargin: Properties.smallMargin
		anchors.leftMargin: Properties.margin
		anchors.rightMargin: Properties.smallMargin

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
			id: acceptButton

			Layout.rightMargin: Properties.spacing

			icon.source: "qrc:/icons/ic_check.svg"
			color: Colors.accept

			visible: !isConfirmed
		}

		PButton {
			id: rejectButton

			icon.source: "qrc:/icons/ic_close.svg"
			color: Colors.error

			iconSize: 20

			visible: !isConfirmed
		}

		PButton {
			id: detailsButton

			icon.source: "qrc:/icons/ic_chevronRight.svg"

			visible: isConfirmed
		}
	}
}
