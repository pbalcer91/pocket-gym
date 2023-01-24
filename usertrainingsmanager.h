#ifndef USERTRAININGSMANAGER_H
#define USERTRAININGSMANAGER_H

#include <QObject>

#include "trainingplan.h"
#include "training.h"
#include "exercise.h"

class UserTrainingsManager : public QObject
{
	Q_OBJECT

public:
	explicit UserTrainingsManager(QObject *parent = nullptr);
	~UserTrainingsManager();

	TrainingPlan* createTrainingPlan(QString ownerName);
	Training* createTraining(QString ownerName, QString planId);
	Exercise* createExercise(QString planId, QString trainingId);

	TrainingPlan* getTrainingPlanById(QString id);
	QList<TrainingPlan*> getTrainingPlans();
	bool addTraningPlan(TrainingPlan* trainingPlan);
	void removeTrainingPlanById(QString id);

	Training* getTrainingById(QString planId, QString trainingId);
	void removeTrainingById(QString planId, QString trainingId);

	Exercise* getExercisegById(QString planId, QString trainingId, QString exerciseId);
	void removeExerciseById(QString planId, QString trainingId, QString exerciseId);

signals:

private:
	QList<TrainingPlan*> m_trainingPlans;
};

#endif // USERTRAININGSMANAGER_H
