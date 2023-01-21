import QtQuick

import Components

import pl.com.thesis

PListModel {
	id: trainingsModel

	required property TrainingPlan trainingPlan

	//TODO usunac to ?
	property bool isInTrainingPlan: true

	fillModel: function() {
		clear()

//		if (!trainingsModel.isInTrainingPlan) {
//			return
//		}

		var trainings = trainingPlan.getTrainings()

		for(var i = 0; i < trainings.length; i++) {
			append({"id": trainings[i].id,
					   "name": trainings[i].name})
		}

//		var trainingsToAdd = trainingPlan.getTrainingsToAdd()

//		for(var j = 0; j < trainingsToAdd.length; j++) {
//			append({"name": trainingsToAdd[j].name})
//		}
	}
}
