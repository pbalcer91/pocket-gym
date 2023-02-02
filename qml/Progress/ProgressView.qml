import QtQuick
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis


Item {
	id: form

	implicitWidth: content.implicitWidth
	implicitHeight: content.implicitHeight + Properties.margin

	property User currentUser: MainController.getCurrentUser()

	Connections {
		target: MainController

		function onMeasurementsReady() {
			lastMeasurement.measurement = MainController.getCurrentUserLastMeasurement()

			if (!lastMeasurement.measurement)
				return

			lastMeasurement.fill()
		}
	}

	Component.onCompleted: {
		MainController.getDatabaseMeasurementsByUser(currentUser)
	}

	function isMeasurementAddAvailable() {
		if (!lastMeasurement.measurement)
			return true

		var now = new Date()

		if (lastMeasurement.measurement.date.getFullYear() === now.getFullYear()
				&& lastMeasurement.measurement.date.getMonth() === now.getMonth()
				&& lastMeasurement.measurement.date.getDate() === now.getDate())
			return false

		return true
	}

	ColumnLayout {
		id: content

		anchors.fill: parent

		anchors.bottomMargin: Properties.margin

		spacing: Properties.margin

		Rectangle {
			id: header

			Layout.alignment: Qt.AlignTop

			height: Properties.toolBarHeight
			width: parent.width

			color: Colors.darkGray

			RowLayout {
				anchors.fill: parent

				anchors.leftMargin: Properties.margin
				anchors.rightMargin: Properties.margin

				PLabel {
					id: title

					font: Fonts.title
					lineHeight: Fonts.titleHeight

					color: Colors.text

					text: "Pomiary"
				}

				Item {
					Layout.fillWidth: true
				}
			}
		}

		MeasurementItem {
			id: lastMeasurement

			isLastOne: true

			visible: (measurement)
		}

		Rectangle {
			id: emptyLabelBorder

			border.width: 1
			border.color: Colors.text
			color: "transparent"
			radius: 20

			Layout.topMargin: 100
			Layout.alignment: Qt.AlignHCenter

			width: 200
			height: 100

			visible: (!lastMeasurement.visible)

			PLabel {
				id: emptyLabel

				anchors.centerIn: parent
				horizontalAlignment: Text.AlignHCenter

				font: Fonts.caption
				lineHeight: Fonts.captionHeight

				text: "Brak pomiarów"
			}
		}

		Item {
			Layout.fillHeight: true
		}

		PButton {
			id: currentMeasurement

			Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

			flat: false

			enabled: (!emptyLabelBorder.visible)

			text: "Historia pomiarów"

			onClicked: {
				loader.setSource("qrc:/qml/Progress/MeasurementsHistoryDialog.qml",
								 {
									"user": currentUser
								 })
			}
		}

		PButton {
			id: addMeasurement

			Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

			flat: false

			text: "Dodaj pomiar"

			enabled: form.isMeasurementAddAvailable()

			onClicked: {
				loader.setSource("qrc:/qml/Progress/AddMeasurementModal.qml")
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
