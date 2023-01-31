import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Properties

ColumnLayout {
	id: form

	property alias title: title.text
	property alias headerButton: headerButton

	default property alias content: mainContent.data

	spacing: 0

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
			}

			Item {
				Layout.fillWidth: true
			}

			PButton {
				id: headerButton

				implicitHeight: title.implicitHeight
				implicitWidth: implicitHeight

				radius: Properties.radius

				visible: (text.length != 0 || icon.source != "")
			}
		}
	}

	ColumnLayout {
		id: mainContent

		width: parent.width

		Layout.alignment: Qt.AlignTop
	}
}
