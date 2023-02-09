import QtQuick

import Components

PListModel {
	id: exerciseCategoriesModel

	fillModel: function() {
		clear()

		var categories = ["Klatka piersiowa",
						  "Plecy",
						  "Barki",
						  "Biceps",
						  "Triceps",
						  "Mobilizacje",
						  "Nogi",
						  "Brzuch"]

		var categoryCodes = ["chest",
							 "back",
							 "shoulders",
							 "biceps",
							 "triceps",
							 "mobilisation",
							 "legs",
							 "core"]

		for (var i = 0; i < categories.length; i++) {
			append({"name": categories[i],
					   "category": categoryCodes[i]})
		}
	}
}
