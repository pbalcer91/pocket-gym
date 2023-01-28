import QtQuick
import QtQuick.Layouts

import Components
import Properties


Item {
	id: form

	Layout.fillWidth: true

	implicitWidth: mainColumn.implicitWidth + Properties.smallMargin * 2
	implicitHeight: mainColumn.implicitHeight + Properties.smallMargin

	property alias label: label.text
	property alias sectionButton: sectionButton

	property alias listView: listView

	default property alias content: mainContent.data

	Rectangle {
		id: background

		anchors.fill: parent
		radius: 20
		color: Colors.sectionBackground
	}

	ColumnLayout {
		id: mainColumn

		anchors.fill: parent
		anchors.topMargin: 0
		anchors.bottomMargin: Properties.smallMargin
		anchors.leftMargin: Properties.smallMargin
		anchors.rightMargin: Properties.smallMargin

		RowLayout {
			id: labelRow

			Layout.fillWidth: true

			PLabel {
				id: label

				font: Fonts.subTitle
				lineHeight: Fonts.subTitleHeight

				color: Colors.text
			}

			Item {
				Layout.fillWidth: true
			}

			PButton {
				id: sectionButton

				visible: (text != "" || icon.source != "")
			}
		}

		ColumnLayout {
			id: mainContent

			Layout.fillHeight: true

			Layout.leftMargin: Properties.smallMargin
			Layout.rightMargin: Properties.smallMargin

			PListView {
				id: listView

				Layout.fillHeight: true
				Layout.fillWidth: true

				boundsBehavior: Flickable.StopAtBounds
			}
		}
	}
}
