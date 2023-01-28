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

		function onCurrentUserPlansReady() {
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
	}

	Component.onCompleted: {
		MainController.getDatabaseUserTrainingPlans()
		MainController.getDatabaseUserTrainerId(currentUser.id)
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

						anchors.leftMargin: Properties.margin
						anchors.rightMargin: Properties.margin

						PLabel {
							id: title

							font: Fonts.title
							lineHeight: Fonts.titleHeight

							color: Colors.text

							text: "Pocket Gym"
						}

						Item {
							Layout.fillWidth: true
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
						loader.setSource("qrc:/qml/Home/EditTrainingPlanModal.qml",
										 {
											 "plan": MainController.newTrainingPlan()
										 })
					}

					listView.emptyInfo: "Brak planów treningowych"

					listView.model: TrainingPlansModel {
						id: trainingPlanModel
					}

					listView.delegate: TrainingPlanItem {
						label: model.name
						isSelected: model.isDefault

						implicitWidth: trainingPlansSection.listView.width

						detailsButton.onClicked: {
							loader.setSource("qrc:/qml/Home/TrainingPlanDetails.qml",
											 {
												 "planId": model.id
											 })
						}
					}
				}

				HomeSection {
					id: trainingsSection

					label: "Odbyte treningi"

					Layout.leftMargin: Properties.smallMargin
					Layout.rightMargin: Properties.smallMargin

					sectionButton.icon.source: "qrc:/icons/ic_list.svg"

					listView.emptyInfo: "Brak odbytych treningów"

					listView.model: 0 /*TrainingsModel {
						id: trainingsModel

						isInTrainingPlan: false
					}*/

					listView.delegate: TrainingPlanItem {
						label: model.name

						isSelected: model.isDefault

						implicitWidth: trainingsSection.listView.width
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
						loader.setSource("qrc:/qml/Home/PupilsListView.qml")
					}
				}

				HomeSection {
					id: trainersSection

					label: "Trenerzy"

					Layout.leftMargin: Properties.smallMargin
					Layout.rightMargin: Properties.smallMargin

					listView.visible: false

					sectionButton.icon.source: "qrc:/icons/ic_list.svg"

					sectionButton.onClicked: {
						loader.setSource("qrc:/qml/Home/TrainersListView.qml")
					}

					UserTrainerPanel {
						id: userTrainerPanel

						Layout.fillWidth: true

						visible: trainerUsername != ""
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
											"rejectButton.text": "Nie"
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

		text: "Trening"

		onClicked: {

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
}
