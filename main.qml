import QtQuick
import QtQuick.Controls

import Properties

import pl.com.thesis

ApplicationWindow {
	id: window

	visible: true

	background: Rectangle {
		color: Colors.background
	}

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

	function notify(message) {
		if (notificationLoader.status != Loader.Null){
			console.warn("Multiple notifications need to be handle!")
			return
		}

		notificationLoader.setSource("qrc:/qml/Notification.qml",
									 {
										"message": message
									 })
	}

	Loader {
		id: appLoader
		anchors.fill: parent
		visible: false
		asynchronous: true

		onStatusChanged: {
			if (status == Loader.Ready)
				visible = true
		}
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

				notify("Poprawnie zalogowano")
			})
		}
	}

	Loader {
		id: notificationLoader
		asynchronous: true

		onLoaded: {
			notificationLoader.item.closed.connect(function() {
				if (!notificationLoader)
					return
				notificationLoader.source = ""
			})
			notificationLoader.item.open()
		}
	}
}
