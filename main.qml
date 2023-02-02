import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Properties

ApplicationWindow {
	id: window

	visible: true
	title: qsTr("Pocket Gym")

	Component.onCompleted: {
		Properties.appWindow = this
	}

	/*	ICONS CREDITS
	  https://www.svgrepo.com/page/licensing
	  CC Licence
	*/

	onClosing: function(close) {
		console.warn("Closing app is blocked by developer")
		close.accepted = false
	}

	Loader {
		id: appLoader
		anchors.fill: parent
		visible: true
		asynchronous: true

		//source: "qrc:/qml/AppWindow.qml"
	}

	Loader {
		id: logInLoader
		anchors.fill: parent
		visible: true
		asynchronous: true

		source: "qrc:/qml/LogInView.qml"
	}
}
