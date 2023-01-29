import QtQuick

ListModel {
	id: model

	signal modelReady

	required property var fillModel

	property bool shouldFillOnCompleted: true

	Component.onCompleted: {
		if (shouldFillOnCompleted)
			fillModel()

		modelReady()
	}
}
