import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	implicitWidth: detailsButton.implicitWidth
	implicitHeight: 56

	signal exerciseClicked(var exercise)

	property Exercise exercise

	PButton {
		id: detailsButton

		anchors.fill: parent

		text: (form.exercise ? form.exercise.name : "")

		font: Fonts.list
		lineHeight: Fonts.listHeight

		icon.source: "qrc:/icons/ic_chevronRight.svg"

		isBorder: true
		isRightIcon: true
		horizontalAlignment: Text.AlignLeft

		onClicked: {
			exerciseClicked(exercise)
		}
	}
}
