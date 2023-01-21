import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Properties
import Components

import pl.com.thesis

Page {
	id: window

	background: Rectangle {
		color: Colors.background
	}

	property int currentPage: -1

	enum PAGES {
		SETTINGS,
		PROGRESS,
		HOME,
		EXERCISES,
		CALENDAR,
		UNDEFINED
	}

	function showMessage(args) {
		if (messageDialogLoader.status != Loader.Null){
			console.warn("Multiple messageDialogs need to be handle!")
		}

		messageDialogLoader.setSource("qrc:/qml/Components/PMessageDialog.qml", args)
	}

	//TODO: usunac to
	function showAppCloseMessage() {
		console.log("Proba zamkniecia aplikacji")
		showMessage({ "message": "Are you sure to close the app?",
						"acceptButtonText": "Yes",
						"rejectButtonText": "No" })	// do tłumaczenia
	}

	//TODO: obsluga klawisza back na telefonie
	Keys.onBackPressed: {
		//showAppCloseMessage()
	}

	Component.onCompleted: {
		window.currentPage = AppWindow.PAGES.HOME
		window.forceActiveFocus()

		MainController.createUser()
	}

	PListModel {
		id: navigationBarModel

		fillModel: function() {
			append({"index": AppWindow.PAGES.SETTINGS,
					   "icon": "qrc:/icons/ic_settings.svg",
					   "url": "qrc:/qml/Settings/SettingsView.qml"})
			append({"index": AppWindow.PAGES.PROGRESS,
					   "icon": "qrc:/icons/ic_progress.svg",
					   "url": "qrc:/qml/Progress/ProgressView.qml"})
			append({"index": AppWindow.PAGES.HOME,
					   "icon": "qrc:/icons/ic_home.svg",
					   "url": "qrc:/qml/Home/HomeView.qml"})
			append({"index": AppWindow.PAGES.EXERCISES,
					   "icon": "qrc:/icons/ic_training.svg",
					   "url": "qrc:/qml/Exercises/ExercisesView.qml"})
			append({"index": AppWindow.PAGES.CALENDAR,
					   "icon": "qrc:/icons/ic_calendar.svg",
					   "url": "qrc:/qml/Calendar/CalendarView.qml"})
		}

		onModelReady: {
			mainStack.currentIndex = window.currentPage
			mainStack.positionViewAtIndex(window.currentPage, ListView.SnapPosition)
		}
	}

	footer: ToolBar {
		id: footer

		background: Rectangle {
			color: Colors.darkGray
		}

		height: Properties.toolBarHeight

		RowLayout {
			anchors.fill: parent

			Flow {
				Layout.fillWidth: true
				height: navigationBar.implicitHeight

				Layout.alignment: Qt.AlignCenter

				leftPadding: Properties.margin
				rightPadding: Properties.margin

				spacing: ((width - navigationBarModel.count * footer.height
						   - leftPadding - rightPadding) / (navigationBarModel.count - 1))

				Repeater {
					id: navigationBar

					model: navigationBarModel

					delegate: Item {

						implicitHeight: footer.height
						implicitWidth: footer.height

						Rectangle {
							width: footer.height
							height: Properties.selectIndicatorHeight
							radius: Properties.radius

							color: Colors.primary

							anchors.bottom: parent.bottom
							anchors.horizontalCenter: parent.horizontalCenter

							visible: (model.index === window.currentPage)
						}

						PButton {
							anchors.fill: parent

							flat: true
							color: (model.index === window.currentPage ?
										Colors.primary : Colors.primary_70)

							icon.source: model.icon
							iconSize: (model.index === window.currentPage ?
										   Properties.iconSize : Properties.smallIconSize)

							Behavior on iconSize {
								NumberAnimation {
									duration: 50
									easing.type: Easing.Linear
								}
							}

							onClicked: {
								if (window.currentPage === model.index)
									return

								window.currentPage = model.index
								mainStack.currentIndex = window.currentPage
							}
						}
					}
				}
			}
		}
	}

	ListView {
		id: mainStack

		anchors.fill: parent

		snapMode: ListView.SnapOneItem
		orientation: ListView.Horizontal

		model: navigationBarModel

		highlightRangeMode: ListView.StrictlyEnforceRange
		highlightMoveDuration: 100

		boundsBehavior: Flickable.StopAtBounds

		interactive: false

		delegate: Loader {
			width: ListView.view.width
			height: ListView.view.height

			source: model.url

			onLoaded: {
				item.width = width
			}
		}

		onCurrentIndexChanged: {
			if (window.currentPage != currentIndex)
				window.currentPage = currentIndex
		}
	}

	Loader {
		id: messageDialogLoader

		onLoaded: {
			messageDialogLoader.item.closed.connect(function() {
				if (!messageDialogLoader)
					return
				messageDialogLoader.source = ""
			})
			messageDialogLoader.item.open()
		}
	}
}
