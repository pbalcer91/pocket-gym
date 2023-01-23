import QtQuick

import Components

import pl.com.thesis

PListModel {
	id: trainingsModel

	required property TrainingPlan trainingPlan

	fillModel: function() {
		clear()

		var trainings = trainingPlan.getTrainings()

		for(var i = 0; i < trainings.length; i++) {
			append({"id": trainings[i].id,
					   "name": trainings[i].name})
		}
	}
}
