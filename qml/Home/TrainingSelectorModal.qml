import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

PMessageDialog {
	id: modal

	title: (currentStep === TrainingSelectorModal.STEPS.TYPE ?
				"Rodzaj treningu"
			  : currentStep === TrainingSelectorModal.STEPS.PLAN ?
					"Plan treningowy"
				  : "Trening")

	autoCloseMode: false

	acceptButton.text: ""
	rejectButton.text: (currentStep === TrainingSelectorModal.STEPS.TYPE ?
							"Anuluj"
						  : "Wróć")
	rejectButton.onClicked: {
		if (currentStep === TrainingSelectorModal.STEPS.NAME) {
			currentStep = TrainingSelectorModal.STEPS.TYPE
			return
		}

		if (currentStep !== TrainingSelectorModal.STEPS.TYPE) {
			currentStep--
			return
		}

		modal.rejected()
		modal.close()
	}

	enum STEPS {
		TYPE,
		PLAN,
		TRAINING,
		NAME
	}

	property int currentStep: 0

	required property User user
	property TrainingPlan trainingPlan

	signal trainingStarted(var trainingPlanId, var trainingId, var isCustom, var name)

	Connections {
		target: MainController

		function onTrainingsReady() {
			trainingsModel.fillModel()
			currentStep = TrainingSelectorModal.STEPS.TRAINING
		}
	}

	Component.onCompleted: {
		currentStep = TrainingSelectorModal.STEPS.TYPE
	}

	PButton {
		id: userTrainingButton

		Layout.fillWidth: true
		implicitHeight: 100
		Layout.topMargin: Properties.smallMargin
		Layout.bottomMargin: Properties.smallMargin

		visible: (currentStep === TrainingSelectorModal.STEPS.TYPE)

		text: "Wybierz z planu"

		isBorder: true

		onClicked: {
			currentStep = TrainingSelectorModal.STEPS.PLAN
		}
	}

	PButton {
		id: customTrainingButton

		Layout.fillWidth: true
		implicitHeight: 100

		visible: (currentStep === TrainingSelectorModal.STEPS.TYPE)

		text: "Stwórz nowy"

		isBorder: true

		onClicked: {
			currentStep = TrainingSelectorModal.STEPS.NAME
		}
	}

	PTextField {
		id: customTrainingName

		Layout.fillWidth: true

		visible: (currentStep === TrainingSelectorModal.STEPS.NAME)

		placeholderText: "Nazwa treningu"
	}

	PButton {
		id: customTrainingConfirm

		text: "Rozpocznij"
		flat: false
		Layout.alignment: Qt.AlignHCenter

		visible: (currentStep === TrainingSelectorModal.STEPS.NAME)

		onClicked: {
			trainingStarted("", "", true, customTrainingName.text)
			modal.close()
		}
	}

	ScrollView {
		id: trainingPlanScroll

		visible: (currentStep === TrainingSelectorModal.STEPS.PLAN)

		background: Rectangle {
			color: "transparent"

			Rectangle {
				width: parent.width
				height: 1
				color: Colors.black

				anchors.top: parent.top
				anchors.horizontalCenter: parent.horizontalCenter

				visible: (!trainingPlanListView.atYBeginning)
			}

			Rectangle {
				width: parent.width
				height: 1
				color: Colors.black

				anchors.bottom: parent.bottom
				anchors.horizontalCenter: parent.horizontalCenter

				visible: (!trainingPlanListView.atYEnd)
			}
		}

		Layout.fillWidth: true
		Layout.fillHeight: true

		Layout.maximumHeight: 300

		topPadding: 2
		bottomPadding: 2
		leftPadding: Properties.smallMargin
		rightPadding: Properties.smallMargin

		contentHeight: trainingPlanListView.count * 68
		contentWidth: modal.width

		clip: true

		ScrollBar.vertical.policy: ScrollBar.AlwaysOff
		ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

		PListView {
			id: trainingPlanListView

			boundsBehavior: Flickable.StopAtBounds

			emptyInfo: "Brak planów treningowych"

			model: TrainingPlansModel {
				id: trainingPlanModel

				user: modal.user
			}

			delegate: TrainingPlanItem {
				label: model.name
				isSelected: model.isDefault

				implicitWidth: trainingPlanListView.width

				detailsButton.onClicked: {
					modal.trainingPlan = MainController.getTrainingPlanById(user, model.id)
					MainController.getDatabaseTrainingsByPlanId(modal.user, model.id)
				}
			}
		}
	}

	ScrollView {
		id: trainingScroll

		visible: (currentStep === TrainingSelectorModal.STEPS.TRAINING)

		background: Rectangle {
			color: "transparent"

			Rectangle {
				width: parent.width
				height: 1
				color: Colors.black

				anchors.top: parent.top
				anchors.horizontalCenter: parent.horizontalCenter

				visible: (!trainingListView.atYBeginning)
			}

			Rectangle {
				width: parent.width
				height: 1
				color: Colors.black

				anchors.bottom: parent.bottom
				anchors.horizontalCenter: parent.horizontalCenter

				visible: (!trainingListView.atYEnd)
			}
		}

		Layout.fillWidth: true
		Layout.fillHeight: true

		Layout.maximumHeight: 300

		topPadding: 2
		bottomPadding: 2
		leftPadding: Properties.smallMargin
		rightPadding: Properties.smallMargin

		contentHeight: trainingListView.count * 68
		contentWidth: modal.width

		clip: true

		ScrollBar.vertical.policy: ScrollBar.AlwaysOff
		ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

		PListView {
			id: trainingListView

			boundsBehavior: Flickable.StopAtBounds

			emptyInfo: "Brak treningów"

			model: TrainingsModel {
				id: trainingsModel

				shouldFillOnCompleted: false

				trainingPlan: modal.trainingPlan
			}

			delegate: TrainingItem {
				label: model.name

				implicitWidth: trainingPlanListView.width

				detailsButton.onClicked: {
					trainingStarted(modal.trainingPlan.id, model.id, false, "")
					modal.close()
				}
			}
		}
	}
}
