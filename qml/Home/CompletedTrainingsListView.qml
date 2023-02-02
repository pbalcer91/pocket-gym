import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

PDialog {
	id: dialog

	title: "Ukończone treningi"

	required property User user

	Connections {
		target: MainController

		function onCompletedTrainingsReady(trainingsList) {
			completedTrainingsModel.clear()
			for (var i = trainingsList.length - 1; i >= 0; i--) {
				completedTrainingsModel.append({"id": trainingsList[i].id,
												   "date": trainingsList[i].getDate(),
												   "name": trainingsList[i].name})

				trainingsList[i].removeTraining()
			}
		}

		function onCompletedExercisesReady(exercisesList) {
			for (var i = 0; i < exercisesList.length; i++) {
				listView.completedTrainingToShow.addExercise(exercisesList[i])
			}

			loader.setSource("qrc:/qml/Home/TrainingSummaryModal.qml",
							 {
								 "training": listView.completedTrainingToShow,
								 "title": getDateString(listView.completedTrainingToShow.getDate())
										  + " - " + listView.completedTrainingToShow.name
							 })
		}
	}

	Component.onCompleted: {
		MainController.getDabaseCompletedTrainings(user)
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

	ColumnLayout {
		id: mainColumn

		anchors.fill: parent

		spacing: 16

		Column {
			id: trainingsColumn

			Layout.fillHeight: true
			Layout.fillWidth: true

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

				contentHeight: trainingsColumn.height - Properties.smallMargin
				contentWidth: trainingsColumn.width

				clip: true

				ScrollBar.vertical.policy: ScrollBar.AlwaysOff
				ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

				PListView {
					id: listView

					spacing: Properties.smallMargin

					boundsBehavior: Flickable.StopAtBounds

					emptyInfo: "Brak treningów"

					property Training completedTrainingToShow

					model: PListModel {
						id: completedTrainingsModel

						fillModel: function() {
							return
						}
					}

					delegate: TrainingItem {
						implicitWidth: listView.width

						label: getDateString(model.date) + " - " + model.name

						detailsButton.onClicked: {
							listView.completedTrainingToShow = MainController.newCompletedTraining()
							listView.completedTrainingToShow.name = model.name
							listView.completedTrainingToShow.setDate(model.date)

							MainController.getDabaseCompletedExercises(model.id)
						}
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

			loader.item.open()
		}
	}
}
