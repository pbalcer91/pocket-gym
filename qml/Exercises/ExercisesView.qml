import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	implicitWidth: content.implicitWidth + Properties.margin * 2
	implicitHeight: content.implicitHeight + Properties.smallMargin * 2

	ColumnLayout {
		id: content

		anchors.fill: parent
		anchors.topMargin: Properties.smallMargin
		anchors.bottomMargin: Properties.smallMargin
		anchors.leftMargin: Properties.margin
		anchors.rightMargin: Properties.margin


		spacing: Properties.margin

		RowLayout {
			Layout.fillWidth: true

			PLabel {
				id: title

				text: "Katalog ćwiczeń"
				font: Fonts.title
				lineHeight: Fonts.titleHeight

				Layout.alignment: Qt.AlignTop
			}
		}

		GridLayout {
			id: mainGrid

			Layout.fillHeight: true
			Layout.fillWidth: true

			columnSpacing: Properties.smallMargin
			rowSpacing: Properties.smallMargin

			columns: 2
			rows: 4

			Repeater {
				model: ExerciseCategoriesModel {
					id: categoriesModel
				}

				delegate: PButton {
					Layout.fillHeight: true
					Layout.fillWidth: true

					implicitWidth: mainGrid.width / 2

					isBorder: true
					text: model.name

					wrap: Text.WordWrap
				}
			}
		}
	}
}
