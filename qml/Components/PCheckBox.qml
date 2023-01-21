import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Properties

CheckBox {
	id: form

	implicitWidth: 20
	implicitHeight: 20

	leftInset: 0
	rightInset: 0
	topInset: 0
	bottomInset: 0

	topPadding: 10
	bottomPadding: 0
	leftPadding: 0
	rightPadding: 0

	indicator: Rectangle {
		implicitWidth: form.implicitWidth
		implicitHeight: form.implicitHeight
		radius: implicitHeight / 2
		color: Colors.input
		border.color: Colors.primary
		border.width: (form.checked ? 1 : 2)

		Rectangle {
			width: parent.width - 6
			height: parent.height - 6
			x: 3
			y: 3
			radius: parent.radius
			color: form.down ? Colors.primary_70 : Colors.primary
			visible: form.checked
		}
	}
}
