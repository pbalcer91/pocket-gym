import QtQuick

import Components

import pl.com.thesis

PListModel {
	id: pupilsModel

	property User currentUser: MainController.currentUser

	property int pupilsToFill

	onPupilsToFillChanged: {
		if (pupilsToFill > 0)
			return

		sortModelByIsConfirmed()
	}

	function sortModelByIsConfirmed() {
		var nextIndexToReplace = 0
		var shouldReplaceNext = false

		for (var i = 0; i < pupilsModel.count; i++) {

			if (!pupilsModel.get(i).isConfirmed
					&& !shouldReplaceNext) {
				nextIndexToReplace++
				continue
			}

			if (!pupilsModel.get(i).isConfirmed
					&& shouldReplaceNext) {
				pupilsModel.move(i, nextIndexToReplace, 1)
				nextIndexToReplace++
				continue
			}

			shouldReplaceNext = true
		}
	}

	function appendPupil(id, pupilUsername, isConfirmed) {
		append({"id": id,
				   "username": pupilUsername,
				   "isConfirmed": isConfirmed})
	}

	fillModel: function() {
		clear()

		var pupils = currentUser.pupilsIds
		pupilsToFill = pupils.length

		for (var i = 0; i < pupils.length; i++) {
			MainController.getDatabasePupilById(currentUser.id, pupils[i])
		}
	}
}
