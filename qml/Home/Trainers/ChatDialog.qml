import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Components
import Properties

import pl.com.thesis


PDialog {
	id: dialog

	required property string username
	required property string userId

	title: username

	Component.onCompleted: {
		MainController.getMessages(dialog, userId)
	}

	Connections {
		target: MainController

		function onMessagesReceived(messages) {

			for (var i = 0; i < messages.length; i++) {
				messagesModel.append({"sender": messages[i].sender,
										 "message": messages[i].message})
			}
		}
	}

	ColumnLayout {
		id: mainColumn

		anchors.fill: parent

		spacing: 16

		Column {
			id: messagesColumn

			Layout.fillHeight: true
			Layout.fillWidth: true

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

						visible: (!listView.atYBeginning)
					}

					Rectangle {
						width: parent.width
						height: 1
						color: Colors.black

						anchors.bottom: parent.bottom
						anchors.horizontalCenter: parent.horizontalCenter

						visible: (!listView.atYEnd)
					}
				}

				Layout.fillWidth: true
				Layout.fillHeight: true

				topPadding: 2
				bottomPadding: 2

				contentHeight: messagesColumn.height - Properties.smallMargin
				contentWidth: messagesColumn.width

				clip: true

				ScrollBar.vertical.policy: ScrollBar.AlwaysOff
				ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

				PListView {
					id: listView

					spacing: Properties.spacing

					boundsBehavior: Flickable.StopAtBounds

					emptyInfo: "Brak wiadomości"

					model: PListModel {
						id: messagesModel

						fillModel: function() {

						}
					}

					delegate: MessageItem {
						message: model.message

						username: dialog.username

						isReceived: (model.sender === userId)

						authorVisible: (index === 0
										|| listView.itemAtIndex(index - 1).isReceived !== isReceived)
					}
				}
			}
		}
	}

	footer: RowLayout {
		id: messageRow

		PTextField {
			id: messageField

			Layout.fillWidth: true

			Layout.bottomMargin: Properties.smallMargin
			Layout.leftMargin: Properties.smallMargin

			placeholderText: "Wiadomość"
		}

		PButton {
			id: sendButton

			icon.source: "qrc:/icons/ic_chevronRight.svg"

			Layout.bottomMargin: Properties.smallMargin
			Layout.rightMargin: Properties.smallMargin

			onClicked: {
				if (messageField.text == "")
					return

				MainController.sendMessage(dialog.userId, messageField.text)


				messagesModel.append({"sender": MainController.currentUser.id,
										 "message": messageField.text})

				messageField.clear()
			}
		}
	}
}
