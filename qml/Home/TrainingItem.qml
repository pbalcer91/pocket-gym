import QtQuick
import QtQuick.Layouts

import Components
import Properties

Item {
	id: form

	implicitWidth: content.implicitWidth + Properties.margin * 2
	implicitHeight: 60

	property alias label: label.text
	property alias detailsButton: detailsButton

	property bool editMode: false

	Rectangle {
		id: background

		anchors.fill: parent

		color: "transparent"
		radius: 20
		border.color: Colors.primary
		border.width: 1
	}

	RowLayout {
		id: content

		anchors.fill: parent

		anchors.topMargin: Properties.smallMargin
		anchors.bottomMargin: Properties.smallMargin
		anchors.leftMargin: Properties.margin

		spacing: 0

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
			id: detailsButton

			visible: !form.editMode

			icon.source: "qrc:/icons/ic_chevronRight.svg"
		}

		PButton {
			id: editButton

			visible: form.editMode

			icon.source: "qrc:/icons/ic_edit.svg"
		}

		PButton {
			id: removeButton

			visible: form.editMode

			icon.source: "qrc:/icons/ic_delete.svg"
		}
	}
}
