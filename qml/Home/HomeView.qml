import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	implicitWidth: content.implicitWidth
	implicitHeight: content.implicitHeight

	property User currentUser: MainController.currentUser

	Connections {
		target: currentUser

		function onUserTrainingPlansChanged() {
			trainingPlanModel.fillModel()
		}
	}

	Connections {
		target: MainController

		enabled: loader.source != "qrc:/qml/Home/Trainers/PupilsListView.qml"

		function onUserPlansReady() {
			trainingPlanModel.fillModel()
		}

		function onUserTrainerReady() {
			if (currentUser.isTrainerConfirmed) {
				userTrainerPanel.trainerId = currentUser.trainerId
				userTrainerPanel.trainerUsername = currentUser.trainerUsername
				return;
			}

			userTrainerPanel.trainerId = ""
			userTrainerPanel.trainerUsername = ""
		}

		function onTrainingCompleted() {
			MainController.getDabaseCompletedTrainings(currentUser)
			notify("Ukończono trening")
		}

		function onCompletedTrainingsReady(trainingsList) {
			completedTrainingsModel.clear()
			for (var i = trainingsList.length - 1; i >= 0; i--) {
				if (completedTrainingsModel.count < 3)
					completedTrainingsModel.append({"id": trainingsList[i].id,
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
	}

	function getDateString(date) {
		var day = ""

		if (date.getDate() < 10)
			day += "0"
		day += date.getDate()

		var month = ""

		if (date.getMonth() < 10)
			month += "0"
		month += date.getMonth() + 1

		var year = ""

		year += date.getFullYear()

		return (day + "/" + month + "/" + year)
	}

	Component.onCompleted: {
		MainController.getDatabaseUserTrainingPlans(currentUser)
		MainController.getDatabaseUserTrainerId(currentUser.id)
		MainController.getDabaseCompletedTrainings(currentUser)
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

				Rectangle {
					id: header

					Layout.alignment: Qt.AlignTop

					height: Properties.toolBarHeight
					Layout.fillWidth: true

					color: Colors.darkGray

					RowLayout {
						anchors.fill: parent

						anchors.topMargin: 16
						anchors.bottomMargin: 16
						anchors.leftMargin: Properties.margin
						anchors.rightMargin: Properties.margin

						Image {
							Layout.fillHeight: true
							Layout.fillWidth: true

							Layout.alignment: Qt.AlignCenter

							source: "qrc:/images/appName.png"
							fillMode: Image.PreserveAspectFit
							smooth: true
						}
					}
				}

				HomeSection {
					id: trainingPlansSection

					label: "Plany treningowe"

					Layout.leftMargin: Properties.smallMargin
					Layout.rightMargin: Properties.smallMargin

					sectionButton.icon.source: "qrc:/icons/ic_add.svg"
					sectionButton.iconSize: 32

					sectionButton.onClicked: {
						loader.setSource("qrc:/qml/Home/Trainings/EditTrainingPlanModal.qml",
										 {
											 "user": currentUser,
											 "plan": MainController.newTrainingPlan(currentUser.id)
										 })
					}

					listView.emptyInfo: "Brak planów treningowych"

					listView.model: TrainingPlansModel {
						id: trainingPlanModel

						user: currentUser
					}

					listView.delegate: TrainingPlanItem {
						label: model.name
						isSelected: model.isDefault

						implicitWidth: trainingPlansSection.listView.width

						detailsButton.onClicked: {
							loader.setSource("qrc:/qml/Home/Trainings/TrainingPlanDetails.qml",
											 {
												 "user": currentUser,
												 "planId": model.id
											 })
						}
					}
				}

				HomeSection {
					id: trainingsSection

					label: "Ukończone treningi"

					property Training completedTrainingToShow

					Layout.leftMargin: Properties.smallMargin
					Layout.rightMargin: Properties.smallMargin

					sectionButton.icon.source: "qrc:/icons/ic_list.svg"
					sectionButton.onClicked: {
						loader.setSource("qrc:/qml/Home/CompletedTrainingsListView.qml",
										 {
											"user": currentUser
										 })
					}

					listView.emptyInfo: "Brak ukończonych treningów"

					listView.model: PListModel {
						id: completedTrainingsModel

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
					id: pupilsButton

					Layout.fillWidth: true

					Layout.leftMargin: Properties.margin
					Layout.rightMargin: Properties.margin

					visible: currentUser.isTrainer

					text: "Twoi podopieczni"
					icon.source: "qrc:/icons/ic_chevronRight.svg"

					isBorder: true
					isRightIcon: true
					horizontalAlignment: Text.AlignLeft

					onClicked: {
						loader.setSource("qrc:/qml/Home/Trainers/PupilsListView.qml")
					}
				}

				HomeSection {
					id: trainersSection

					label: "Trenerzy"

					visible: MainController.trainerSectionVisible

					Layout.leftMargin: Properties.smallMargin
					Layout.rightMargin: Properties.smallMargin

					listView.visible: false

					sectionButton.icon.source: "qrc:/icons/ic_list.svg"

					sectionButton.onClicked: {
						loader.setSource("qrc:/qml/Home/Trainers/TrainersListView.qml")
					}

					UserTrainerPanel {
						id: userTrainerPanel

						Layout.fillWidth: true

						visible: trainerUsername != ""

						chatButton.onClicked: {
							loader.setSource("qrc:/qml/Home/Trainers/ChatDialog.qml",
											 {
												"username": userTrainerPanel.trainerUsername,
												 "userId": userTrainerPanel.trainerId
											 })
						}
					}

					PLabel {
						id: emptyInfoLabel

						Layout.fillHeight: true
						Layout.fillWidth: true

						Layout.topMargin: Properties.smallMargin
						Layout.bottomMargin: Properties.smallMargin

						Layout.alignment: Qt.AlignCenter
						horizontalAlignment: Text.AlignHCenter

						text: "Nie jesteś pod opieką trenera"

						font: Fonts.caption
						lineHeight: Fonts.captionHeight

						visible: !userTrainerPanel.visible
					}

					PButton {
						id: hideTrainersSectionButton

						Layout.alignment: Qt.AlignHCenter

						visible: !userTrainerPanel.visible

						text: "Ukryj sekcję"

						onClicked: {
							showMessage({"message": "Czy na pewno chcesz ukryć sekcję? Będziesz mógł ją przywrócić z ustawieniach.",
											"acceptButton.text": "Tak",
											"rejectButton.text": "Nie",
											"acceptAction": function() {
												MainController.trainerSectionVisible = false
											}
										})
						}
					}
				}

				Item {
					id: floatingButtonGap
					implicitHeight: 72
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
		anchors.bottomMargin: 30
		anchors.rightMargin: 30

		text: "Trenuj"

		onClicked: {
			trainingSelectorModalLoader.setSource("qrc:/qml/Home/TrainingSelectorModal.qml",
												  {
													  "user": currentUser
												  })
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
									 "user": currentUser,
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
