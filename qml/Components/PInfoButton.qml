import QtQuick
import QtQuick.Layouts

import Components
import Properties

RowLayout {
	id: form

	property alias label: label.text

	ColumnLayout {
		id: infoContent

		PLabel {
			id: label

			color: button.color
		}
	}

	PButton {
		id: button

		flat: true
		icon.source: "qrc:/icons/ic_chevronRight.svg"

		Layout.alignment: Qt.AlignVCenter
	}
}
