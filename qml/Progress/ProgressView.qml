import QtQuick
import QtQuick.Layouts
import QtCharts

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

			lastMeasurement.fill()
		}
	}

	Component.onCompleted: {
		MainController.getDatabaseMeasurementsByUserId(currentUser.id)
	}

	function isMeasurementAddAvailable() {
		if (!lastMeasurement.measurement)
			return false

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

		LastMeasurementItem {
			id: lastMeasurement
		}

		Item {
			Layout.fillHeight: true
		}

		PButton {
			id: currentMeasurement

			Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

			flat: false

			text: "Historia pomiarów"
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
