import QtQuick
import QtQuick.Layouts

import Components
import Properties

ColumnLayout {
	id: form

	property alias label: label.text

	default property alias content: mainContent.data

	Layout.fillWidth: true

	Layout.leftMargin: Properties.margin
	Layout.rightMargin: Properties.margin

	PLabel {
		id: label

		font: Fonts.list
		lineHeight: Fonts.listHeight

		color: Colors.text
	}

	Rectangle {
		Layout.fillWidth: true
		color: Colors.text
		height: 0.5
	}

	ColumnLayout {
		id: mainContent

		width: form.width

		Layout.fillWidth: true

		Layout.topMargin: Properties.padding
		Layout.bottomMargin: Properties.smallMargin
		Layout.leftMargin: Properties.smallMargin
		Layout.rightMargin: Properties.smallMargin

		spacing: Properties.smallMargin
	}
}
