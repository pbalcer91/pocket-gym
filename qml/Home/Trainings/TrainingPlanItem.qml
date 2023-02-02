import QtQuick
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	implicitWidth: detailsButton.implicitWidth
	implicitHeight: 56

	property alias label: detailsButton.text
	property alias detailsButton: detailsButton

	property bool isSelected: false

	PLabel {
		id: info

		anchors.top: detailsButton.top
		anchors.horizontalCenter: detailsButton.horizontalCenter

		anchors.topMargin: 2

		text: "Aktywny plan"
		color: Colors.text

		visible: form.isSelected

		font: Fonts.info
		lineHeight: Fonts.infoHeight
	}

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
