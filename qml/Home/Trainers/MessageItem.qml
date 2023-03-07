import QtQuick
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis

Item {
	id: form

	implicitWidth: content.implicitWidth + Properties.smallMargin * 2
	implicitHeight: content.implicitHeight + Properties.smallMargin * 2
					+ authorLabel.height

	property alias message: message.text
	property string username

	property bool isReceived: false
	property alias authorVisible: authorLabel.visible

	anchors.right: (parent ? parent.right : undefined)

	Component.onCompleted: {
		if (isReceived)
			form.state = "received"
	}

	Rectangle {
		id: background

		anchors.top: authorLabel.bottom
		anchors.bottom: form.bottom
		anchors.left: form.left
		anchors.right: form.right

		color: (form.isReceived ?
					Colors.darkGray
				  : Colors.primary)
		radius: 20
	}

	PLabel {
		id: authorLabel

		font: Fonts.info
		lineHeight: Fonts.infoHeight

		anchors.top: form.top
		anchors.right: form.right

		height: (!visible ? 0 : undefined)

		anchors.leftMargin: Properties.spacing
		anchors.rightMargin: Properties.spacing

		text: (!visible ?
				   ""
				 : form.isReceived ?
					   form.username
					 : "Ja")
	}

	ColumnLayout {
		id: content

		anchors.fill: background

		anchors.topMargin: Properties.smallMargin
		anchors.bottomMargin: Properties.smallMargin
		anchors.leftMargin: Properties.smallMargin
		anchors.rightMargin: Properties.smallMargin

		PLabel {
			id: message

			color: (form.isReceived ?
						Colors.text
					  : Colors.darkGray)
		}
	}

	states: [
		State {
			name: "received"

			AnchorChanges {
				target: form
				anchors.left: (parent ? parent.left : undefined)
				anchors.right: undefined
				anchors.top: undefined
				anchors.bottom: undefined
			}

			AnchorChanges {
				target: authorLabel
				anchors.left: (parent ? parent.left : undefined)
				anchors.right: undefined
				anchors.top: undefined
				anchors.bottom: undefined
			}
		}
	]
}
