import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

PDialog {
	id: dialog

	required property User user
	required property string planId

	editModeAvailable: true

	property TrainingPlan trainingPlan: MainController.getTrainingPlanById(user, dialog.planId)

	Connections {
		target: user

		function onUserTrainingPlanRemoved() {
			notify("Usunięto plan treningowy")
			dialog.close()
		}
	}

	Connections {
		target: trainingPlan

		function onTrainingPlanChanged() {
			dialog.fill();
		}
	}

	Connections {
		target: MainController

		function onTrainingsReady() {
			trainingsModel.fillModel()
		}
	}

	editButton.onClicked: {
		loader.setSource("qrc:/qml/Home/Trainings/EditTrainingPlanModal.qml",
						 {
							 "user": user,
							 "plan": dialog.trainingPlan,
							 "editMode": true
						 })
	}

	Component.onCompleted: {
		dialog.fill()
		MainController.getDatabaseTrainingsByPlanId(user, dialog.planId)
	}

	function fill() {
		dialog.title = dialog.trainingPlan.name
		isDefaultLabel.visible = dialog.trainingPlan.isDefault
		descriptionLabel.text = dialog.trainingPlan.description
		trainingsModel.fillModel()
	}

	ColumnLayout {
		id: mainColumn

		anchors.fill: parent

		spacing: 16

		PLabel {
			id: isDefaultLabel

			font: Fonts.captionBold
			lineHeight: Fonts.captionBoldHeight

			text: "Aktywny plan"

			Layout.fillWidth: true

			horizontalAlignment: Text.AlignHCenter
		}

		PLabel {
			id: descriptionLabel

			Layout.fillWidth: true

			font: Fonts.caption
			lineHeight: Fonts.captionHeight

			visible: text != ""
		}

		Rectangle {
			Layout.fillWidth: true
			color: Colors.black_70
			height: 1

			visible: (descriptionLabel.visible || isDefaultLabel.visible)
		}

		Column {
			id: trainingsColumn

			Layout.fillHeight: true
			Layout.fillWidth: true

			RowLayout {
				implicitWidth: parent.implicitWidth

				PLabel {
					id: trainingListLabel

					font: Fonts.subTitle
					lineHeight: Fonts.subTitleHeight

					text: "Treningi"
				}

				Item {
					Layout.fillWidth: true
				}

				PButton {
					id: addTrainingButton

					icon.source: "qrc:/icons/ic_add.svg"

					Layout.alignment: Qt.AlignHCenter

					onClicked: {
						loader.setSource("qrc:/qml/Home/Trainings/EditTrainingModal.qml",
										 {
											 "user": user,
											 "training": MainController.newTraining(user.id, dialog.planId)
										 })
					}
				}
			}

			ScrollView {
				id: scrollView

				background: Rectangle {
					color: "transparent"

					Rectangle {
						width: parent.width
						height: 1
						color: Colors.black

						anchors.top: parent.top
						anchors.horizontalCenter: parent.horizontalCenter

						visible: (!listView.atYBeginning)
					}

					Rectangle {
						width: parent.width
						height: 1
						color: Colors.black

						anchors.bottom: parent.bottom
						anchors.horizontalCenter: parent.horizontalCenter

						visible: (!listView.atYEnd)
					}
				}

				Layout.fillWidth: true
				Layout.fillHeight: true

				topPadding: 2
				bottomPadding: 2
				leftPadding: Properties.smallMargin
				rightPadding: Properties.smallMargin

				contentHeight: trainingsColumn.height - removeButton.height - Properties.smallMargin
				contentWidth: trainingsColumn.width

				clip: true

				ScrollBar.vertical.policy: ScrollBar.AlwaysOff
				ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

				PListView {
					id: listView

					boundsBehavior: Flickable.StopAtBounds

					emptyInfo: "Nie dodałeś jeszcze żadnego treningu"

					model: TrainingsModel {
						id: trainingsModel

						trainingPlan: MainController.getTrainingPlanById(user, dialog.planId)
					}

					delegate: TrainingItem {
						label: model.name

						implicitWidth: listView.width

						detailsButton.onClicked: {
							loader.setSource("qrc:/qml/Home/Trainings/TrainingDetails.qml",
											 {
												 "user": user,
												 "planId": planId,
												 "trainingId": model.id
											 })
						}
					}
				}
			}
		}

		PButton {
			id: removeButton

			color: Colors.error
			text: "Usuń"

			Layout.alignment: Qt.AlignHCenter

			onClicked: {
				showMessage({ "message": "Czy na pewno chcesz bezpowrotnie usunąć plan treningowy?",
								"acceptButton.text": "Usuń",
								"rejectButton.text": "Anuluj",
								"acceptAction": function() {
									MainController.deleteDatabaseTrainingPlan(user, dialog.planId)
								}
							})
			}
		}
	}

	Loader {
		id: loader

		onLoaded: {
			loader.item.closed.connect(function() {
				dialog.fill()

				if (!loader)
					return
				loader.source = ""
			})

			loader.item.open()
		}
	}
}
