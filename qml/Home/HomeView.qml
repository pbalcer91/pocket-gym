import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	implicitWidth: content.implicitWidth + Properties.smallMargin * 2
	implicitHeight: content.implicitHeight + Properties.smallMargin * 2

	Connections {
		target: MainController.getCurrentUser()

		function onUserTrainingPlansChanged() {
			trainingPlanModel.fillModel()
		}
	}

	Connections {
		target: MainController

		function onCurrentUserPlansReady() {
			trainingPlanModel.fillModel()
		}
	}

	Component.onCompleted: {
		MainController.getDatabaseUserTrainingPlans()
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
			anchors.topMargin: Properties.smallMargin
			anchors.leftMargin: Properties.margin
			anchors.rightMargin: Properties.margin

			clip: true
			boundsBehavior: Flickable.StopAtBounds
			contentWidth: content.width
			contentHeight: content.implicitHeight

			ColumnLayout {
				id: content

				width: flickable.width

				spacing: Properties.margin

				RowLayout {
					Layout.fillWidth: true

					PLabel {
						id: title

						text: "Tu pewnie coś będzie"
						font: Fonts.title
						lineHeight: Fonts.titleHeight

						Layout.alignment: Qt.AlignTop
					}
				}

				HomeSection {
					id: trainingPlansSection

					label: "Plany treningowe"

					sectionButton.icon.source: "qrc:/icons/ic_add.svg"
					sectionButton.iconSize: 32

					sectionButton.onClicked: {
						loader.setSource("qrc:/qml/Home/EditTrainingPlanModal.qml",
										 {
											 "plan": MainController.newTrainingPlan(),
										 })
					}

					listView.emptyInfo: "Brak dostępnych planów treningowych"

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

					listView.emptyInfo: "Nie odbyłeś jeszcze żadnego treningu"

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

				HomeSection {
					id: trainersSection

					label: "Trenerzy"

					sectionButton.icon.source: "qrc:/icons/ic_list.svg"

					listView.emptyInfo: "Nie jesteś pod opieką żadnego trenera"

					listView.model: TrainersModel {
						id: trainersModel
					}

					listView.delegate: TrainingPlanItem {
						label: model.name

						isSelected: model.isDefault

						implicitWidth: trainersSection.listView.width
					}

					PButton {
						id: hideTrainersSectionButton

						Layout.alignment: Qt.AlignHCenter

						visible: trainersModel.count == 0

						text: "Ukryj sekcję"

						onClicked: {
							showMessage({"message": "Czy na pewno chcesz ukryć sekcję? Będziesz mógł ją przywrócić z ustawieniach.",
											"acceptButtonText": "Tak",
											"rejectButtonText": "Nie"
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
