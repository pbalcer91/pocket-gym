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
						  "Przedramię",
						  "Nogi",
						  "Brzuch"]

		for (var i = 0; i < categories.length; i++) {
			append({"name": categories[i]})
		}
	}
}
