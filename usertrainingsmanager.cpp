#include "usertrainingsmanager.h"

#include <QDebug>

UserTrainingsManager::UserTrainingsManager(QObject *parent)
	: QObject{parent}
{

}

UserTrainingsManager::~UserTrainingsManager()
{

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
	auto trainingPlanToRemove = getTrainingPlanById(id);

	m_trainingPlans.removeOne(trainingPlanToRemove);

	trainingPlanToRemove->deleteLater();
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

void
UserTrainingsManager::removeTrainingById(QString planId, QString trainingId)
{
	getTrainingPlanById(planId)->removeTrainingById(trainingId);
}

Exercise*
UserTrainingsManager::getExerciseById(QString planId, QString trainingId, QString exerciseId)
{
	auto training = getTrainingById(planId, trainingId);

	for (Exercise* exercise : training->getAllExercises()) {
		if (exercise->id() == exerciseId)
			return exercise;
	}

	return nullptr;
}

void
UserTrainingsManager::removeExerciseById(QString planId, QString trainingId, QString exerciseId)
{
	getTrainingById(planId, trainingId)->removeExerciseById(exerciseId);
}
