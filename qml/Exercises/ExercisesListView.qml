import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

PDialog {
	id: dialog

	required property string category

	Component.onCompleted: {
		MainController.getDatabaseCatalogByCategory(category)
	}

	Connections {
		target: MainController

		function onCatalogReady(list) {
			exercisesModel.clear()

			for (var exercise in list) {
				exercisesModel.append({"name": exercise,
										  "description": list[exercise]})
			}
		}
	}

	ColumnLayout {
		id: mainColumn

		anchors.fill: parent

		spacing: 16

		Column {
			id: exercisesColumn

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

				contentHeight: exercisesColumn.height - Properties.smallMargin
				contentWidth: exercisesColumn.width

				clip: true

				ScrollBar.vertical.policy: ScrollBar.AlwaysOff
				ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

				PListView {
					id: listView

					spacing: Properties.smallMargin

					boundsBehavior: Flickable.StopAtBounds

					emptyInfo: "Brak ćwiczeń"

					model: PListModel {
						id: exercisesModel

						fillModel: function() {

						}
					}

					delegate: CatalogExerciseItem {
						implicitWidth: listView.width

						label: model.name

						detailsButton.onClicked: {
							showMessage({"title": model.name,
											"message": model.description,
											"acceptButton.text": "Ok",
											"rejectButton.visible": false})
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
