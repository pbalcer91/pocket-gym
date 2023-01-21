import QtQuick

import Components

import pl.com.thesis

PListModel {
	id: trainingPlansModel

	fillModel: function() {
		clear()

		var trainingPlans = MainController.getUserTrainingPlans()

		for(var i = 0; i < trainingPlans.length; i++) {
			append({"id": trainingPlans[i].id,
					   "name": trainingPlans[i].name,
					   "isDefault": trainingPlans[i].isDefault})
		}
	}
}
