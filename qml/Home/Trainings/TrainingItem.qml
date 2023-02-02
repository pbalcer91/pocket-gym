import QtQuick
import QtQuick.Layouts

import Components
import Properties

Item {
	id: form

	implicitWidth: detailsButton.implicitWidth
	implicitHeight: 56

	property alias label: detailsButton.text
	property alias detailsButton: detailsButton

	PButton {
		id: detailsButton

		anchors.fill: parent

		font: Fonts.list
		lineHeight: Fonts.listHeight

		icon.source: "qrc:/icons/ic_chevronRight.svg"

		isBorder: true
		isRightIcon: true
		horizontalAlignment: Text.AlignLeft
	}
}
