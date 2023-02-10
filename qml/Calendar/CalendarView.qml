import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Components
import Properties

import pl.com.thesis

ColumnLayout {
	id: content

	PCalendar {
		id: calendar

		width: parent.width

		addButton.onClicked: {
			loader.setSource("qrc:/qml/Calendar/EditEventModal.qml",
							 {
								 "day": calendar.selectedDay,
								 "month": calendar.selectedMonth,
								 "year": calendar.selectedYear
							 })
		}
	}

	function getDateString(date) {
		var day = ""

		if (date.getDate() < 10)
			day += "0"
		day += date.getDate()

		var month = ""

		if (date.getMonth() < 10)
			month += "0"
		month += date.getMonth() + 1

		var year = ""

		year += date.getFullYear()

		return (day + "/" + month + "/" + year)
	}

	Connections {
		target: MainController

		function onEventsReady(eventsList) {
			eventsModel.clear()

			for(var event in eventsList) {
				eventsModel.append({"name": event,
									   "date": getDateString(eventsList[event])})
			}
		}
	}

	Item {
		width: 1
		height: Properties.spacing
	}

	Rectangle {
		color: Colors.primary_70

		height: 1
		width: parent.width - Properties.margin * 2

		Layout.alignment: Qt.AlignHCenter
	}

	Item {
		width: 1
		height: Properties.spacing
	}

	ScrollView {
		id: scrollView

		background: Rectangle {
			color: "transparent"

			Rectangle {
				width: parent.width
				height: 1
				color: Colors.black

				anchors.top: parent.top
				anchors.horizontalCenter: parent.horizontalCenter

				visible: (!eventsList.atYBeginning)
			}

			Rectangle {
				width: parent.width
				height: 1
				color: Colors.black

				anchors.bottom: parent.bottom
				anchors.horizontalCenter: parent.horizontalCenter

				visible: (!eventsList.atYEnd)
			}
		}

		Layout.fillWidth: true
		Layout.fillHeight: true

		Layout.leftMargin: Properties.margin
		Layout.rightMargin: Properties.margin
		Layout.bottomMargin: Properties.margin

		contentHeight: (eventsList.model.count === 0 ?
							72
						  : 72 * eventsList.model.count)
		contentWidth: content.width

		clip: true

		ScrollBar.vertical.policy: ScrollBar.AlwaysOff
		ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

		PListView {
			id: eventsList

			Layout.fillWidth: true

			boundsBehavior: Flickable.StopAtBounds

			emptyInfo: "Brak wydarzeń w tym dniu"

			model: PListModel {
				id: eventsModel

				fillModel: function() {

				}
			}

			delegate: EventItem {
				implicitWidth: eventsList.width

				name: model.name
				date: model.date
			}
		}
	}

	Loader {
		id: loader

		onLoaded: {
			loader.item.closed.connect(function() {
				if (!loader)
					return
				loader.source = ""
			})

			loader.item.open()
		}
	}
}
