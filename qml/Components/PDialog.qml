import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

Dialog {
	id: dialog

	property alias editButton: editButton
	property alias backButton: backButton

	property bool editModeAvailable: false

	parent: Overlay.overlay

	standardButtons: Dialog.NoButton
	modal: false

	closePolicy: Popup.NoAutoClose

	width: Properties.screenSize.width
	height: Properties.screenSize.height

	background: Rectangle{
		color: Colors.background
	}

	header: ToolBar {
		id: header

		background: Rectangle {
			color: Colors.darkGray
		}

		height: Properties.toolBarHeight

		RowLayout {
			anchors.fill: parent

			PButton {
				id: backButton

				icon.source: "qrc:/icons/ic_chevronLeft.svg"

				onClicked: {
					dialog.reject()
				}
			}

			PLabel {
				id: title

				text: dialog.title

				font: Fonts.title
				lineHeight: Fonts.titleHeight
			}

			Item {
				Layout.fillWidth: true
			}

			PButton {
				id: editButton

				icon.source: "qrc:/icons/ic_edit.svg"

				visible: dialog.editModeAvailable
			}
		}
	}
}
