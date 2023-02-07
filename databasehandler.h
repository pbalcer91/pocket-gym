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
#include "user.h"

class DatabaseHandler : public QObject
{
	Q_OBJECT

public:
	explicit DatabaseHandler(QObject *parent = nullptr);
	~DatabaseHandler();

	enum SING_UP_ERROR {
		SU_UNKNOWN_ERROR					= 0,
		SU_EMAIL_EXISTS						= 1,
		SU_TOO_MANY_ATTEMPTS_TRY_LATER		= 2
	};

	enum SING_IN_ERROR {
		SI_UNKNOWN_ERROR					= 0,
		SI_EMAIL_NOT_FOUND					= 1,
		SI_INVALID_PASSWORD					= 2,
		SI_USER_DISABLED					= 3
	};

	enum EMAIL_ERROR {
		EMAIL_UNKNOWN_ERROR					= 0,
		EMAIL_EXISTS						= 1,
		EMAIL_INVALID_ID_TOKEN				= 2
	};

	void clearIdToken();

	void signUserUp(const QString &email, const QString &password);
	void signUserIn(const QString &email, const QString &password);

	void checkIsUsernameAvailable(QString username);
	void changeUsername(QString userId, QString email, QString username, bool isTrainer);
	void changeUserEmail(QString email);

	//get methods
	void getUserByEmail(QString email);
	void getTrainerById(QString trainerId);
	void getTrainers();
	void getUserTrainerId(QString userId);
	void getTrainerPupilsIds(QString trainerId);
	void getPupilById(QString trainerId, QString pupilId);
	void getUserTrainingPlans(User* user);
	void getTrainingPlanById(User* user, QString id);
	void getTrainingsByPlanId(User* user, QString planId);
	void getTrainingById(User* user, QString trainingId);
	void getExercisesByTrainingId(User* user, QString planId, QString trainingId);
	void getExerciseById(User* user, QString planId, QString exerciseId);
	void getMeasurementsByUser(User* user);

	//add methods
	void addUser(QString email, bool isTrainer);
	void addTrainingPlan(User* user, QString name, QString description, bool isDefault);
	void addTraining(User* user, QString name, QString planId);
	void addExercise(User* user, QString planId, QString trainingId, QString name, int breakTime, QList<QString> sets);
	void addMeasurement(User* user, double weight, double chest, double shoulders, double arm,
						double forearm, double waist, double hips, double peace, double calf);

	void addCompletedTraining(User* user, QString trainingName);
	void getUserCompletedTrainings(User* user);
	void getUserCompletedExercises(QString trainingId);
	void getUserUncompletedTrainings(User* user);
	void deleteCompletedTraining(User* user);
	void addCompletedExercise(QString trainingId, QString name, QList<QString> sets);
	void completeTraining(QString trainingId);

	//edit methods
	void editTrainingPlan(QString planId, User* user, QString name, QString description, bool isDefault);
	void editTraining(QString trainingId, User* user, QString name, QString planId);
	void editExercise(User* user, QString planId, QString exerciseId, QString trainingId, QString name, int breakTime, QList<QString> sets);

	//delete methods
	void deleteTrainingPlan(User* user, QString planId);
	void deleteTraining(User* user, QString planId, QString trainingId);
	void deleteExercise(User* user, QString planId, QString trainingId, QString exerciseId);

	//trainer request method
	void addRequestForTrainer(QString userId, QString trainerId);
	void acceptPupilRequest(QString trainerId, QString pupilId);
	void acceptTrainer(QString trainerId, QString pupilId);
	void deleteRequestForTrainer(QString userId, QString trainerId);

	void addTrainerToUser(QString userId, QString trainerId);
	void deleteTrainerFromUser(QString userId);
	void deletePupilFromUser(User *trainer, QString pupilId);
	void deleteTrainerFromPupil(QString trainerId, QString pupilId);

signals:
	void signUpFailed(DatabaseHandler::SING_UP_ERROR errorCode);
	void signUpSucceed();

	void signInFailed(DatabaseHandler::SING_IN_ERROR errorCode);
	void signInSucceed(QString email, QString password);

	void usernameVerificationReceived(bool isAvailable);
	void userChanged();

	void userEmailChanged(QString email);
	void userEmailChangedFailed(DatabaseHandler::EMAIL_ERROR);

	void userLoggedIn(QString id, QString username, QString email, bool isTrainer);
	void trainersReceived(QVariantMap trainersList);
	void trainerReceived(QString id, QString username);
	void userTrainerIdReceived(QString trainerId, QString trainerUsername, bool isConfirmed);
	void trainerPupilsIdsReceived(QList<QString> pupilsIds);
	void pupilReceived(QString pupilUsername, bool isConfirmed);
	void trainingPlansReceived(User* user, QList<TrainingPlan*> plans);
	void trainingPlanReceived(User* user, QString planId, QString name, QString description, bool isDefault);
	void trainingsReceived(User* user, QString planId, QList<Training*> trainings);
	void trainingReceived(QString trainingId, User* user, QString name, QString planId);
	void exercisesReceived(User* user, QString planId, QString trainingId, QList<Exercise*> exercises);
	void exerciseReceived(User* user, QString planId, QString exerciseId, QString name, int breakTime, QString trainingId, QList<QString> setList);
	void measurementsReceived(User*, QList<Measurement*> measurements);

	void completedTrainingAdded(User* user);
	void uncompletedTrainingIdReceived(QString id);
	void trainingCompleted();
	void completedTrainingsReceived(QList<Training*> trainingsList);
	void completedExercisesReceived(QList<Exercise*> exercisesList);

	void trainingPlanAdded(User* user);
	void trainingAdded(User* user, QString planId);
	void exerciseAdded(User* user, QString planId, QString trainingId);
	void measurementAdded(User* user);
	void userAdded(QString email);

	void trainingPlanChanged(User* user, QString planId);
	void trainingChanged(User* user, QString trainingId);
	void exerciseChanged(User* user, QString planId, QString exerciseId);

	void trainingPlanRemoved(User* user, QString planId);
	void trainingRemoved(User* user, QString planId, QString trainingId);
	void exerciseRemoved(User* user, QString planId, QString trainingId, QString exerciseId);

	void trainerRequestAdded(QString trainerId);
	void pupilRequestAccepted(QString trainerId);
	void trainerRequestRemoved();
	void pupilRemoved(QString trainerId);

private:
	QNetworkAccessManager* m_networkManager;
	QString m_url;
	QString m_apiKey;
	QString m_idToken;
};

#endif // DATABASEHANDLER_H
