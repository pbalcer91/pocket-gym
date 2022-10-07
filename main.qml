import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Properties

ApplicationWindow {
	id: window

	visible: true
	title: qsTr("Pocket Gym")

	/*	ICONS CREDITS
	  https://www.svgrepo.com/page/licensing
	  CC Licence
	*/

	Loader {
		id: appLoader
		anchors.fill: parent
		visible: true
		asynchronous: true

		source: "qrc:/qml/AppWindow.qml"
	}
}
