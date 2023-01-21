import QtQuick
import QtQuick.Layouts

import Components
import Properties

ColumnLayout {
	id: form

	property alias label: label.text

	default property alias content: mainContent.data

	Component.onCompleted: {
		console.log("SECTION WIDTH:", form.width)
	}

	Rectangle {
		anchors.fill: parent
		color: "yellowgreen"
		opacity: 0.5
	}

	PLabel {
		id: label

		font: Fonts.list
		lineHeight: Fonts.listHeight

		color: Colors.black_70
	}

	Rectangle {
		Layout.fillWidth: true
		color: Colors.black_30
		height: 0.5
	}

	ColumnLayout {
		id: mainContent

		width: form.width

		Layout.fillWidth: true

		Component.onCompleted: {
			console.log("RED BOX WIDTH:", mainContent.width)
		}

		Layout.topMargin: Properties.padding
		Layout.bottomMargin: Properties.smallMargin
		Layout.leftMargin: Properties.smallMargin
		Layout.rightMargin: Properties.smallMargin

		Rectangle {
			anchors.fill: parent
			color: "red"
			opacity: 0.5
		}
	}
}
