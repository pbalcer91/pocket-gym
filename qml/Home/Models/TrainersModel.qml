import QtQuick

import Components

import pl.com.thesis

PListModel {
	id: trainersModel

	fillModel: function() {
		clear()
		var trainers = MainController.trainersList

		for (var trainer in trainers) {
			append({"id": trainer,
					   "username": trainers[trainer]})
		}
	}
}
