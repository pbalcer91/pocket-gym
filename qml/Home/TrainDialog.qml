import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

PDialog {
	id: dialog

	required property User user
	required property string planId
	required property string trainingId

	property Training training
	property var exercises: []
	property Exercise currentExercise

	property int currentSetIndex: 0
	property int currentExerciseIndex: 0

	property Training trainingForSave
	property Exercise exerciseForSave

	property string currentTrainingId

	property bool isCustom: false
	property string customName

	autoCloseMode: false

	editModeAvailable: true
	editButton.icon.source: "qrc:/icons/ic_list.svg"
	editButton.onClicked: {
		summaryLoader.setSource("qrc:/qml/Home/TrainingSummaryModal.qml",
								{
									"training": dialog.trainingForSave
								})
	}

	Connections {
		target: MainController

		function onUncompletedTrainingIdReady(id) {
			currentTrainingId = id
		}
	}

	backButton.icon.source: "qrc:/icons/ic_close.svg"
	backButton.onClicked: {
		showMessage({"message": "Czy na pewno chcesz przerwać trening? Informacje o tym treningu nie zostaną zapisane i utracisz je.",
						"acceptButton.text": "Tak",
						"rejectButton.text": "Nie",
						"acceptAction": function() {
							MainController.deleteDatabaseCompletedTraining(user)
							dialog.reject()
							notify("Przerwano trening")
						}
					})
	}

	Component.onCompleted: {
		if (isCustom) {
			dialog.trainingForSave = MainController.newTrainingForSave(dialog,
																	   dialog.user.id,
																	   customName)

			dialog.exerciseForSave = MainController.newExerciseForSave(dialog)

			MainController.addDatabaseCompletedTraining(user, customName)

			title = customName
			dialog.fill()

			return
		}

		dialog.training = MainController.getTrainingById(user, planId, trainingId)
		MainController.getDatabaseExercisesByTrainingId(user, planId, dialog.training.id)
		title = training.name

		dialog.trainingForSave = MainController.newTrainingForSave(dialog,
																   dialog.user.id,
																   dialog.title)

		dialog.exerciseForSave = MainController.newExerciseForSave(dialog)
	}

	Connections {
		target: MainController

		function onExercisesReady() {
			MainController.addDatabaseCompletedTraining(user, training.name)
			dialog.exercises = dialog.training.getAllExercises()

			if (dialog.exercises.length === 0)
				return

			dialog.currentExercise = dialog.exercises[currentExerciseIndex]
			dialog.fill()
			exerciseForSave.name = dialog.exercises[currentExerciseIndex].name
		}
	}

	function fill() {
		if (!isCustom)
			exerciseName.text = dialog.currentExercise.name

		setsModel.fillModel()
	}

	ScrollView {
		id: scrollView

		anchors.fill: parent

		contentHeight: flickable.implicitHeight
		contentWidth: content.width

		ScrollBar.vertical.policy: ScrollBar.AlwaysOff

		Flickable {
			id: flickable

			anchors.fill: scrollView

			clip: true
			boundsBehavior: Flickable.StopAtBounds
			contentWidth: content.width
			contentHeight: content.implicitHeight

			ColumnLayout {
				id: content

				width: flickable.width

				spacing: Properties.margin

				PLabel {
					id: exerciseName

					visible: !isCustom

					Layout.fillWidth: true
					horizontalAlignment: Text.AlignHCenter

					font: Fonts.subTitle
					lineHeight: Fonts.subTitleHeight
				}

				PTextField {
					id: exerciseCustomName

					visible: isCustom

					Layout.fillWidth: true
					horizontalAlignment: Text.AlignHCenter

					placeholderText: "Exercise name"

					onEditingFinished: {
						exerciseForSave.name = text
					}
				}

				PListView {
					id: listView

					Layout.fillWidth: true

					boundsBehavior: Flickable.StopAtBounds

					emptyInfo: "Brak serii"

					model: PListModel {
						id: setsModel

						shouldFillOnCompleted: false

						fillModel: function() {
							clear()

							if (isCustom) {
								append({"repeats": 0,
										   "weight": 0,
										   "isMax": false})
								return
							}

							var sets = dialog.currentExercise.sets

							for (var i = 0; i < sets.length; i++) {
								append({"repeats": dialog.currentExercise.getSetRepeats(sets[i]),
										   "weight": 0,
										   "isMax": dialog.currentExercise.getSetIsMax(sets[i])})
							}
						}
					}

					delegate: TrainSetItem {
						width: content.width

						isActive: index === currentSetIndex
						indexLabel: "Seria " + (index + 1)
						repeats: model.repeats
						isMax: model.isMax

						onRepeatsValueChanged: function(repeats) {
							model.repeats = repeats
						}

						onWeightValueChanged: function(weight) {
							model.weight = weight
						}

						Layout.bottomMargin: 10

						deleteButton.onClicked: {
							showMessage({"message": "Czy na pewno chcesz usunąć serię tego ćwiczenia?",
											"acceptButton.text": "Tak",
											"rejectButton.text": "Nie",
											"acceptAction": function() {
												setsModel.remove(index)
											}
										})
						}
					}
				}

				PButton {
					id: addSetButton

					Layout.alignment: Qt.AlignHCenter
					Layout.bottomMargin: Properties.margin

					text: "Dodaj serię"

					enabled: (currentSetIndex >= setsModel.count - 1)

					onClicked: {
						setsModel.append({"repeats": 0,
											 "isMax": false})
					}
				}

				PButton {
					id: addExerciseButton

					Layout.alignment: Qt.AlignHCenter
					Layout.bottomMargin: Properties.margin

					text: "Nowe ćwiczenie"

					visible: isCustom

					enabled: (currentSetIndex >= setsModel.count - 1 && exerciseCustomName.text != "")

					onClicked: {
						var completedSets = []

						for (var i = 0; i < setsModel.count; i++) {
							exerciseForSave.addSet(setsModel.get(i).repeats,
												   setsModel.get(i).weight)

							completedSets.push(exerciseForSave.completedSetToString(setsModel.get(i).repeats,
																					setsModel.get(i).weight))
						}

						trainingForSave.addExercise(exerciseForSave)

						MainController.addDatabaseCompletedExercise(currentTrainingId,
																	exerciseForSave.name,
																	completedSets)

						loader.setSource("qrc:/qml/Components/PTimerModal.qml",
										 {
											"breakTime": (isCustom ? 180 : currentExercise.breakTime)
										 })
					}
				}

				PButton {
					id: nextButton

					Layout.alignment: Qt.AlignHCenter

					text: (currentSetIndex != setsModel.count - 1 ?
							   "Koniec serii"
							 : currentExerciseIndex == exercises.length - 1 || isCustom ?
								   "Koniec treningu"
								 : "Koniec ćwiczenia")

					enabled: (!isCustom && setsModel.count != 0
							  || isCustom && exerciseCustomName.text != "")

					flat: false

					onClicked: {
						if (currentSetIndex == setsModel.count - 1) {
							var completedSets = []

							for (var i = 0; i < setsModel.count; i++) {
								exerciseForSave.addSet(setsModel.get(i).repeats,
													   setsModel.get(i).weight)

								completedSets.push(exerciseForSave.completedSetToString(setsModel.get(i).repeats,
																						setsModel.get(i).weight))
							}

							trainingForSave.addExercise(exerciseForSave)

							MainController.addDatabaseCompletedExercise(currentTrainingId,
																		exerciseForSave.name,
																		completedSets)
						}

						if (currentSetIndex == setsModel.count - 1
								&& currentExerciseIndex == exercises.length - 1
								|| currentSetIndex == setsModel.count - 1 && isCustom) {
							summaryLoader.setSource("qrc:/qml/Home/TrainingSummaryModal.qml",
													{
														"training": dialog.trainingForSave,
														"closeAction": function() {
															MainController.completeTraining(currentTrainingId)

															dialog.close()
														}
													})

							return
						}

						loader.setSource("qrc:/qml/Components/PTimerModal.qml",
										 {
											"breakTime": (isCustom ? 180 : currentExercise.breakTime)
										 })
					}
				}
			}
		}
	}

	Loader {
		id: loader

		onLoaded: {
			loader.item.closed.connect(function() {
				if (!loader)
					return
				loader.source = ""
			})

			loader.item.accepted.connect(function() {
				if (currentSetIndex < setsModel.count - 1) {
					currentSetIndex++
					return
				}

				if (isCustom) {
					dialog.exerciseForSave = MainController.newExerciseForSave(dialog)
					currentSetIndex = 0
					exerciseCustomName.text = ""
					setsModel.fillModel()
					return
				}

				if (currentExerciseIndex < exercises.length - 1 && !isCustom) {
					dialog.exerciseForSave = MainController.newExerciseForSave(dialog)
					currentExerciseIndex++
					dialog.currentExercise = dialog.exercises[currentExerciseIndex]
					dialog.exerciseForSave.name = dialog.exercises[currentExerciseIndex].name
					currentSetIndex = 0

					dialog.fill()
					return
				}
			})

			loader.item.open()
		}
	}

	Loader {
		id: summaryLoader

		onLoaded: {
			summaryLoader.item.closed.connect(function() {
				if (!summaryLoader)
					return
				summaryLoader.source = ""
			})

			summaryLoader.item.open()
		}
	}
}
