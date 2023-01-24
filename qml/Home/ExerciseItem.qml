import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	implicitWidth: content.implicitWidth + Properties.margin * 2
	implicitHeight: content.implicitHeight + Properties.smallMargin * 2

	signal exerciseClicked(var exercise)

	property Exercise exercise: MainController.getExercisegById(planId, trainingId, exerciseId)

	Component.onCompleted: {
		label.text = exercise.name
	}

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
		anchors.rightMargin: Properties.margin

		spacing: 0

		PLabel {
			id: label

			color: Colors.text

			font: Fonts.list
			lineHeight: Fonts.listHeight
		}

		Item {
			Layout.fillWidth: true
		}

		PButton {
			id: detailsButton

			icon.source: "qrc:/icons/ic_chevronRight.svg"

			onClicked: {
				exerciseClicked(exercise)
			}
		}
	}
}
