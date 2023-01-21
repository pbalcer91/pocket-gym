import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import Properties

Switch {
	id: control

	Material.accent: Colors.primary

	padding: 0

	contentItem: PLabel {
		font: Fonts.input
		lineHeight: Fonts.inputHeight
		color: (control.down ?
					Colors.primary
				  : Colors.text)
		text: control.text
	}

	indicator: Rectangle {
		implicitWidth: 40
		implicitHeight: 20
		x: control.width - width - control.rightPadding
		y: control.height / 2 - height / 2
		radius: implicitHeight / 2
		color: control.checked ? Colors.primary_light : Colors.input
		border.color: Colors.black

		opacity: (control.down == true ||
				  control.enabled == false ?
					  0.5
					: 1)

		Rectangle {
			x: control.checked ? parent.width - width : 0
			height: parent.height
			width: height
			radius: height / 2
			border.color: Colors.black
			color: control.checked ? Colors.primary : Colors.white
		}
	}

	function refreshIndicatorX() {
		indicator.x = control.width - implicitIndicatorWidth - control.rightPadding
	}

	onWidthChanged: {
		Qt.callLater(refreshIndicatorX)
	}

	onImplicitIndicatorWidthChanged: {
		Qt.callLater(refreshIndicatorX)
	}

	onRightPaddingChanged: {
		Qt.callLater(refreshIndicatorX)
	}
}
