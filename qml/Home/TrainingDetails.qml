import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

PDialog {
	id: dialog

	property string planId
	property string trainingId

	property Training training: MainController.getTrainingById(planId, trainingId)

	editModeAvailable: true

	signal saved

	Connections {
		target: MainController

		function onExercisesReady() {
			exercisesModel.fillModel()
		}
	}

	editButton.onClicked: {
		loader.setSource("qrc:/qml/Home/EditTrainingDialog.qml",
						 {
							 "training": dialog.training,
							 "editMode": true
						 })
	}

	Component.onCompleted: {
		dialog.fill()
		MainController.getExercisesFromDatabaseByTrainingId(dialog.planId, dialog.trainingId)

		console.log("DETAILS: ", training.planId)
	}

	function fill() {
		dialog.title = dialog.training.name
	}


	ColumnLayout {
		id: mainColumn

		anchors.fill: parent

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

					text: "Ćwiczenia"
				}

				Item {
					Layout.fillWidth: true
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

				contentHeight: trainingsColumn.height
				contentWidth: trainingsColumn.width

				clip: true

				ScrollBar.vertical.policy: ScrollBar.AlwaysOff
				ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

				PListView {
					id: listView

					boundsBehavior: Flickable.StopAtBounds

					emptyInfo: "Nie dodałeś jeszcze żadnego ćwiczenia"

					model: ExercisesModel {
						id: exercisesModel

						training: MainController.getTrainingById(dialog.planId, dialog.trainingId)
					}

					delegate: ExerciseItem {
						exercise: MainController.getExercisegById(dialog.planId, dialog.trainingId, model.id)

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
				console.log("PLAN REMOVED")
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
