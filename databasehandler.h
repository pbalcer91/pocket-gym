#ifndef DATABASEHANDLER_H
#define DATABASEHANDLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

#include <QBitArray>

#include "exercise.h"
#include "measurement.h"
#include "training.h"
#include "trainingplan.h"

class DatabaseHandler : public QObject
{
	Q_OBJECT

public:
	explicit DatabaseHandler(QObject *parent = nullptr);
	~DatabaseHandler();

	//get methods
	void getUserByLogIn(QString email, QString password);
	void getTrainerById(QString trainerId);
	void getTrainers();
	void getUserTrainerId(QString userId);
	void getTrainerPupilsIds(QString trainerId);
	void getPupilById(QString trainerId, QString pupilId);
	void getUserTrainingPlans(QString username);
	void getTrainingPlanById(QString id);
	void getTrainingsByPlanId(QString planId);
	void getTrainingById(QString trainingId);
	void getExercisesByTrainingId(QString planId, QString trainingId);
	void getExerciseById(QString planId, QString exerciseId);
	void getMeasurementsByUserId(QString userId);

	//add methods
	void addUser(QString username, QString email, QString password, bool isTrainer);
	void addTrainingPlan(QString ownerName, QString name, QString description, bool isDefault);
	void addTraining(QString ownerName, QString name, QString planId);
	void addExercise(QString planId, QString trainingId, QString name, int breakTime, QList<QString> sets);
	void addMeasurement(QString userId, double weight, double chest, double shoulders, double arm,
						double forearm, double waist, double hips, double peace, double calf);

	//edit methods
	void editTrainingPlan(QString planId, QString ownerName, QString name, QString description, bool isDefault);
	void editTraining(QString trainingId, QString ownerName, QString name, QString planId);
	void editExercise(QString planId, QString exerciseId, QString trainingId, QString name, int breakTime, QList<QString> sets);

	//delete methods
	void deleteTrainingPlan(QString planId);
	void deleteTraining(QString planId, QString trainingId);
	void deleteExercise(QString planId, QString trainingId, QString exerciseId);

	//trainer request method
	void addRequestForTrainer(QString userId, QString trainerId);
	void deleteRequestForTrainer(QString userId, QString trainerId);

	void addTrainerToUser(QString userId, QString trainerId);
	void deleteTrainerFromUser(QString userId);

signals:
	void userLoggedIn(QString id, QString username, QString email, QString password, bool isTrainer);
	void trainersReceived(QVariantMap trainersList);
	void trainerReceived(QString id, QString username);
	void userTrainerIdReceived(QString trainerId, QString trainerUsername, bool isConfirmed);
	void trainerPupilsIdsReceived(QList<QString> pupilsIds);
	void pupilReceived(QString pupilUsername, bool isConfirmed);
	void trainingPlansReceived(QList<TrainingPlan*> plans);
	void trainingPlanReceived(QString planId, QString name, QString description, bool isDefault);
	void trainingsReceived(QString planId, QList<Training*> trainings);
	void trainingReceived(QString trainingId, QString ownerName, QString name, QString planId);
	void exercisesReceived(QString planId, QString trainingId, QList<Exercise*> exercises);
	void exerciseReceived(QString planId, QString exerciseId, QString name, int breakTime, QString trainingId, QList<QString> setList);
	void measurementsReceived(QString userId, QList<Measurement*> measurements);

	void trainingPlanAdded(QString ownerName);
	void trainingAdded(QString planId);
	void exerciseAdded(QString planId, QString trainingId);
	void measurementAdded(QString userId);
	void userAdded();

	void trainingPlanChanged(QString planId);
	void trainingChanged(QString trainingId);
	void exerciseChanged(QString planId, QString exerciseId);

	void trainingPlanRemoved(QString planId);
	void trainingRemoved(QString planId, QString trainingId);
	void exerciseRemoved(QString planId, QString trainingId, QString exerciseId);

	void trainerRequestAdded(QString trainerId);
	void trainerRequestRemoved();

private:
	QNetworkAccessManager* m_networkManager;
	std::shared_ptr<QMetaObject::Connection> m_connection;
	QString m_url;
};

#endif // DATABASEHANDLER_H
