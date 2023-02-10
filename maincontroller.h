#ifndef MAINCONTROLLER_H
#define MAINCONTROLLER_H

#include <QObject>
#include <QSettings>

#include "user.h"
#include "databasehandler.h"

#define EMAIL							QStringLiteral("main/email")
#define PASSWORD						QStringLiteral("main/password")

#define TRAINER_SECTION_VISIBLE			QStringLiteral("main/trainerSectionVisible")

class MainController : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(MainController)

	Q_PROPERTY(DatabaseHandler* database READ database CONSTANT)
	Q_PROPERTY(User* currentUser READ currentUser NOTIFY currentUserChanged)
	Q_PROPERTY(QVariantMap trainersList READ trainersList NOTIFY trainersListChanged)
	Q_PROPERTY(bool trainerSectionVisible READ trainerSectionVisible WRITE setTrainerSectionVisible NOTIFY settingsChanged)

public:
	explicit MainController(QObject *parent = nullptr);
	~MainController();

	enum SU_ERROR {
		SU_UNKNOWN_ERROR					= 0,
		SU_EMAIL_EXISTS						= 1,
		SU_TOO_MANY_ATTEMPTS_TRY_LATER		= 2
	};
	Q_ENUM(SU_ERROR)

	enum SI_ERROR {
		SI_UNKNOWN_ERROR					= 0,
		SI_EMAIL_NOT_FOUND					= 1,
		SI_INVALID_PASSWORD					= 2,
		SI_USER_DISABLED					= 3
	};
	Q_ENUM(SI_ERROR)

	enum EMAIL_ERROR {
		EMAIL_UNKNOWN_ERROR					= 0,
		EMAIL_EXISTS						= 1,
		EMAIL_INVALID_ID_TOKEN				= 2
	};
	Q_ENUM(EMAIL_ERROR)

	enum PASSWORD_ERROR {
		PASSWORD_UNKNOWN_ERROR					= 0,
		PASSWORD_WEAK_PASSWORD					= 1,
		PASSWORD_INVALID_ID_TOKEN				= 2
	};
	Q_ENUM(PASSWORD_ERROR)

	static MainController* instance();

	DatabaseHandler* database() const;

	User* currentUser() const;
	QVariantMap trainersList() const;
	bool trainerSectionVisible() const;

	void setTrainerSectionVisible(bool visible);

	Q_INVOKABLE User* getCurrentUser();

	Q_INVOKABLE void autoLogIn();

	Q_INVOKABLE void logOut();

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
	Q_INVOKABLE void signUpUser(QString email, QString password);
	Q_INVOKABLE void signInUser(QString email, QString password);

	Q_INVOKABLE void getDatabaseUserByEmail(QString email);
	Q_INVOKABLE void addDatabaseUser( QString email, bool isTrainer);
	Q_INVOKABLE void checkIsUsernameAvailable(QString username);
	Q_INVOKABLE void changeDatabaseUser(QString userId, QString email, QString username, bool isTrainer);
	Q_INVOKABLE void changeDatabaseUserEmail(QString newEmail);
	Q_INVOKABLE void changeDatabaseUserPassword(QString newPasword);

	Q_INVOKABLE void getDatabaseCatalogByCategory(QString category);

	Q_INVOKABLE void getDatabaseTrainers();
	Q_INVOKABLE void getDatabaseUserTrainingPlans(User* user);
	Q_INVOKABLE void getDatabaseTrainingsByPlanId(User* user, QString planId);
	Q_INVOKABLE void getDatabaseExercisesByTrainingId(User* user, QString planId, QString trainingId);
	Q_INVOKABLE void getDatabaseMeasurementsByUser(User* user);
	Q_INVOKABLE void getDatabaseEvents(User* user, int day, int month, int year);
	Q_INVOKABLE void getDatabaseEventById(QString id);

	Q_INVOKABLE void addDatabaseTrainingPlan(User* user, QString name, QString description, bool isDefault);
	Q_INVOKABLE void addDatabaseTraining(User* user, QString name, QString planId);
	Q_INVOKABLE void addDatabaseExercise(User* user, QString planId, QString trainingId, QString name, int breakTime, QList<QString> sets);
	Q_INVOKABLE void addDatabaseMeasurement(User* user, double weight, double chest, double shoulders, double arm, double forearm,
											double waist, double hips, double peace, double calf);
	Q_INVOKABLE void addDatabaseEvent(User* user, QString name, int day, int month, int year, int hour, int minute);

	Q_INVOKABLE void getDabaseCompletedTrainings(User* user);
	Q_INVOKABLE void getDabaseCompletedExercises(QString traininId);
	Q_INVOKABLE void addDatabaseCompletedTraining(User* user, QString trainingName);
	Q_INVOKABLE void deleteDatabaseCompletedTraining(User* user);
	Q_INVOKABLE void addDatabaseCompletedExercise(QString trainingId, QString name, QList<QString> sets);
	Q_INVOKABLE void completeTraining(QString trainingId);

	Q_INVOKABLE void editDatabaseTrainingPlan(QString planId, User* user, QString name, QString description, bool isDefault);
	Q_INVOKABLE void editDatabaseTraining(QString trainingId, User* user, QString name, QString planId);
	Q_INVOKABLE void editDatabaseExercise(User* user, QString planId, QString exerciseId, QString trainingId, QString name, int breakTime, QList<QString> sets);
	Q_INVOKABLE void editDatabaseEvent(User *user, QString eventId, QString name, int day, int month, int year, int hour, int minute);

	Q_INVOKABLE void deleteDatabaseTrainingPlan(User* user, QString planId);
	Q_INVOKABLE void deleteDatabaseTraining(User* user, QString planId, QString trainingId);
	Q_INVOKABLE void deleteDatabaseExercise(User* user, QString planId, QString trainingId, QString exerciseId);
	Q_INVOKABLE void deleteEvent(QString id);

	Q_INVOKABLE void addRequestForTrainer(QString trainerId);
	Q_INVOKABLE void deleteTrainerFromUser(QString trainerId);
	Q_INVOKABLE void deletePupilFromTrainer(User* trainer, QString pupilId);

	Q_INVOKABLE void acceptPupil(QString pupilId);

	Q_INVOKABLE void getDatabaseUserTrainerId(QString userId);
	Q_INVOKABLE void getDatabaseTrainerPupilsIds(QString trainerId);
	Q_INVOKABLE void getDatabasePupilById(QString trainerId, QString pupilId);

	Q_INVOKABLE User* createPupilInstance(QObject* parent, QString pupilId, QString pupilUsername);

signals:
	void settingsChanged();
	void signUpFailed(MainController::SU_ERROR errorCode);
	void signUpSucceed();

	void signInFailed(MainController::SI_ERROR errorCode);
	void signInSucceed(QString email);

	void userLoggedOut();

	void catalogReady(QVariantMap list);

	void eventAdded();
	void eventsReady(QList<QString> eventsIdList);
	void eventReady(QString id, QString name, QDateTime dateTime);
	void eventRemoved();
	void eventChanged();

	void userChanged();
	void userEmailChanged(QString email);
	void userEmailChangeFailed(MainController::EMAIL_ERROR);
	void userPasswordChanged();
	void userPasswordChangeFailed(MainController::PASSWORD_ERROR);

	void userAdded(QString email);
	void usernameVerificationReceived(bool isAvailable);

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
	bool m_trainerSectionVisible;

	QSettings* m_settings;
};

#endif // MAINCONTROLLER_H
