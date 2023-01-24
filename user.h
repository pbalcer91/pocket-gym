#ifndef USER_H
#define USER_H

#include <QObject>

#include "usertrainingsmanager.h"

class User : public QObject
{
	Q_OBJECT

	Q_PROPERTY(QString name READ name WRITE setName NOTIFY userDataChanged)
	Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY userDataChanged)
	Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY userDataChanged)

public:
	explicit User(QObject *parent = nullptr);
	~User();

	QString name() const;
	QString email() const;
	QString password() const;

	void setName(QString name);
	void setEmail(QString email);
	void setPassword(QString password);

	TrainingPlan* createTrainingPlan();
	Training* createTraining(QString ownerName, QString planId);
	Exercise* createExercise(QString planId, QString trainingId);

	TrainingPlan* getTrainingPlanById(QString id);
	QList<TrainingPlan*> getUserTrainingPlans();
	bool addTraningPlan(TrainingPlan* trainingPlan);
	void editTrainingPlanById(QString planId, QString name, QString description, bool isDefault);
	void removeTrainingPlanById(QString planId);

	Training* getTrainingById(QString planId, QString trainingId);
	void editTrainingById(QString trainingId, QString ownerName, QString name, QString planId);
	void removeTrainingById(QString planId, QString trainingId);

	Exercise* getExercisegById(QString planId, QString trainingId, QString exerciseId);
	void editExerciseById(QString planId, QString exerciseId, QString name, int breakTime, QString trainingId, QList<QString> setList);
	void removeExerciseById(QString planId, QString trainingId, QString exerciseId);

signals:
	void userDataChanged();
	void userTrainingPlansChanged();

public:
	UserTrainingsManager* m_trainingsManager;

	QString m_name;
	QString m_email;
	QString m_password;
};

#endif // USER_H
