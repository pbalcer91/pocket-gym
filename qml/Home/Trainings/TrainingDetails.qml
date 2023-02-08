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
	required property string trainingId

	editModeAvailable: true

	property Training training: MainController.getTrainingById(user, planId, trainingId)

	Connections {
		target: training

		function onTrainingChanged() {
			dialog.fill();
		}
	}

	Connections {
		target: MainController

		function onExercisesReady() {
			exercisesModel.fillModel()
		}
	}

	editButton.onClicked: {
		loader.setSource("qrc:/qml/Home/Trainings/EditTrainingModal.qml",
						 {
							 "user": user,
							 "training": dialog.training,
							 "editMode": true
						 })
	}

	Component.onCompleted: {
		dialog.fill()
		MainController.getDatabaseExercisesByTrainingId(user, training.planId, training.id)
	}

	function fill() {
		dialog.title = dialog.training.name
		exercisesModel.fillModel()
	}

	ColumnLayout {
		id: mainColumn

		anchors.fill: parent

		Column {
			id: exercisesColumn

			Layout.fillHeight: true
			Layout.fillWidth: true

			RowLayout {
				implicitWidth: parent.implicitWidth

				PLabel {
					id: exercisesListLabel

					font: Fonts.subTitle
					lineHeight: Fonts.subTitleHeight

					text: "Ćwiczenia"
				}

				Item {
					Layout.fillWidth: true
				}

				PButton {
					id: addExerciseButton

					icon.source: "qrc:/icons/ic_add.svg"

					Layout.alignment: Qt.AlignHCenter

					onClicked: {
						loader.setSource("qrc:/qml/Home/Trainings/EditExerciseModal.qml",
										 {
											 "user": user,
											 "planId": training.planId,
											 "exercise": MainController.newExercise(training.id)
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

				contentHeight: exercisesColumn.height - removeButton.height - Properties.smallMargin
				contentWidth: exercisesColumn.width

				clip: true

				ScrollBar.vertical.policy: ScrollBar.AlwaysOff
				ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

				PListView {
					id: listView

					boundsBehavior: Flickable.StopAtBounds

					emptyInfo: "Nie dodałeś jeszcze żadnego ćwiczenia"

					model: ExercisesModel {
						id: exercisesModel

						training: dialog.training
					}

					delegate: ExerciseItem {
						exercise: MainController.getExerciseById(user, training.planId, training.id, model.id)

						implicitWidth: listView.width

						onExerciseClicked: function(exercise) {
							loader.setSource("qrc:/qml/Home/Trainings/ExerciseDetails.qml",
											 {
												 "user": user,
												 "planId": dialog.training.planId,
												 "exercise": exercise
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
				showMessage({ "message": "Czy na pewno chcesz bezpowrotnie usunąć trening?",
								"acceptButton.text": "Usuń",
								"rejectButton.text": "Anuluj",
								"acceptAction": function() {
									MainController.deleteDatabaseTraining(user, training.planId, training.id)
									dialog.close()
									notify("Usunięto trening")
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
