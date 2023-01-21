#include "usertrainingsmanager.h"

#include <QDebug>

UserTrainingsManager::UserTrainingsManager(QObject *parent)
	: QObject{parent}
{

}

UserTrainingsManager::~UserTrainingsManager()
{

}

Exercise*
UserTrainingsManager::createExercise()
{
	return new Exercise();
}

Training*
UserTrainingsManager::createTraining()
{
	return new Training();
}

TrainingPlan*
UserTrainingsManager::createTrainingPlan(QString ownerName)
{
	return new TrainingPlan(this, ownerName);
}

TrainingPlan*
UserTrainingsManager::getTrainingPlanById(QString id)
{
	for(int i = 0; i < m_trainingPlans.count(); i++) {
		if (m_trainingPlans[i]->id() == id)
			return m_trainingPlans[i];
	}

	return nullptr;
}

QList<TrainingPlan*>
UserTrainingsManager::getTrainingPlans()
{
	return m_trainingPlans;
}

bool
UserTrainingsManager::addTraningPlan(TrainingPlan* trainingPlan)
{
	m_trainingPlans.push_back(trainingPlan);

	return true;
}

void
UserTrainingsManager::removeTrainingPlanById(QString id)
{
	auto trainingToRemove = getTrainingPlanById(id);

	m_trainingPlans.removeOne(trainingToRemove);

	trainingToRemove->deleteLater();
}

Training*
UserTrainingsManager::getTrainingById(QString planId, QString trainingId)
{
	auto plan = getTrainingPlanById(planId);

	for (Training* training : plan->getTrainings()) {
		if (training->id() == trainingId)
			return training;
	}

	return nullptr;
}

Exercise*
UserTrainingsManager::getExercisegById(QString planId, QString trainingId, QString exerciseId)
{
	auto training = getTrainingById(planId, trainingId);

	for (Exercise* exercise : training->getAllExercises()) {
		if (exercise->id() == exerciseId)
			return exercise;
	}

	return nullptr;
}
