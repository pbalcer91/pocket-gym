import QtQuick

ListModel {
	id: model

	signal modelReady

	required property var fillModel

	Component.onCompleted: {
		fillModel()
		modelReady()
	}
}
