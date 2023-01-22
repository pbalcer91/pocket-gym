#ifndef MAINCONTROLLER_H
#define MAINCONTROLLER_H

#include <QObject>

#include "user.h"
#include "databasehandler.h"

class MainController : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(MainController)

	Q_PROPERTY(DatabaseHandler* database READ database CONSTANT)

public:
	explicit MainController(QObject *parent = nullptr);
	~MainController();

	static MainController* instance();

	DatabaseHandler* database() const;

	Q_INVOKABLE void createUser();
	Q_INVOKABLE User* getUser();

	Q_INVOKABLE Exercise* createExercise();
	Q_INVOKABLE Training* createTraining();
	Q_INVOKABLE TrainingPlan* newTrainingPlan();

	Q_INVOKABLE TrainingPlan* getTrainingPlanById(QString id);
	Q_INVOKABLE QList<TrainingPlan*> getUserTrainingPlans();
	Q_INVOKABLE bool addTraningPlan(TrainingPlan* trainingPlan);

	Q_INVOKABLE Training* getTrainingById(QString planId, QString trainingId);

	Q_INVOKABLE Exercise* getExercisegById(QString planId, QString trainingId, QString exerciseId);


	//DATABASE INTERFACE
	Q_INVOKABLE void getDatabaseUserTrainingPlans();
	Q_INVOKABLE void getTrainigsFromDatabaseByPlanId(QString planId);
	Q_INVOKABLE void getExercisesFromDatabaseByTrainingId(QString planId, QString trainingId);
	//Q_INVOKABLE void getExercise(QString trainingId, QString exerciseId);

	Q_INVOKABLE void addDatabaseTrainingPlan(QString ownerName, QString name, QString description, bool isDefault);

	Q_INVOKABLE void editDatabaseTrainingPlan(QString planId, QString ownerName, QString name, QString description, bool isDefault);
	Q_INVOKABLE void editDatabaseExercise(QString trainingId, Exercise* exercise);

	Q_INVOKABLE void deleteDatabaseTrainingPlan(QString planId);


signals:
	void currentUserPlansReady();
	void trainingsReady();
	void exercisesReady();

	void trainingPlanReady(QString planId);
	void exerciseReady();

private:
	User* m_currentUser;

	DatabaseHandler* m_database;
};

#endif // MAINCONTROLLER_H