import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	required property string planId
	required property Exercise exercise

	property int currentIndex: EditExerciseModal.CREATOR_STEPS.NAME

	property bool editMode: false

	autoCloseMode: false

	enum CREATOR_STEPS {
		NAME,
		SETS,
		REST,
		SUMMARY
	}

	function validate() {
		if (currentIndex === EditExerciseModal.CREATOR_STEPS.NAME
				&& nameField.text == "")
			return false

		if (currentIndex === EditExerciseModal.CREATOR_STEPS.SETS
				&& setsList.count == 0)
			return false

		if (currentIndex === EditExerciseModal.CREATOR_STEPS.REST
				&& breakTime.minutes == 0
				&& breakTime.seconds == 0)
			return false

		return true
	}

	function fill() {
		nameField.text = training.name
		breakTime.minutes = modal.exercise.breakTime / 60
		breakTime.seconds = (modal.exercise.breakTime % 60) / 15
		setsListModel.fillModel()
	}

	function save() {
		if (!modal.validate())
			return

		var setList = []

		for (var i = 0; i < setsListModel.count; i++) {
			setList.push(exercise.setToString(setsListModel.get(i).repeats,
											  setsListModel.get	(i).isMax))
		}

		if (editMode) {
			MainController.editDatabaseExercise(planId,
												exercise.id,
												exercise.trainingId,
												nameField.text,
												getBreakTime(),
												setList)

			return
		}

		MainController.addDatabaseExercise(planId,
										   exercise.trainingId,
										   nameField.text,
										   getBreakTime(),
										   setList)
	}

	function getBreakTime() {
		return (breakTime.minutes * 60 + breakTime.seconds)
	}

	closeButtonAvailable: (currentIndex > EditExerciseModal.CREATOR_STEPS.NAME)

	title: {
		switch (currentIndex) {
			case EditExerciseModal.CREATOR_STEPS.NAME:
				return "Nazwa"
			case EditExerciseModal.CREATOR_STEPS.SETS:
				return "Serie i powtórzenia"
			case EditExerciseModal.CREATOR_STEPS.REST:
				return "Czas przerw"
			case EditExerciseModal.CREATOR_STEPS.SUMMARY:
				return "Podsumowanie"
		}
	}

	acceptButton.enabled: validate()
	acceptButton.text: (currentIndex === EditExerciseModal.CREATOR_STEPS.SUMMARY ? "Zapisz" : "Dalej")
	acceptButton.onClicked: {
		if (currentIndex === EditExerciseModal.CREATOR_STEPS.SUMMARY) {
			save()
			modal.close()
			return
		}

		currentIndex++
	}

	rejectButton.text: (currentIndex == 0 ? "Anuluj" : "Wróć")
	rejectButton.onClicked: {
		if (currentIndex == 0) {
			modal.close()
			return
		}

		currentIndex--
	}

	PTextField {
		id: nameField

		Layout.fillWidth: true

		visible: modal.currentIndex === EditExerciseModal.CREATOR_STEPS.NAME

		label: "Nazwa"
		placeholderText: "Wpisz nazwę"
		text: modal.exercise.name
	}

	ScrollView {
		id: scrollView

		visible: modal.currentIndex === EditExerciseModal.CREATOR_STEPS.SETS

		background: Rectangle {
			color: "transparent"

			Rectangle {
				width: parent.width
				height: 1
				color: Colors.black

				anchors.top: parent.top
				anchors.horizontalCenter: parent.horizontalCenter

				visible: (!setsList.atYBeginning)
			}

			Rectangle {
				width: parent.width
				height: 1
				color: Colors.black

				anchors.bottom: parent.bottom
				anchors.horizontalCenter: parent.horizontalCenter

				visible: (!setsList.atYEnd)
			}
		}

		Layout.fillWidth: true
		Layout.fillHeight: true

		topPadding: 2
		bottomPadding: 2
		leftPadding: Properties.smallMargin
		rightPadding: Properties.smallMargin

		contentHeight: (setsListModel.count == 0 ?
							84
						  : 84 * setsListModel.count)
		contentWidth: modal.width

		clip: true

		ScrollBar.vertical.policy: ScrollBar.AlwaysOff
		ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

		PListView {
			id: setsList

			Layout.fillWidth: true

			boundsBehavior: Flickable.StopAtBounds

			emptyInfo: "Nie dodałeś jeszcze żadnej serii"

			model: PListModel {
				id: setsListModel

				fillModel: function() {
					clear()

					var sets = exercise.sets

					for (var i = 0; i < sets.length; i++) {
						append({"repeats": exercise.getSetRepeats(sets[i]),
								   "isMax": exercise.getSetIsMax(sets[i])})
					}
				}
			}

			delegate: ExerciseSetItem {
				label: (index + 1)

				editMode: true

				implicitWidth: setsList.width

				repeatsCount: model.repeats

				isMax: model.isMax

				onRepeatsIncreased: {
					setsListModel.get(index).repeats++
				}

				onRepeatDecreased: {
					setsListModel.get(index).repeats--
				}

				onMaxChanged: {
					if (setsListModel.get(index).isMax) {
						setsListModel.get(index).isMax = false
						return
					}

					setsListModel.get(index).isMax = true
				}

				onRemoved: {
					setsListModel.remove(index)
				}
			}
		}
	}

	PButton {
		id: addExerciseButton

		visible: modal.currentIndex === EditExerciseModal.CREATOR_STEPS.SETS

		Layout.alignment: Qt.AlignHCenter

		text: "Dodaj serię"

		onClicked: {
			var lastRepeats = (setsListModel.count == 0 ?
								   1
								 : setsListModel.get(setsListModel.count - 1).repeats)

			setsListModel.append({"repeats": lastRepeats,
									 "isMax": false})

			setsList.positionViewAtEnd()
		}
	}

	PTimeSelector {
		id: breakTime

		Layout.fillWidth: true

		visible: modal.currentIndex === EditExerciseModal.CREATOR_STEPS.REST

		minutes: modal.exercise.breakTime / 60
		seconds: (modal.exercise.breakTime % 60) / 15
	}

	RowLayout {
		id: summaryName

		Layout.fillWidth: true

		visible: modal.currentIndex === EditExerciseModal.CREATOR_STEPS.SUMMARY

		PLabel {
			font: Fonts.captionBold
			lineHeight: Fonts.captionBoldHeight

			text: "Nazwa" + ": "
		}

		PLabel {
			font: Fonts.caption
			lineHeight: Fonts.captionHeight

			text: nameField.text
		}
	}

	PListView {
		id: summarySetsList

		Layout.fillWidth: true
		Layout.bottomMargin: Properties.smallMargin

		visible: modal.currentIndex === EditExerciseModal.CREATOR_STEPS.SUMMARY

		boundsBehavior: Flickable.StopAtBounds

		model: setsListModel

		delegate: RowLayout {

			Layout.fillWidth: true

			PLabel {
				font: Fonts.captionBold
				lineHeight: Fonts.captionBoldHeight

				text: "Seria " + (index + 1) + " - "
			}

			PLabel {
				font: Fonts.caption
				lineHeight: Fonts.captionHeight

				text: "Powtórzenia: " + model.repeats
			}

			PLabel {
				font: Fonts.caption
				lineHeight: Fonts.captionHeight

				visible: model.isMax

				text: "(max)"
			}
		}
	}

	RowLayout {
		id: summaryBrekTime

		Layout.fillWidth: true

		visible: modal.currentIndex === EditExerciseModal.CREATOR_STEPS.SUMMARY

		PLabel {
			font: Fonts.captionBold
			lineHeight: Fonts.captionBoldHeight

			text: "Czas przerw" + ": "
		}

		PLabel {
			font: Fonts.caption
			lineHeight: Fonts.captionHeight

			text: breakTime.getTimeDescription()
		}
	}
}
