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

	signal mainStackReady

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

	Component.onCompleted: {
		window.currentPage = AppWindow.PAGES.HOME
		window.forceActiveFocus()
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

	SwipeView {
		id: mainStack

		anchors.fill: parent

		property bool isReady: false

		Repeater {
			model: navigationBarModel

			delegate: Loader {
				width: mainStack.width
				height: mainStack.height

				source: model.url

				onLoaded: {
					item.width = width

					if (!mainStack.isReady && (index === 0)) {
						mainStack.isReady = true
						mainStack.currentIndex = AppWindow.PAGES.HOME
						window.mainStackReady()
					}
				}
			}
		}

		onCurrentIndexChanged: {
			if (!mainStack.isReady)
				return

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
