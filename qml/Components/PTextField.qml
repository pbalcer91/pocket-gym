import QtQuick
import QtQuick.Controls

import Properties

TextField {
	id: textField

	property bool passwordMode: false
	property bool isMultiline: false

	property alias label: label.text

	verticalAlignment: (isMultiline ? Text.AlignTop : Text.AlignVCenter)
	wrapMode:  (isMultiline ? Text.WordWrap : Text.NoWrap)

	Component.onCompleted: {
		if (isMultiline)
			implicitHeight = 150
	}

	onEditingFinished: {
		textField.focus = false
	}

	topInset: 0
	bottomInset: 0
	leftInset: 0
	rightInset: 0

	leftPadding: 16
	rightPadding: 16
	topPadding: (label.text != "" ? 24 : 12)
	bottomPadding: (label.text != "" ? 4 : 12)

	font: Fonts.input
	color: (textField.enabled ? Colors.black : Colors.black_30)
	placeholderTextColor: (textField.enabled ? Colors.black_30 : "transparent")

	echoMode: (passwordMode ? TextInput.Password : TextInput.Normal)
	//passwordCharacter: Properties.passwordCharacter

	cursorDelegate: Rectangle {
		id: cursor
		visible: false
		color: Colors.black
		width: textField.cursorRectangle.width

		SequentialAnimation {
			loops: Animation.Infinite
			running: textField.cursorVisible

			PropertyAction {
				target: cursor
				property: 'visible'
				value: true
			}

			PauseAnimation {
				duration: 600
			}

			PropertyAction {
				target: cursor
				property: 'visible'
				value: false
			}

			PauseAnimation {
				duration: 600
			}

			onStopped: {
				cursor.visible = false
			}
		}
	}

	background: Rectangle {
		color: Colors.input
		opacity: (textField.readOnly ? 0.8 : 1.0)

		radius: 20

		Rectangle {
			id: innerBackground
			anchors.fill: parent
			radius: parent.radius

			color: Colors.primary_70

			visible: (textField.activeFocus && !textField.readOnly)
		}
	}

	PLabel {
		id: label

		font: Fonts.inputLabel
		lineHeight: Fonts.inputLabelHeight
		color: ((textField.activeFocus && !textField.readOnly) ?
					Colors.black
				  : Colors.primary)
		elide: Text.ElideRight

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right

		anchors.topMargin: 2
		anchors.leftMargin: 16
		anchors.rightMargin: 48
	}

	states: [
		State {
			name: "error"
			PropertyChanges {
				target: (textField.background as Rectangle)
				border.color: Colors.errorBorder
				border.width: 1
			}
			PropertyChanges {
				target: innerBackground
				color: Colors.error
				visible: true
				opacity: 0.5
			}
			PropertyChanges {
				target: label
				color: ((textField.activeFocus && !textField.readOnly) ?
							Colors.black
						  : Colors.error)
			}
		}
	]
}
