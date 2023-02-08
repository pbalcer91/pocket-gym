import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Properties

import pl.com.thesis

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

	Connections {
		target: MainController

		function onUserLoggedOut() {
			appLoader.source = ""
			logInLoader.source = "qrc:/qml/LogInView.qml"
		}
	}

	onClosing: function(close) {
		console.warn("Closing app is blocked by developer")
		close.accepted = false
	}

	Loader {
		id: appLoader
		anchors.fill: parent
		visible: true
		asynchronous: true
	}

	Loader {
		id: logInLoader
		anchors.fill: parent
		visible: true
		asynchronous: true

		source: "qrc:/qml/LogInView.qml"

		onLoaded: {
			logInLoader.item.loggedIn.connect(function() {
				appLoader.source = "qrc:/qml/AppWindow.qml"
				source = ""
			})
		}
	}
}
