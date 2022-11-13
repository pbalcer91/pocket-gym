import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Properties

Button {
	id: form

	flat: true

	property color color: (flat ? Colors.primary : Colors.white)
	property int iconSize: Properties.iconSize

	implicitWidth: Math.max(iconSize,
							contentItem.implicitWidth + Properties.padding * 2)
	implicitHeight: Math.max(iconSize,
							contentItem.implicitHeight + Properties.buttonPadding * 2)

	property int textTopPadding: Properties.buttonPadding
	property int textBottomPadding: Properties.buttonPadding
	property int textLeftPadding: Properties.padding
	property int textRightPadding: Properties.padding

	background: Rectangle {
		id: background

		color: (form.flat ? "transparent" : Colors.primary)

		radius: Properties.buttonRadius
	}

	contentItem: GridLayout {
		flow: GridLayout.LeftToRight
		layoutDirection: Qt.LeftToRight

		PIconImage {
			Layout.alignment: Qt.AlignCenter
			implicitHeight: form.iconSize
			implicitWidth: form.iconSize

			source: form.icon.source
			color: form.color

			fillMode: Image.PreserveAspectFit
			visible: (source.toString() !== "")
		}

		PLabel {
			text: form.text
			color: form.color

			font: Fonts.button
			lineHeight: Fonts.buttonHeight

			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter

			elide: Text.ElideRight
			wrapMode: Text.NoWrap

			Layout.fillWidth: true
			Layout.fillHeight: true

			topPadding: form.textTopPadding
			bottomPadding: form.textBottomPadding
			leftPadding: form.textLeftPadding
			rightPadding: form.textRightPadding

			visible: (text.length > 0)
		}
	}
}
