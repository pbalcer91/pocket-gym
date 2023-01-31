import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	title: "Podsumowanie"

	rejectButton.visible: false
	acceptButton.text: "Ok"
	acceptButton.onClicked: {
		if (closeAction)
			closeAction()
	}

	property var closeAction

	required property Training training

	property var exercises: training.getAllExercises()

	ColumnLayout {
		id: mainColumn

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

					visible: (!exercisesList.atYBeginning)
				}

				Rectangle {
					width: parent.width
					height: 1
					color: Colors.black

					anchors.bottom: parent.bottom
					anchors.horizontalCenter: parent.horizontalCenter

					visible: (!exercisesList.atYEnd)
				}
			}

			Layout.fillWidth: true
			Layout.fillHeight: true

			topPadding: 2
			bottomPadding: 2
			leftPadding: Properties.smallMargin
			rightPadding: Properties.smallMargin

			contentWidth: modal.width

			clip: true

			ScrollBar.vertical.policy: ScrollBar.AlwaysOff
			ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

			PListView {
				id: exercisesList

				Layout.fillWidth: true

				emptyInfo: "Brak ćwiczeń"

				model: PListModel {
					id: execisesModel

					fillModel: function() {
						clear()

						for (var i = 0; i < exercises.length; i++) {
							append({"name": exercises[i].name})
						}
					}
				}

				delegate: ColumnLayout {
					id: exerciseDelegate

					property Exercise exercise: exercises[index]
					property var sets: exercise.sets

					Layout.fillWidth: true

					PLabel {
						font: Fonts.captionBold
						lineHeight: Fonts.captionBoldHeight

						text: model.name
					}

					Repeater {
						id: setsList

						Layout.fillWidth: true

						model: PListModel {
							id: setsModel

							fillModel: function() {
								clear()

								for (var i = 0; i < exerciseDelegate.sets.length; i++) {
									append({"repeats": exerciseDelegate.exercise.getCompletedSetRepeats(exerciseDelegate.sets[i]),
											   "weight": exerciseDelegate.exercise.getCompletedSetWeight(exerciseDelegate.sets[i])})
								}
							}
						}
						delegate: PLabel {
							font: Fonts.caption
							lineHeight: Fonts.captionHeight

							text: model.repeats + " x " + model.weight + " kg"
						}
					}

					Item {
						height: 20
					}
				}
			}
		}
	}
}
