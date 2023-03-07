import QtQuick
import Qt5Compat.GraphicalEffects

import Properties

Item {
	id: form

	property alias source: icon.source
	property color color: Colors.primary
	property alias fillMode: icon.fillMode

	implicitWidth: Properties.iconSize
	implicitHeight: Properties.iconSize

	Image {
		id: icon

		anchors.fill: parent

		sourceSize.width: parent.implicitWidth
		sourceSize.height: parent.implicitHeight

		antialiasing: true
		visible: false
	}

	ColorOverlay {
			anchors.fill: icon
			source: icon
			color: form.color
			antialiasing: true
		}
}
