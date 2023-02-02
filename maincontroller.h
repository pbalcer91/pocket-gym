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
	Q_INVOKABLE User* getCurrentUser();

	Q_INVOKABLE TrainingPlan* newTrainingPlan(QString ownerId);
	Q_INVOKABLE Training* newTraining(QString ownerId, QString planId);
	Q_INVOKABLE Exercise* newExercise(QString trainingId);
	Q_INVOKABLE Training* newCompletedTraining();

	Q_INVOKABLE Training* newTrainingForSave(QObject* parent, QString ownerId, QString name);
	Q_INVOKABLE Exercise* newExerciseForSave(QObject* parent);

	Q_INVOKABLE TrainingPlan* getTrainingPlanById(User* user, QString id);
	Q_INVOKABLE QList<TrainingPlan*> getUserTrainingPlans(User* user);

	Q_INVOKABLE Training* getTrainingById(User* user, QString planId, QString trainingId);
	Q_INVOKABLE Exercise* getExerciseById(User* user, QString planId, QString trainingId, QString exerciseId);

	Q_INVOKABLE Measurement* getCurrentUserLastMeasurement();

	//DATABASE INTERFACE
	Q_INVOKABLE void getDatabaseUserByLogIn(QString email, QString password);
	Q_INVOKABLE void getDatabaseTrainers();
	Q_INVOKABLE void getDatabaseUserTrainingPlans(User* user);
	Q_INVOKABLE void getDatabaseTrainingsByPlanId(User* user, QString planId);
	Q_INVOKABLE void getDatabaseExercisesByTrainingId(User* user, QString planId, QString trainingId);
	Q_INVOKABLE void getDatabaseMeasurementsByUserId(QString userId);

	Q_INVOKABLE void addDatabaseTrainingPlan(User* user, QString name, QString description, bool isDefault);
	Q_INVOKABLE void addDatabaseTraining(User* user, QString name, QString planId);
	Q_INVOKABLE void addDatabaseExercise(User* user, QString planId, QString trainingId, QString name, int breakTime, QList<QString> sets);
	Q_INVOKABLE void addDatabaseMeasurement(double weight, double chest, double shoulders, double arm, double forearm,
											double waist, double hips, double peace, double calf);

	Q_INVOKABLE void getDabaseCompletedTrainings(User* user);
	Q_INVOKABLE void getDabaseCompletedExercises(User* user, QString traininId);
	Q_INVOKABLE void addDatabaseCompletedTraining(User* user, QString trainingName);
	Q_INVOKABLE void deleteDatabaseCompletedTraining(User* user);
	Q_INVOKABLE void addDatabaseCompletedExercise(QString trainingId, QString name, QList<QString> sets);
	Q_INVOKABLE void completeTraining(QString trainingId);

	Q_INVOKABLE void editDatabaseTrainingPlan(QString planId, User* user, QString name, QString description, bool isDefault);
	Q_INVOKABLE void editDatabaseTraining(QString trainingId, User* user, QString name, QString planId);
	Q_INVOKABLE void editDatabaseExercise(User* user, QString planId, QString exerciseId, QString trainingId, QString name, int breakTime, QList<QString> sets);

	Q_INVOKABLE void deleteDatabaseTrainingPlan(User* user, QString planId);
	Q_INVOKABLE void deleteDatabaseTraining(User* user, QString planId, QString trainingId);
	Q_INVOKABLE void deleteDatabaseExercise(User* user, QString planId, QString trainingId, QString exerciseId);

	Q_INVOKABLE void addRequestForTrainer(QString trainerId);
	Q_INVOKABLE void deleteTrainerFromUser(QString trainerId);
	Q_INVOKABLE void deletePupilFromTrainer(User* trainer, QString pupilId);

	Q_INVOKABLE void acceptPupil(QString pupilId);

	Q_INVOKABLE void getDatabaseUserTrainerId(QString userId);
	Q_INVOKABLE void getDatabaseTrainerPupilsIds(QString trainerId);
	Q_INVOKABLE void getDatabasePupilById(QString trainerId, QString pupilId);

	Q_INVOKABLE User* createPupilInstance(QObject* parent, QString pupilId, QString pupilUsername);

signals:
	void currentUserChanged();
	void trainersListChanged();

	void uncompletedTrainingIdReady(QString id);
	void trainingCompleted();
	void completedTrainingsReady(QList<Training*> trainingsList);
	void completedExercisesReady(QList<Exercise*> exercisesList);

	void currentUserReady();
	void trainersListReady();
	void pupilsListReady();
	void pupilReady(QString pupilUsername, bool isConfirmed);
	void userTrainerReady();
	void userPlansReady();
	void trainingsReady();
	void exercisesReady();
	void measurementsReady();

private:
	DatabaseHandler* m_database;

	User* m_currentUser;
	QVariantMap m_trainersList;

};

#endif // MAINCONTROLLER_H
