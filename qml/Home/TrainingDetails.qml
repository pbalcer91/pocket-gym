import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

PDialog {
	id: dialog

	editModeAvailable: true

	property Training training: MainController.getTrainingById(planId, trainingId)

	Connections {
		target: training

		function onTrainingChanged() {
			dialog.fill();
		}
	}

	Connections {
		target: MainController

//		function onExercisesReady() {
//			exercisesModel.fillModel()
//		}
	}

	editButton.onClicked: {
		loader.setSource("qrc:/qml/Home/EditTrainingModal.qml",
						 {
							 "training": dialog.training,
							 "editMode": true
						 })
	}

	Component.onCompleted: {
		dialog.fill()
		//MainController.getExercisesFromDatabaseByTrainingId(dialog.planId, dialog.trainingId)
	}

	function fill() {
		dialog.title = dialog.training.name
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
//						loader.setSource("qrc:/qml/Home/EditTrainingModal.qml",
//										 {
//											 "training": MainController.newTraining(MainController.getCurrentUserName(), dialog.planId)
//										 })
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

				contentHeight: exercisesColumn.height
				contentWidth: exercisesColumn.width

				clip: true

				ScrollBar.vertical.policy: ScrollBar.AlwaysOff
				ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

				PListView {
					id: listView

					boundsBehavior: Flickable.StopAtBounds

					emptyInfo: "Nie dodałeś jeszcze żadnego ćwiczenia"

					model: 0/*ExercisesModel {
						id: exercisesModel

						training: MainController.getTrainingById(dialog.planId, dialog.trainingId)
					}*/

					delegate: ExerciseItem {
						exercise: MainController.getExercisegById(training.planId, training.id, model.id)

						implicitWidth: listView.width
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
									MainController.deleteDatabaseTraining(training.planId, training.id)
									dialog.close()
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
