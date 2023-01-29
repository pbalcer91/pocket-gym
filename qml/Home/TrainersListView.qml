import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

PDialog {
	id: dialog

	title: "Lista trenerów"

	property string currentTrainer

	Connections {
		target: MainController

		function onTrainersListReady() {
			trainersModel.fillModel()

			MainController.getDatabaseUserTrainerId(MainController.currentUser.id)
		}

		function onUserTrainerReady() {
			currentTrainer = MainController.currentUser.trainerId
		}
	}

	Component.onCompleted: {
		MainController.getDatabaseTrainers()
	}

	ColumnLayout {
		id: mainColumn

		anchors.fill: parent

		spacing: 16

		Column {
			id: trainersColumn

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

				contentHeight: trainersColumn.height - Properties.smallMargin
				contentWidth: trainersColumn.width

				clip: true

				ScrollBar.vertical.policy: ScrollBar.AlwaysOff
				ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

				PListView {
					id: listView

					spacing: Properties.smallMargin

					boundsBehavior: Flickable.StopAtBounds

					emptyInfo: "Brak dostępnych trenerów"

					model: TrainersModel {
						id: trainersModel
					}

					delegate: TrainerItem {
						implicitWidth: listView.width

						isSelected: (dialog.currentTrainer === model.id)

						inviteButton.visible: (dialog.currentTrainer == "" || isSelected)

						label: model.username

						inviteButton.onClicked: {
							if (!isSelected) {
								dialog.currentTrainer = model.id
								MainController.addRequestForTrainer(dialog.currentTrainer)
								return
							}

							MainController.deleteTrainerFromUser(dialog.currentTrainer)
							dialog.currentTrainer = ""
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
