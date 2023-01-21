import QtQuick
import QtQuick.Layouts

import Components
import Properties

Item {
	id: form

	implicitWidth: content.implicitWidth + Properties.smallMargin
	implicitHeight: (editMode ? 72 : 56)

	property alias label: setIndex.text

	property bool editMode: false

	property int repeatsCount: 1
	property bool isMax: false

	signal repeatsIncreased
	signal repeatDecreased
	signal maxChanged
	signal removed

	Rectangle {
		id: background

		anchors.fill: parent

		color: "transparent"
		radius: 20
		border.color: Colors.primary
		border.width: 1
	}

	RowLayout {
		id: content

		anchors.fill: parent

		anchors.leftMargin: Properties.smallMargin
		anchors.topMargin: 6
		anchors.bottomMargin: 6

		spacing: 0

		ColumnLayout {
			Layout.alignment: Qt.AlignVCenter

			spacing: 0

			PLabel {
				id: setLabel

				Layout.alignment: Qt.AlignCenter
				horizontalAlignment: Text.AlignHCenter

				text: "Seria"
				color: Colors.text

				font: Fonts.button
			}

			PLabel {
				id: setIndex

				Layout.alignment: Qt.AlignCenter
				horizontalAlignment: Text.AlignHCenter

				text: ""
				color: Colors.text

				font: Fonts.list
			}
		}

		Item {
			Layout.fillWidth: true
		}

		Rectangle {
			Layout.fillHeight: true
			width: 1
			color: Colors.primary_30
		}

		Item {
			Layout.fillWidth: true
		}

		PButton {
			id: repeatDecreaseButton

			Layout.alignment: Qt.AlignVCenter

			visible: editMode

			text: "-"
			font: Fonts.tumblerSubLabel

			leftPadding: 6
			rightPadding: 6

			onClicked: {
				if (form.repeatsCount == 1)
					return

				form.repeatsCount--
				form.repeatDecreased()
			}
		}

		ColumnLayout {
			Layout.alignment: Qt.AlignVCenter
			Layout.leftMargin: 6
			Layout.rightMargin: 6

			spacing: 0

			PLabel {
				id: repeatLabel

				Layout.alignment: Qt.AlignHCenter
				horizontalAlignment: Text.AlignHCenter

				text: "Powtórzenia"
				color: Colors.text

				font: Fonts.button
			}

			PLabel {
				id: repeatCount

				Layout.alignment: Qt.AlignCenter
				horizontalAlignment: Text.AlignHCenter

				text: (!editMode && isMax ? form.repeatsCount + " (max)"
										  : form.repeatsCount)
				color: Colors.text

				font: Fonts.list
			}
		}

		PButton {
			id: repeatIncreaseButton

			Layout.alignment: Qt.AlignVCenter

			visible: editMode

			leftPadding: 6
			rightPadding: 6

			text: "+"
			font: Fonts.tumblerSubLabel

			onClicked: {
				form.repeatsCount++
				form.repeatsIncreased()
			}
		}

		Item {
			Layout.fillWidth: true
		}

		Rectangle {
			Layout.fillHeight: true
			width: 1
			color: Colors.primary_30

			visible: editMode
		}

		Item {
			Layout.fillWidth: true
		}

		ColumnLayout {
			Layout.alignment: Qt.AlignVCenter

			visible: editMode

			spacing: 0

			PLabel {
				id: maxLabel

				Layout.alignment: Qt.AlignHCenter
				horizontalAlignment: Text.AlignHCenter

				text: "Max"
				color: Colors.text

				font: Fonts.button
			}

			PCheckBox {
				id: maxCheckBox

				Layout.alignment: Qt.AlignHCenter

				visible: editMode

				checked: form.isMax

				onCheckedChanged: {
					form.maxChanged()
				}
			}
		}

		PButton {
			id: deleteButton

			Layout.alignment: Qt.AlignVCenter
			Layout.leftMargin: Properties.smallMargin

			visible: editMode

			icon.source: "qrc:/icons/ic_delete.svg"

			onClicked: {
				form.removed()
			}
		}
	}
}
