import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

PDialog {
	id: dialog

	leftPadding: Properties.smallMargin
	rightPadding: Properties.smallMargin

	required property string pupilId
	required property string pupilUsername

	property User pupil: MainController.createPupilInstance(dialog, pupilId, pupilUsername)

	editModeAvailable: true

	Connections {
		target: pupil

		function onUserTrainingPlansChanged() {
			trainingPlanModel.fillModel()
		}
	}

	Connections {
		target: MainController

		function onUserPlansReady() {
			trainingPlanModel.fillModel()
		}

		function onCompletedTrainingsReady(trainingsList) {
			pupilCompletedTrainingsModel.clear()
			for (var i = trainingsList.length - 1; i >= 0; i--) {
				if (pupilCompletedTrainingsModel.count < 3)
					pupilCompletedTrainingsModel.append({"id": trainingsList[i].id,
													   "date": trainingsList[i].getDate(),
													   "name": trainingsList[i].name})

				trainingsList[i].removeTraining()
			}
		}

		function onCompletedExercisesReady(exercisesList) {
			if (!trainingsSection.completedTrainingToShow)
				return

			for (var i = 0; i < exercisesList.length; i++) {
				trainingsSection.completedTrainingToShow.addExercise(exercisesList[i])
			}

			completedTrainingLoader.setSource("qrc:/qml/Home/TrainingSummaryModal.qml",
											  {
												  "training": trainingsSection.completedTrainingToShow,
												  "title": getDateString(trainingsSection.completedTrainingToShow.getDate())
														   + " - " + trainingsSection.completedTrainingToShow.name
											  })
		}

		function onMeasurementsReady() {
			if (!MainController.getCurrentUserLastMeasurement())
				return

			progressButton.enabled = true
		}

		function onTrainingCompleted() {
			MainController.getDabaseCompletedTrainings(pupil)
		}
	}

	function getDateString(date) {
		var day = ""

		if (date.getDate() < 10)
			day += "0"
		day += date.getDate()

		var month = ""

		if (date.getDate() < 10)
			month += "0"
		month += date.getMonth() + 1

		var year = ""

		year += date.getFullYear()

		return (day + "/" + month + "/" + year)
	}

	Component.onCompleted: {
		MainController.getDatabaseUserTrainingPlans(pupil)
		MainController.getDabaseCompletedTrainings(pupil)
		MainController.getDatabaseMeasurementsByUser(pupil)
	}

	editButton.icon.source: "qrc:/icons/ic_delete.svg"
	editButton.color: Colors.error
	editButton.onClicked: {
		showMessage({"message": "Czy na pewno chcesz zakończyć współpracę z podopiecznym? Nie będziesz miał możliwości wysłania do niego wiadomości, a historia rozmów zostanie usunięta.",
						"acceptButton.text": "Tak",
						"rejectButton.text": "Nie",
						"acceptAction": function() {
							MainController.deletePupilFromTrainer(MainController.currentUser, pupilId)
							dialog.close()
						}
					})
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

				HomeSection {
					id: trainingPlansSection

					label: "Plany treningowe"

					sectionButton.icon.source: "qrc:/icons/ic_add.svg"
					sectionButton.iconSize: 32

					sectionButton.onClicked: {
						loader.setSource("qrc:/qml/Home/Trainings/EditTrainingPlanModal.qml",
										 {
											 "user": pupil,
											 "plan": MainController.newTrainingPlan(pupil.id)
										 })
					}

					listView.emptyInfo: "Brak planów treningowych"

					listView.model: TrainingPlansModel {
						id: trainingPlanModel

						user: pupil
					}

					listView.delegate: TrainingPlanItem {
						label: model.name
						isSelected: model.isDefault

						implicitWidth: trainingPlansSection.listView.width

						detailsButton.onClicked: {
							loader.setSource("qrc:/qml/Home/Trainings/TrainingPlanDetails.qml",
											 {
												 "user": pupil,
												 "planId": model.id
											 })
						}
					}
				}

				HomeSection {
					id: trainingsSection

					label: "Ukończone treningi"

					property Training completedTrainingToShow

					sectionButton.icon.source: "qrc:/icons/ic_list.svg"
					sectionButton.onClicked: {
						loader.setSource("qrc:/qml/Home/CompletedTrainingsListView.qml",
										 {
											"user": pupil
										 })
					}

					listView.emptyInfo: "Brak ukończonych treningów"

					listView.model: PListModel {
						id: pupilCompletedTrainingsModel

						fillModel: function() {
							return
						}
					}

					listView.delegate: TrainingItem {
						label: getDateString(model.date) + " - " + model.name

						implicitWidth: trainingsSection.listView.width

						detailsButton.onClicked: {
							trainingsSection.completedTrainingToShow = MainController.newCompletedTraining()
							trainingsSection.completedTrainingToShow.name = model.name
							trainingsSection.completedTrainingToShow.setDate(model.date)

							MainController.getDabaseCompletedExercises(model.id)
						}
					}
				}

				PButton {
					id: progressButton

					Layout.alignment: Qt.AlignHCenter

					text: "Pokaż pomiary"

					enabled: false

					onClicked: {
						loader.setSource("qrc:/qml/Progress/MeasurementsHistoryDialog.qml",
										 {
											 "user": pupil
										 })
					}
				}

				PButton {
					id: messageButton

					Layout.alignment: Qt.AlignHCenter

					text: "Wyślij wiadomość"
				}
			}
		}
	}

	PButton {
		id: trainingButton

		width: 120
		height: 48
		radius: 24

		isFloating: true

		anchors.bottom: parent.bottom
		anchors.right: parent.right
		anchors.bottomMargin: 10
		anchors.rightMargin: 30

		text: "Trenuj"

		onClicked: {
			trainingSelectorModalLoader.setSource("qrc:/qml/Home/TrainingSelectorModal.qml",
												  {
													  "user": pupil
												  })
		}
	}

	Loader {
		id: completedTrainingLoader

		onLoaded: {
			completedTrainingLoader.item.closed.connect(function() {
				if (!completedTrainingLoader)
					return
				completedTrainingLoader.source = ""

				trainingsSection.completedTrainingToShow.removeTraining()
			})

			completedTrainingLoader.item.open()
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

			loader.item.open()
		}
	}

	Loader {
		id: trainingSelectorModalLoader

		onLoaded: {
			trainingSelectorModalLoader.item.closed.connect(function() {
				if (!trainingSelectorModalLoader)
					return
				trainingSelectorModalLoader.source = ""
			})

			trainingSelectorModalLoader.item.trainingStarted.connect(function(planId, trainingId, isCustom, name) {
				loader.setSource("qrc:/qml/Home/TrainDialog.qml",
								 {
									 "user": pupil,
									 "planId": planId,
									 "trainingId": trainingId,
									 "isCustom": isCustom,
									 "customName": name
								 })
			})

			trainingSelectorModalLoader.item.open()
		}
	}
}
