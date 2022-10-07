import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Properties
import Components

Page {
	id: window

	property int currentPage: -1

	enum PAGES {
		SETTINGS,
		PROGRESS,
		HOME,
		TRAINING,
		CALENDAR,
		UNDEFINED
	}

	PListModel {
		id: navigationBarModel

		fillModel: () => {
					   append({"index": AppWindow.PAGES.SETTINGS,
								  "icon": "qrc:/icons/ic_settings.svg"})
					   append({"index": AppWindow.PAGES.PROGRESS,
								  "icon": "qrc:/icons/ic_progress.svg"})
					   append({"index": AppWindow.PAGES.HOME,
								  "icon": "qrc:/icons/ic_home.svg"})
					   append({"index": AppWindow.PAGES.TRAINING,
								  "icon": "qrc:/icons/ic_training.svg"})
					   append({"index": AppWindow.PAGES.CALENDAR,
								  "icon": "qrc:/icons/ic_calendar.svg"})
				   }

		onModelReady: {
			mainStack.currentIndex = window.currentPage
			mainStack.positionViewAtIndex(window.currentPage, ListView.SnapPosition)
		}
	}

	header: ToolBar {
		id: header

		height: Properties.toolBarHeight

		background: Rectangle {
			color: Colors.darkGray
		}

		RowLayout {
			anchors.fill: parent

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

		delegate: Rectangle {
			color: Colors.white
			width: ListView.view.width
			height: ListView.view.height

			Text {
				anchors.centerIn: parent
				text: model.index
			}
		}

		onCurrentIndexChanged: {
			if (window.currentPage != currentIndex)
				window.currentPage = currentIndex
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
				id: flow

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

	Component.onCompleted: {
		window.currentPage = AppWindow.PAGES.HOME
	}
}
