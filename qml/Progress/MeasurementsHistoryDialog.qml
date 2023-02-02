import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

PDialog {
	id: dialog

	title: "Pomiary"

	required property User user

	PListModel {
		id: measurementsModel

		fillModel: function() {
			var measurements = user.measurements

			for (var i = measurements.length - 1; i >= 0; i--) {
				append({"measurement": measurements[i]})
			}
		}
	}

	SwipeView {
		id: swipeView

		anchors.fill: parent

		Repeater {
			model: measurementsModel

			delegate: Item {
				Layout.fillHeight: true
				Layout.fillWidth: true

				property Measurement measurement: model.measurement

				MeasurementItem {
					id: measurementItem
					implicitWidth: parent.implicitWidth

					measurement: parent.measurement
				}

				Item {
					Layout.fillHeight: true
				}
			}
		}
	}

	footer: Rectangle {
		id: footer

		height: Properties.toolBarHeight
		width: parent.width

		color: Colors.darkGray

		ScrollView {
			clip: true

			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			width: Math.min(footer.width, pageIndicator.width)

			Flickable {
				id: toolbarFlickable
				anchors.fill: parent
				contentWidth: pageIndicator.width
				contentHeight: pageIndicator.height

				function flickToIndex(index) {
					toolbarFlickable.contentX = Math.min(
								Math.max(index * (footer.width / 2)
										 - (toolbarFlickable.width - footer.width / 2) * 0.5,
										 0),
								contentWidth - toolbarFlickable.width)
				}

				Behavior on contentX {
					NumberAnimation {
						duration: 500
					}
				}

				PageIndicator {
					id: pageIndicator
					currentIndex: swipeView.currentIndex
					count: swipeView.count
					interactive: true

					spacing: 0

					Component.onCompleted: {
						toolbarFlickable.flickToIndex(currentIndex)
					}

					onCurrentIndexChanged: {
						swipeView.currentIndex = currentIndex
						toolbarFlickable.flickToIndex(currentIndex)
					}

					delegate: Rectangle {
						id: rootContainer
						implicitWidth: columnLayout.implicitWidth
						implicitHeight: Properties.toolBarHeight
						property bool activeItem: (index === pageIndicator.currentIndex)
						color: "transparent"

						opacity: index === pageIndicator.currentIndex ? 0.95 : pressed ? 0.7 : 0.45

						anchors.leftMargin: (index === 0 ? 200 : 0)
						anchors.rightMargin: (index === swipeView.count - 1 ? 200 : 0)

						ColumnLayout {
							id: columnLayout
							anchors.fill: parent
							spacing: 0

							PLabel {
								id: label

								text: Qt.formatDate((swipeView.itemAt(index).measurement.date), "dd.MM.")
								horizontalAlignment: Text.AlignHCenter
								font: rootContainer.activeItem ? Fonts.subTitle : Fonts.caption
								lineHeight: rootContainer.activeItem ? Fonts.subTitleHeight : Fonts.captionHeight
								color: rootContainer.activeItem ? Colors.primary : Colors.text_50
								Layout.preferredWidth: footer.width / 2
								wrapMode: Text.NoWrap
								elide: Text.ElideRight
							}
						}

						Behavior on opacity {
							OpacityAnimator {
								duration: 100
							}
						}
					}
				}
			}
		}
	}
}
