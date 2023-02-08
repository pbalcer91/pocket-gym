import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

PDialog {
	id: dialog

	title: "Lista podopiecznych"

	property User currentUser: MainController.currentUser

	Connections {
		target: MainController

		function onPupilsListReady() {
			pupilsModel.fillModel()
		}

		function onPupilReady(pupilUsername, isConfirmed) {
			if (pupilsModel.pupilsToFill == 0)
				return

			var pupils = currentUser.pupilsIds

			var index = pupils.length - pupilsModel.pupilsToFill
			pupilsModel.appendPupil(pupils[index],
									pupilUsername,
									isConfirmed)

			pupilsModel.pupilsToFill--
		}
	}

	Component.onCompleted: {
		MainController.getDatabaseTrainerPupilsIds(currentUser.id)
	}

	ColumnLayout {
		id: mainColumn

		anchors.fill: parent

		spacing: 16

		Column {
			id: pupilsColumn

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

				contentHeight: pupilsColumn.height - Properties.smallMargin
				contentWidth: pupilsColumn.width

				clip: true

				ScrollBar.vertical.policy: ScrollBar.AlwaysOff
				ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

				PListView {
					id: listView

					spacing: Properties.smallMargin

					boundsBehavior: Flickable.StopAtBounds

					emptyInfo: "Brak podopiecznych"

					model: PupilsModel {
						id: pupilsModel
					}

					delegate: PupilItem {
						implicitWidth: listView.width

						label: model.username
						isConfirmed: model.isConfirmed

						rejectButton.onClicked: {
							MainController.deletePupilFromTrainer(currentUser, model.id)
							notify("Odrzucono prośbę od użytkownika")
						}

						acceptButton.onClicked: {
							MainController.acceptPupil(model.id)
							notify("Dodano nowego podopiecznego")
						}

						detailsButton.onClicked: {
							loader.setSource("qrc:/qml/Home/Trainers/PupilDetails.qml",
											 {
												 "title": model.username,
												 "pupilId": model.id,
												 "pupilUsername": model.username
											 })
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
