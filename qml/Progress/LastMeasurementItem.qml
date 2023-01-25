import QtQuick
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	Layout.fillWidth: true

	implicitWidth: mainColumn.implicitWidth + Properties.margin * 2
	implicitHeight: mainColumn.implicitHeight

	property Measurement measurement

	function fill() {
		dateLabel.text = "Ostatni pomiar - " + Qt.formatDate(measurement.date, "dd.MM.yyyy")
		weight.text = measurement.weight + " kg"
		chest.text = measurement.chest + " cm"
		shoulders.text = measurement.shoulders + " cm"
		arm.text = measurement.arm + " cm"
		forearm.text = measurement.forearm + " cm"
		waist.text = measurement.waist + " cm"
		hips.text = measurement.hips + " cm"
		peace.text = measurement.peace + " cm"
		calf.text = measurement.calf + " cm"
	}

	onMeasurementChanged: {
		form.fill()
	}

	ColumnLayout {
		id: mainColumn

		anchors.fill: parent

		anchors.leftMargin: Properties.margin
		anchors.rightMargin: Properties.margin

		spacing: Properties.spacing

		PLabel {
			id: dateLabel

			font: Fonts.subTitle
			lineHeight: Fonts.subTitleHeight

			Layout.alignment: Qt.AlignHCenter

			color: Colors.text
		}

		Rectangle {
			color: Colors.primary_70

			height: 1

			Layout.leftMargin: Properties.margin
			Layout.rightMargin: Properties.margin
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignHCenter

			Layout.bottomMargin: Properties.margin
		}

		RowLayout {
			Layout.fillWidth: true

			Layout.leftMargin: Properties.margin * 2
			Layout.rightMargin: Properties.margin * 2

			PLabel {
				font: Fonts.caption
				lineHeight: Fonts.captionHeight

				Layout.alignment: Qt.AlignLeft
				horizontalAlignment: Text.AlignLeft

				color: Colors.text

				text: "Waga: "
			}

			Item {
				Layout.fillWidth: true
			}

			PLabel {
				id: weight
				font: Fonts.captionBold
				lineHeight: Fonts.captionBoldHeight

				Layout.alignment: Qt.AlignRight
				horizontalAlignment: Text.AlignRight

				color: Colors.text
			}
		}

		RowLayout {
			Layout.fillWidth: true

			Layout.leftMargin: Properties.margin * 2
			Layout.rightMargin: Properties.margin * 2

			PLabel {
				font: Fonts.caption
				lineHeight: Fonts.captionHeight

				Layout.alignment: Qt.AlignLeft
				horizontalAlignment: Text.AlignLeft

				color: Colors.text

				text: "Klatka piersiowa: "
			}


			Item {
				Layout.fillWidth: true
			}

			PLabel {
				id: chest
				font: Fonts.captionBold
				lineHeight: Fonts.captionBoldHeight

				Layout.alignment: Qt.AlignRight
				horizontalAlignment: Text.AlignRight

				color: Colors.text
			}
		}

		RowLayout {
			Layout.fillWidth: true

			Layout.leftMargin: Properties.margin * 2
			Layout.rightMargin: Properties.margin * 2

			PLabel {
				font: Fonts.caption
				lineHeight: Fonts.captionHeight

				Layout.alignment: Qt.AlignLeft
				horizontalAlignment: Text.AlignLeft

				color: Colors.text

				text: "Barki: "
			}


			Item {
				Layout.fillWidth: true
			}

			PLabel {
				id: shoulders
				font: Fonts.captionBold
				lineHeight: Fonts.captionBoldHeight

				Layout.alignment: Qt.AlignRight
				horizontalAlignment: Text.AlignRight

				color: Colors.text
			}
		}

		RowLayout {
			Layout.fillWidth: true

			Layout.leftMargin: Properties.margin * 2
			Layout.rightMargin: Properties.margin * 2

			PLabel {
				font: Fonts.caption
				lineHeight: Fonts.captionHeight

				Layout.alignment: Qt.AlignLeft
				horizontalAlignment: Text.AlignLeft

				color: Colors.text

				text: "Ramię: "
			}


			Item {
				Layout.fillWidth: true
			}

			PLabel {
				id: arm
				font: Fonts.captionBold
				lineHeight: Fonts.captionBoldHeight

				Layout.alignment: Qt.AlignRight
				horizontalAlignment: Text.AlignRight

				color: Colors.text
			}
		}

		RowLayout {
			Layout.fillWidth: true

			Layout.leftMargin: Properties.margin * 2
			Layout.rightMargin: Properties.margin * 2

			PLabel {
				font: Fonts.caption
				lineHeight: Fonts.captionHeight

				Layout.alignment: Qt.AlignLeft
				horizontalAlignment: Text.AlignLeft

				color: Colors.text

				text: "Przedramię: "
			}


			Item {
				Layout.fillWidth: true
			}

			PLabel {
				id: forearm
				font: Fonts.captionBold
				lineHeight: Fonts.captionBoldHeight

				Layout.alignment: Qt.AlignRight
				horizontalAlignment: Text.AlignRight

				color: Colors.text
			}
		}

		RowLayout {
			Layout.fillWidth: true

			Layout.leftMargin: Properties.margin * 2
			Layout.rightMargin: Properties.margin * 2

			PLabel {
				font: Fonts.caption
				lineHeight: Fonts.captionHeight

				Layout.alignment: Qt.AlignLeft
				horizontalAlignment: Text.AlignLeft

				color: Colors.text

				text: "Talia: "
			}


			Item {
				Layout.fillWidth: true
			}

			PLabel {
				id: waist
				font: Fonts.captionBold
				lineHeight: Fonts.captionBoldHeight

				Layout.alignment: Qt.AlignRight
				horizontalAlignment: Text.AlignRight

				color: Colors.text
			}
		}

		RowLayout {
			Layout.fillWidth: true

			Layout.leftMargin: Properties.margin * 2
			Layout.rightMargin: Properties.margin * 2

			PLabel {
				font: Fonts.caption
				lineHeight: Fonts.captionHeight

				Layout.alignment: Qt.AlignLeft
				horizontalAlignment: Text.AlignLeft

				color: Colors.text

				text: "Biodra: "
			}


			Item {
				Layout.fillWidth: true
			}

			PLabel {
				id: hips
				font: Fonts.captionBold
				lineHeight: Fonts.captionBoldHeight

				Layout.alignment: Qt.AlignRight
				horizontalAlignment: Text.AlignRight

				color: Colors.text
			}
		}

		RowLayout {
			Layout.fillWidth: true

			Layout.leftMargin: Properties.margin * 2
			Layout.rightMargin: Properties.margin * 2

			PLabel {
				font: Fonts.caption
				lineHeight: Fonts.captionHeight

				Layout.alignment: Qt.AlignLeft
				horizontalAlignment: Text.AlignLeft

				color: Colors.text

				text: "Udo: "
			}


			Item {
				Layout.fillWidth: true
			}

			PLabel {
				id: peace
				font: Fonts.captionBold
				lineHeight: Fonts.captionBoldHeight

				Layout.alignment: Qt.AlignRight
				horizontalAlignment: Text.AlignRight

				color: Colors.text
			}
		}

		RowLayout {
			Layout.fillWidth: true

			Layout.leftMargin: Properties.margin * 2
			Layout.rightMargin: Properties.margin * 2

			PLabel {
				font: Fonts.caption
				lineHeight: Fonts.captionHeight

				Layout.alignment: Qt.AlignLeft
				horizontalAlignment: Text.AlignLeft

				color: Colors.text

				text: "Łydka: "
			}


			Item {
				Layout.fillWidth: true
			}

			PLabel {
				id: calf
				font: Fonts.captionBold
				lineHeight: Fonts.captionBoldHeight

				Layout.alignment: Qt.AlignRight
				horizontalAlignment: Text.AlignRight

				color: Colors.text
			}
		}
	}
}
