import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Properties

Button {
	id: form

	flat: !isFloating

	clip: true

	property color color: (!enabled ? Colors.white
									: flat ?
										  Colors.primary
										: Colors.black)
	property int iconSize: Properties.iconSize
	property bool isBorder: false
	property bool isFloating: false

	property bool isLeftIcon: true
	property bool isRightIcon: false
	property alias horizontalAlignment: label.horizontalAlignment

	onIsRightIconChanged: {
		if (isRightIcon)
			isLeftIcon = false
	}

	property alias wrap: label.wrapMode

	font: (form.isFloating ? Fonts.floatingButton : Fonts.button)
	property int lineHeight: (form.isFloating ? Fonts.floatingButtonHeight : Fonts.buttonHeight)

	width: Math.max(iconSize,
					contentItem.implicitWidth)
	height: Math.max(iconSize,
					 contentItem.implicitHeight)

	leftInset: 0
	rightInset: 0
	topInset: 0
	bottomInset: 0

	topPadding: 12
	bottomPadding: 12
	leftPadding: 12
	rightPadding: 12

	opacity: (!enabled ?
				  0.5
				: isFloating ?
					  0.9
					:1)

	property int radius: Properties.buttonRadius

	background: Rectangle {
		color: (form.flat ? "transparent"
						  : !form.enabled ?
								Colors.white
							  : Colors.primary)

		border.color: Colors.primary
		border.width: (form.isBorder ? 1 : 0)

		radius: form.radius

		Rectangle {
			anchors.fill: parent
			radius: parent.radius
			color: (form.flat ? Colors.primary : Colors.black)

			opacity: (form.down || form.checked ? 0.2 : 0)

			Behavior on opacity {
				NumberAnimation {
					duration: 100
				}
			}
		}
	}

	contentItem: GridLayout {
		PIconImage {
			Layout.alignment: Qt.AlignCenter

			implicitHeight: form.iconSize
			implicitWidth: form.iconSize

			source: form.icon.source
			color: form.color

			fillMode: Image.PreserveAspectFit
			visible: (source.toString() !== "" && isLeftIcon)
		}

		PLabel {
			id: label

			text: form.text
			color: form.color

			font: form.font
			lineHeight: form.lineHeight

			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter

			elide: Text.ElideRight
			wrapMode: Text.NoWrap

			Layout.fillWidth: true
			Layout.fillHeight: true

			visible: (text.length > 0)
		}

		PIconImage {
			Layout.alignment: Qt.AlignCenter

			implicitHeight: form.iconSize
			implicitWidth: form.iconSize

			source: form.icon.source
			color: form.color

			fillMode: Image.PreserveAspectFit
			visible: (source.toString() !== "" && isRightIcon)
		}
	}
}
