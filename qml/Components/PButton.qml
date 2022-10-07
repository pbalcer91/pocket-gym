import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Properties

Button {
	id: form

	property color color
	property int iconSize: Properties.iconSize

	implicitWidth: Math.max(iconSize,
							contentItem.implicitWidth)
	implicitHeight: Math.max(iconSize,
							contentItem.implicitHeight)

	contentItem: GridLayout {
		PIconImage {
			Layout.alignment: Qt.AlignCenter
			implicitHeight: form.iconSize
			implicitWidth: form.iconSize

			source: form.icon.source
			color: form.color

			fillMode: Image.PreserveAspectFit
			visible: (source.toString() !== "")
		}
	}
}
