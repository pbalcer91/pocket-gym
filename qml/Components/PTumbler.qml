import QtQuick
import QtQuick.Controls

import Properties

Tumbler {
	id: control

	leftInset: 0
	rightInset: 0

	visibleItemCount: 3

	background: Rectangle {
		id: backgroundRect
		border.width: 0
		border.color: Colors.black
		color: "transparent"
		radius: Properties.radius
	}

	implicitHeight: visibleItemCount * 50
	implicitWidth: 60

	required property PListModel listModel
	required property string  textRole

	property bool highlightEnabled: true

	model: listModel

	delegate: PLabel {
		id: delgateLabel

		required property int index
		required property var model

		text: model[control.textRole]
		opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		font: (Math.abs(control.currentIndex - index) == 0 ?
				   Fonts.tumblerMainLabel
				 : Fonts.tumblerSubLabel)

		lineHeight: (Math.abs(control.currentIndex - index) == 0 ?
						Fonts.tumblerMainLabelHeight
					  : Fonts.tumblerSubLabelHeight)

		color: Colors.text
		wrapMode: Text.NoWrap

		background: Item {
			visible: (highlightEnabled && control.currentIndex === index)

			Rectangle {
				width: parent.width * 0.8
				height: 3
				radius: height * 0.5
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.top: parent.top
				color: Colors.primary_70
			}

			Rectangle {
				width: parent.width * 0.8
				height: 3
				radius: height * 0.5
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.bottom: parent.bottom
				color: Colors.primary_70
			}
		}
	}

	Component {
		id: nonWrapComponent
		ListView {
			id: list
			model: control.model
			delegate: control.delegate

			snapMode: PListView.SnapToItem
			highlightRangeMode: PListView.StrictlyEnforceRange
			highlightMoveDuration: 100
			preferredHighlightBegin: height / 2 - (height / control.visibleItemCount / 2)
			preferredHighlightEnd: height / 2 + (height / control.visibleItemCount / 2)
			clip: true
		}
	}

	Loader {
		id: contentItemLoader
		sourceComponent: nonWrapComponent
		onLoaded: {
			control.contentItem = contentItemLoader.item
		}
	}
}
