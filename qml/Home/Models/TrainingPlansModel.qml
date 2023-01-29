import QtQuick

import Components

import pl.com.thesis

PListModel {
	id: trainingPlansModel

	property User user

	fillModel: function() {
		clear()

		var trainingPlans = MainController.getUserTrainingPlans(user)

		for(var i = 0; i < trainingPlans.length; i++) {
			append({"id": trainingPlans[i].id,
					   "name": trainingPlans[i].name,
					   "isDefault": trainingPlans[i].isDefault})
		}
	}
}
