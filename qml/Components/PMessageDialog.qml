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

	height: (priv.defaultHeight > Properties.appWindow.height * 0.7 ?
				 Properties.appWindow.height * 0.7
			   : priv.defaultHeight)
	width: Properties.appWindow.width

	Behavior on height {
		NumberAnimation {
			duration: 100
		}
	}

	edge: Qt.BottomEdge

	default property alias mainContent: mainContent.data

	property bool autoCloseMode: true

	property alias acceptButton: acceptButton
	property alias rejectButton: rejectButton
	property alias closeButton: closeButton

	property var acceptAction
	property var rejectAction

	property alias message: message.text
	property alias title: title.text

	property bool closeButtonAvailable: false

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

		property int defaultHeight: header.implicitHeight + Properties.smallMargin
									+ mainContent.implicitHeight
									+ footer.implicitHeight + Properties.margin +36
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

				PLabel {
					id: title

					visible: (text != "")

					font: Fonts.subTitle
					lineHeight: Fonts.subTitleHeight
				}

				Item {
					Layout.fillWidth: true
				}

				PButton {
					id: closeButton

					icon.source: "qrc:/icons/ic_close.svg"

					visible: messageDialog.closeButtonAvailable

					onClicked: {
						close()
					}
				}
			}

			ColumnLayout {
				id: mainContent

				Layout.fillWidth: true
				Layout.fillHeight: true

				PLabel {
					id: message

					Layout.fillWidth: true

					color: Colors.text

					visible: (text != "")
				}
			}

			RowLayout {
				id: footer

				Layout.fillWidth: true

				Layout.topMargin: Properties.margin
				Layout.bottomMargin: 36

				spacing: 60

				Item {
					Layout.fillWidth: true
				}

				PButton {
					id: rejectButton

					text: "Anuluj"	// do tłumaczenia

					Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

					onClicked: {
						if (rejectAction)
							rejectAction()

						messageDialog.rejected()

						if (autoCloseMode)
							messageDialog.close()
					}
				}

				PButton {
					id: acceptButton

					text: "Zatwierdź"	// do tłumaczenia

					Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

					onClicked: {
						if (acceptAction)
							acceptAction()

						messageDialog.accepted()

						if (autoCloseMode)
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
