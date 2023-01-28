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
	Q_PROPERTY(User* currentUser READ currentUser NOTIFY currentUserChanged)
	Q_PROPERTY(QVariantMap trainersList READ trainersList NOTIFY trainersListChanged)

public:
	explicit MainController(QObject *parent = nullptr);
	~MainController();

	static MainController* instance();

	DatabaseHandler* database() const;

	User* currentUser() const;
	QVariantMap trainersList() const;

	//TODO: metody z useren do poprawienia
	Q_INVOKABLE void createUser();
	Q_INVOKABLE User* getCurrentUser();
	Q_INVOKABLE QString getCurrentUserName();

	Q_INVOKABLE TrainingPlan* newTrainingPlan();
	Q_INVOKABLE Training* newTraining(QString ownerName, QString planId);
	Q_INVOKABLE Exercise* newExercise(QString planId, QString trainingId);

	Q_INVOKABLE TrainingPlan* getTrainingPlanById(QString id);
	Q_INVOKABLE QList<TrainingPlan*> getUserTrainingPlans();
	Q_INVOKABLE bool addTraningPlan(TrainingPlan* trainingPlan);

	Q_INVOKABLE Training* getTrainingById(QString planId, QString trainingId);

	Q_INVOKABLE Exercise* getExercisegById(QString planId, QString trainingId, QString exerciseId);

	Q_INVOKABLE Measurement* getCurrentUserLastMeasurement();

	//DATABASE INTERFACE
	Q_INVOKABLE void getDatabaseUserByLogIn(QString email, QString password);
	Q_INVOKABLE void getDatabaseTrainers();
	Q_INVOKABLE void getDatabaseUserTrainingPlans();
	Q_INVOKABLE void getDatabaseTrainingsByPlanId(QString planId);
	Q_INVOKABLE void getDatabaseExercisesByTrainingId(QString planId, QString trainingId);
	Q_INVOKABLE void getDatabaseMeasurementsByUserId(QString userId);

	Q_INVOKABLE void addDatabaseTrainingPlan(QString ownerName, QString name, QString description, bool isDefault);
	Q_INVOKABLE void addDatabaseTraining(QString ownerName, QString name, QString planId);
	Q_INVOKABLE void addDatabaseExercise(QString planId, QString trainingId, QString name, int breakTime, QList<QString> sets);
	Q_INVOKABLE void addDatabaseMeasurement(double weight, double chest, double shoulders, double arm, double forearm,
											double waist, double hips, double peace, double calf);

	Q_INVOKABLE void editDatabaseTrainingPlan(QString planId, QString ownerName, QString name, QString description, bool isDefault);
	Q_INVOKABLE void editDatabaseTraining(QString trainingId, QString ownerName, QString name, QString planId);
	Q_INVOKABLE void editDatabaseExercise(QString planId, QString exerciseId, QString trainingId, QString name, int breakTime, QList<QString> sets);

	Q_INVOKABLE void deleteDatabaseTrainingPlan(QString planId);
	Q_INVOKABLE void deleteDatabaseTraining(QString planId, QString trainingId);
	Q_INVOKABLE void deleteDatabaseExercise(QString planId, QString trainingId, QString exerciseId);

	Q_INVOKABLE void addRequestForTrainer(QString trainerId);
	Q_INVOKABLE void deleteTrainerFromUser(QString trainerId);

	Q_INVOKABLE void getDatabaseUserTrainerId(QString userId);
	Q_INVOKABLE void getDatabaseTrainerPupilsIds(QString trainerId);
	Q_INVOKABLE void getDatabasePupilById(QString trainerId, QString pupilId);

signals:
	void currentUserChanged();
	void trainersListChanged();

	void currentUserReady();
	void trainersListReady();
	void pupilsListReady();
	void pupilReady(QString pupilUsername, bool isConfirmed);
	void userTrainerReady();
	void currentUserPlansReady();
	void trainingsReady();
	void exercisesReady();
	void measurementsReady();

private:
	DatabaseHandler* m_database;

	User* m_currentUser;
	QVariantMap m_trainersList;

};

#endif // MAINCONTROLLER_H
