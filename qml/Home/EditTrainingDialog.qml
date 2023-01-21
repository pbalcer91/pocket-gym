import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

PDialog {
	id: dialog

	required property Training training

	title: (editMode ? training.name : "Nowy trening")

	property bool editMode: false

	editButton.onClicked: {
//		if (!dialog.editMode) {
//			dialog.training.removeTraining()
//			return
//		}
	}

	Component.onCompleted: {
		dialog.fill()
	}

	function isValid() {
		if (nameField.text == "")
			return false

//		if (listView.count == 0)
//			return false

		return true
	}

	function fill() {
		nameField.text = dialog.training.name
	}

	function saveTraining() {
		dialog.training.name = nameField.text
		//zapis serii
	}

	ColumnLayout {
		id: mainColumn

		anchors.fill: parent

		spacing: 16

		PTextField {
			id: nameField

			Layout.fillWidth: true

			label: "Nazwa"
			placeholderText: "Wpisz nazwę"
		}

		Rectangle {
			Layout.fillWidth: true
			color: Colors.black_70
			height: 1
		}

		Column {
			id: exercisesColumn

			Layout.fillHeight: true
			Layout.fillWidth: true

			RowLayout {
				implicitWidth: parent.implicitWidth

				PLabel {
					id: exerciseListLabel

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

					onClicked: {
						loader.setSource("qrc:/qml/Home/EditExerciseModal.qml",
										 {
											"exercise": MainController.createExercise()
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

				contentHeight: exercisesColumn.height
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
						exercise: MainController.getExercisegById(dialog.training.planId, dialog.training.id, model.id)

						editMode: true

						implicitWidth: listView.width
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
