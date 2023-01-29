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
	}

	Component.onCompleted: {
		MainController.getDatabaseUserTrainingPlans(pupil)
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
						loader.setSource("qrc:/qml/Home/EditTrainingPlanModal.qml",
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
							loader.setSource("qrc:/qml/Home/TrainingPlanDetails.qml",
											 {
												 "user": pupil,
												 "planId": model.id
											 })
						}
					}
				}

				HomeSection {
					id: trainingsSection

					label: "Odbyte treningi"

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
					id: progressButton

					Layout.alignment: Qt.AlignHCenter

					text: "Pokaż pomiary"
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
