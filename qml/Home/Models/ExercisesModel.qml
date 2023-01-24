import QtQuick

import Components

import pl.com.thesis

PListModel {
	id: exercisesModel

	required property Training training

	fillModel: function() {
		clear()

		var exercises = training.getAllExercises()

		for (var i = 0; i < exercises.length; i++) {
			append({"id": exercises[i].id,
					   "name": exercises[i].name,
					   "breakTime": exercises[i].breakTime})
		}
	}
}
