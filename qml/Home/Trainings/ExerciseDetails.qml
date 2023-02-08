import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

PDialog {
	id: dialog

	editModeAvailable: true

	required property User user
	required property string planId
	required property Exercise exercise

	property int breakTime

	Connections {
		target: exercise

		function onExerciseChanged() {
			dialog.fill();
		}
	}

	editButton.onClicked: {
		loader.setSource("qrc:/qml/Home/Trainings/EditExerciseModal.qml",
						 {
							 "user":user,
							 "planId": dialog.planId,
							 "exercise": dialog.exercise,
							 "editMode": true
						 })
	}

	Component.onCompleted: {
		dialog.fill()
	}

	function fill() {
		dialog.title = dialog.exercise.name
		setsModel.fillModel()
		dialog.breakTime = dialog.exercise.breakTime
	}

	function breakTimeToString(breakTime) {
		var minutes = Math.floor(breakTime / 60)
		if (minutes < 10)
			minutes = "0" + minutes

		var seconds = breakTime % 60
		if (seconds < 10)
			seconds = "0" + seconds

		return (minutes + ":" + seconds)
	}

	ColumnLayout {
		id: mainColumn

		anchors.fill: parent

		PLabel {
			id: breakTimeLabel

			Layout.alignment: Qt.AlignRight
			horizontalAlignment: Text.AlignRight

			text: "Odpoczynek - " + dialog.breakTimeToString(dialog.breakTime)
			color: Colors.text

			font: Fonts.button
			lineHeight: Fonts.buttonHeight
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

			visible: (descriptionLabel.visible)
		}

		Column {
			id: setsColumn

			Layout.fillHeight: true
			Layout.fillWidth: true

			PLabel {
				id: setListLabel

				font: Fonts.subTitle
				lineHeight: Fonts.subTitleHeight

				text: "Serie"
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

				contentHeight: setsColumn.height - removeButton.height - Properties.smallMargin
				contentWidth: setsColumn.width

				clip: true

				ScrollBar.vertical.policy: ScrollBar.AlwaysOff
				ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

				PListView {
					id: listView

					boundsBehavior: Flickable.StopAtBounds

					emptyInfo: "Nie dodałeś jeszcze żadnej serii"

					model: PListModel {
						id: setsModel

						fillModel: function() {
							clear()

							var sets = dialog.exercise.sets

							for (var i = 0; i < sets.length; i++) {
								append({"repeats": dialog.exercise.getSetRepeats(sets[i]),
										   "isMax": dialog.exercise.getSetIsMax(sets[i])})
							}
						}
					}

					delegate: ExerciseSetItem {
						width: setsColumn.width

						label: index + 1
						repeatsCount: model.repeats
						isMax: model.isMax

						editMode: false

						Layout.bottomMargin: 10
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
				showMessage({ "message": "Czy na pewno chcesz bezpowrotnie usunąć ćwiczenie?",
								"acceptButton.text": "Usuń",
								"rejectButton.text": "Anuluj",
								"acceptAction": function() {
									MainController.deleteDatabaseExercise(user,
																		  dialog.planId,
																		  dialog.exercise.trainingId,
																		  dialog.exercise.id)
									notify("Usunięto ćwiczenie")
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
