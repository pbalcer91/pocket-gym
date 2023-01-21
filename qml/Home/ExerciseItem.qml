import QtQuick
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	implicitWidth: content.implicitWidth + Properties.margin * 2
	implicitHeight: content.implicitHeight + Properties.smallMargin * 2

	property bool editMode: false

	property Exercise exercise

	property int restTime: form.exercise.restTime

	function restTimeToString(restTime) {
		var minutes = restTime / 60
		if (minutes < 10)
			minutes = "0" + minutes

		var seconds = restTime % 60
		if (seconds < 10)
			seconds = "0" + seconds

		return (minutes + ":" + seconds)
	}

	Rectangle {
		id: background

		anchors.fill: parent

		color: "transparent"
		radius: 20
		border.color: Colors.primary
		border.width: 1
	}

	ColumnLayout {
		id: content

		anchors.fill: parent

		anchors.topMargin: Properties.smallMargin
		anchors.bottomMargin: Properties.smallMargin
		anchors.leftMargin: Properties.margin
		anchors.rightMargin: Properties.margin

		spacing: 0

		PLabel {
			id: label

			text: form.exercise.name
			color: Colors.text

			font: Fonts.list
			lineHeight: Fonts.listHeight
		}

		Repeater {
			id: listView

			Layout.fillWidth: true

			model: PListModel {
				id: setsModel

				fillModel: function() {
					var sets = form.exercise.sets

					for (var i = 0; i < sets.length; i++) {
						append({"index": sets[i].index,
							   "repeats": sets[i].repeats,
							   "isMax": sets[i].isMax})
					}
				}
			}

			delegate: ExerciseSetItem {
				Layout.fillWidth: true

				label: model.index
				repeatsCount: model.repeats
				isMax: model.isMax

				editMode: form.editMode

				Layout.bottomMargin: 10
			}
		}

		PLabel {
			id: restTimeLabel

			Layout.alignment: Qt.AlignRight
			horizontalAlignment: Text.AlignRight

			text: "Odpoczynek - " + restTimeToString(form.restTime)
			color: Colors.text

			font: Fonts.button
			lineHeight: Fonts.buttonHeight
		}
	}
}
