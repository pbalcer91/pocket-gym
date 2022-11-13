import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Properties

Drawer {
	id: messageDialog

	parent: Overlay.overlay

	interactive: false

	modal: true

	closePolicy: Popup.NoAutoClose
	clip: true

	height: priv.defaultHeight
	width: Properties.appWindow.width

	edge: Qt.BottomEdge

	property alias acceptButtonText: acceptButton.text
	property alias rejectButtonText: rejectButton.text
	property alias message: message.text

	signal accepted
	signal rejected

	background: Rectangle {
		color: Colors.background

		radius: Properties.radius

		Rectangle {
			color: parent.color

			height: parent.radius
			anchors.bottom: parent.bottom
			anchors.left: parent.left
			anchors.right: parent.right
		}
	}

	QtObject {
		id: priv

		property int defaultHeight: header.implicitHeight
									+ mainContent.implicitHeight
									+ footer.implicitHeight + Properties.margin + Properties.smallMargin * 2
	}

	Item {
		anchors.fill: parent

		anchors.leftMargin: Properties.margin
		anchors.rightMargin: Properties.margin

		ColumnLayout {
			anchors.fill: parent

			RowLayout {
				id: header

				Layout.fillWidth: true

				Layout.topMargin: Properties.smallMargin
			}

			ColumnLayout {
				id: mainContent

				Layout.fillWidth: true
				Layout.fillHeight: true

				PLabel {
					id: message

					color: Colors.white

					visible: (text != "")
				}
			}

			RowLayout {
				id: footer

				Layout.fillWidth: true

				Layout.topMargin: Properties.smallMargin
				Layout.bottomMargin: Properties.margin

				spacing: Properties.margin

				Item {
					Layout.fillWidth: true
				}

				PButton {
					id: acceptButton

					text: "Confirm"	// do tłumaczenia

					Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

					onClicked: {
						messageDialog.accepted()
						messageDialog.close()
					}
				}

				PButton {
					id: rejectButton

					text: "Cancel"	// do tłumaczenia

					Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

					onClicked: {
						messageDialog.rejected()
						messageDialog.close()
					}
				}

				Item {
					Layout.fillWidth: true
				}
			}
		}
	}
}
