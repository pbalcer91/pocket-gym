import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	implicitWidth: content.implicitWidth
	implicitHeight: content.implicitHeight

	ColumnLayout {
		id: content

		anchors.fill: parent

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

					text: "Katalog ćwiczeń"
				}

				Item {
					Layout.fillWidth: true
				}
			}
		}

		GridLayout {
			id: mainGrid

			Layout.fillHeight: true
			Layout.fillWidth: true

			Layout.topMargin: Properties.smallMargin
			Layout.bottomMargin: Properties.smallMargin
			Layout.leftMargin: Properties.margin
			Layout.rightMargin: Properties.margin

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
