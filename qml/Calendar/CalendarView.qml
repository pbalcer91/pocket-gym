import QtQuick
import QtQuick.Layouts

import Components
import Properties

Column {
	id: content

	PCalendar {
		id: calendar

		width: parent.width
	}

	Item {
		width: 1
		height: Properties.margin
	}

	Rectangle {
		color: Colors.primary_70

		height: 1
		width: parent.width - Properties.margin * 2

		anchors.horizontalCenter: parent.horizontalCenter
	}

	Item {
		width: 1
		height: Properties.margin
	}
}
