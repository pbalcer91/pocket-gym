#include "maincontroller.h"
#include <QDebug>

MainController::MainController(QObject *parent)
	: QObject{parent},
	  m_database(new DatabaseHandler(this)),
	  m_settings(new QSettings(this))
{
	setTrainerSectionVisible(m_settings->value(TRAINER_SECTION_VISIBLE, true).toBool());

	QObject::connect(m_database, &DatabaseHandler::signUpFailed,
					 this, [this](DatabaseHandler::SING_UP_ERROR errorMessage) {
		switch (errorMessage) {
			case DatabaseHandler::SU_EMAIL_EXISTS:
				emit signUpFailed(MainController::SU_EMAIL_EXISTS);
				return;
			case DatabaseHandler::SU_TOO_MANY_ATTEMPTS_TRY_LATER:
				emit signUpFailed(MainController::SU_TOO_MANY_ATTEMPTS_TRY_LATER);
				break;
			case DatabaseHandler::SU_UNKNOWN_ERROR:
				emit signUpFailed(MainController::SU_UNKNOWN_ERROR);
				break;
		}
	});

	QObject::connect(m_database, &DatabaseHandler::signUpSucceed,
					 this, [this]() {
		emit signUpSucceed();
	});

	QObject::connect(m_database, &DatabaseHandler::signInFailed,
					 this, [this](DatabaseHandler::SING_IN_ERROR errorMessage) {
		switch (errorMessage) {
			case DatabaseHandler::SI_UNKNOWN_ERROR:
				emit signInFailed(MainController::SI_UNKNOWN_ERROR);
				return;
			case DatabaseHandler::SI_EMAIL_NOT_FOUND:
				emit signInFailed(MainController::SI_EMAIL_NOT_FOUND);
				break;
			case DatabaseHandler::SI_INVALID_PASSWORD:
				emit signInFailed(MainController::SI_INVALID_PASSWORD);
				break;
			case DatabaseHandler::SI_USER_DISABLED:
				emit signInFailed(MainController::SI_USER_DISABLED);
				break;
		}
	});

	QObject::connect(m_database, &DatabaseHandler::userAdded,
					 this, [this](QString email) {
		emit userAdded(email);
	});

	QObject::connect(m_database, &DatabaseHandler::usernameVerificationReceived,
					 this, [this](bool isAvailable) {
		emit usernameVerificationReceived(isAvailable);
	});

	QObject::connect(m_database, &DatabaseHandler::userChanged,
					 this, [this]() {
		emit userChanged();
	});

	QObject::connect(m_database, &DatabaseHandler::userEmailChanged,
					 this, [this](QString email) {
		m_settings->setValue(EMAIL, "");
		m_settings->setValue(PASSWORD, "");

		emit userEmailChanged(email);
	});

	QObject::connect(m_database, &DatabaseHandler::userEmailChangeFailed,
					 this, [this](DatabaseHandler::EMAIL_ERROR errorMessage) {
		switch (errorMessage) {
			case DatabaseHandler::EMAIL_UNKNOWN_ERROR:
				emit userEmailChangeFailed(MainController::EMAIL_UNKNOWN_ERROR);
				return;
			case DatabaseHandler::EMAIL_EXISTS:
				emit userEmailChangeFailed(MainController::EMAIL_EXISTS);
				break;
			case DatabaseHandler::EMAIL_INVALID_ID_TOKEN:
				emit userEmailChangeFailed(MainController::EMAIL_INVALID_ID_TOKEN);
				break;
		}
	});

	QObject::connect(m_database, &DatabaseHandler::userPasswordChanged,
					 this, [this]() {
		m_settings->setValue(EMAIL, "");
		m_settings->setValue(PASSWORD, "");

		emit userPasswordChanged();
	});

	QObject::connect(m_database, &DatabaseHandler::userPasswordChangeFailed,
					 this, [this](DatabaseHandler::PASSWORD_ERROR errorMessage) {
		switch (errorMessage) {
			case DatabaseHandler::PASSWORD_UNKNOWN_ERROR:
				emit userPasswordChangeFailed(MainController::PASSWORD_UNKNOWN_ERROR);
				return;
			case DatabaseHandler::PASSWORD_WEAK_PASSWORD:
				emit userPasswordChangeFailed(MainController::PASSWORD_WEAK_PASSWORD);
				break;
			case DatabaseHandler::PASSWORD_INVALID_ID_TOKEN:
				emit userPasswordChangeFailed(MainController::PASSWORD_INVALID_ID_TOKEN);
				break;
		}
	});

	QObject::connect(m_database, &DatabaseHandler::signInSucceed,
					 this, [this](QString email, QString password) {
		m_settings->setValue(EMAIL, email.toLower());
		m_settings->setValue(PASSWORD, password);

		emit signInSucceed(email.toLower());
	});

	QObject::connect(m_database, &DatabaseHandler::userLoggedIn,
					 this, [this](QString id, QString username, QString email, bool isTrainer) {
		m_currentUser = new User(this, id, username, email, isTrainer);

		emit currentUserReady();
	});

	QObject::connect(m_database, &DatabaseHandler::pupilRequestAccepted,
					 this, [this](QString trainerId) {
		getDatabaseTrainerPupilsIds(trainerId);
	});

	QObject::connect(m_database, &DatabaseHandler::completedTrainingAdded,
					 this, [this](User* user) {
		m_database->getUserUncompletedTrainings(user);
	});

	QObject::connect(m_database, &DatabaseHandler::uncompletedTrainingIdReceived,
					 this, [this](QString id) {
		emit uncompletedTrainingIdReady(id);
	});

	QObject::connect(m_database, &DatabaseHandler::completedTrainingsReceived,
					 this, [this](QList<Training*> trainingsList) {
		emit completedTrainingsReady(trainingsList);
	});

	QObject::connect(m_database, &DatabaseHandler::completedExercisesReceived,
					 this, [this](QList<Exercise*> exercisesList) {
		emit completedExercisesReady(exercisesList);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingCompleted,
					 this, [this]() {
		emit trainingCompleted();
	});

	QObject::connect(m_database, &DatabaseHandler::trainerPupilsIdsReceived,
					 this, [this](QList<QString> pupilsIds) {
		if (!m_currentUser->isTrainer())
			return;

		m_currentUser->clearPupilsIds();

		for(const auto &pupilId : pupilsIds) {
			m_currentUser->addPupilId(pupilId);
		}

		emit pupilsListReady();
	});

	QObject::connect(m_database, &DatabaseHandler::pupilReceived,
					 this, [this](QString pupilUsername, bool isConfirmed) {
		if (!m_currentUser->isTrainer())
			return;

		emit pupilReady(pupilUsername, isConfirmed);
	});

	QObject::connect(m_database, &DatabaseHandler::trainersReceived,
					 this, [this](QVariantMap trainersList) {
		m_trainersList.clear();

		auto trainesKeys = trainersList.keys();

		for(const auto &key : trainesKeys) {
			if (key == m_currentUser->id())
				continue;

			m_trainersList.insert(key, trainersList.value(key));
		}

		emit trainersListReady();
	});

	QObject::connect(m_database, &DatabaseHandler::trainerRequestAdded,
					 this, [this](QString trainerId) {
		m_database->getTrainerById(trainerId);
	});

	QObject::connect(m_database, &DatabaseHandler::trainerRequestRemoved,
					 this, [this]() {
		m_currentUser->setTrainerId("");
		m_currentUser->setTrainerUsername("");
		m_currentUser->setIsTrainerConfirmed(false);

		emit userTrainerReady();
	});

	QObject::connect(m_database, &DatabaseHandler::pupilRemoved,
					 this, [this](QString trainerId) {
		m_database->getTrainerPupilsIds(trainerId);
	});

	QObject::connect(m_database, &DatabaseHandler::trainerReceived,
					 this, [this](QString id, QString username) {
		m_currentUser->setTrainerId(id);
		m_currentUser->setTrainerUsername(username);

		emit userTrainerReady();
	});

	QObject::connect(m_database, &DatabaseHandler::userTrainerIdReceived,
					 this, [this](QString id, QString username, bool isConfirmed) {
		m_currentUser->setTrainerId(id);
		m_currentUser->setTrainerUsername(username);
		m_currentUser->setIsTrainerConfirmed(isConfirmed);

		emit userTrainerReady();
	});

	QObject::connect(m_database, &DatabaseHandler::trainingPlanAdded,
					 this, [this](User* user) {
		m_database->getUserTrainingPlans(user);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingPlansReceived,
					 this, [this](User* user, QList<TrainingPlan*> planList) {
		for (auto plan : planList) {
			if (user->getTrainingPlanById(plan->id()))
				continue;

			TrainingPlan* planToAdd = new TrainingPlan(user, plan->ownerId(), plan->id());

			planToAdd->setName(plan->name());
			planToAdd->setDescription(plan->description());
			planToAdd->setIsDefault(plan->isDefault());

			plan->deleteLater();

			user->addTraningPlan(planToAdd);
		}

		emit userPlansReady();
	});

	QObject::connect(m_database, &DatabaseHandler::trainingPlanChanged,
					 this, [this](User* user, QString planId) {
		m_database->getTrainingPlanById(user, planId);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingPlanReceived,
					 this, [](User* user, QString planId, QString name, QString description, bool isDefault) {
		user->editTrainingPlanById(planId, name, description, isDefault);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingPlanRemoved,
					 this, [](User* user, QString planId) {
		user->removeTrainingPlanById(planId);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingAdded,
					 this, [this](User* user, QString planId) {
		m_database->getTrainingsByPlanId(user, planId);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingsReceived,
					 this, [this](User* user, QString planId, QList<Training*> trainingList) {
		TrainingPlan* plan = user->getTrainingPlanById(planId);

		for (auto training : trainingList) {
			if (plan->getTrainingById(training->id()))
				continue;

			Training* trainingToAdd = new Training(plan,
												   training->id(),
												   training->ownerId(),
												   training->name(),
												   training->planId());

			training->deleteLater();

			plan->addTraining(trainingToAdd);
		}

		emit trainingsReady();
	});

	QObject::connect(m_database, &DatabaseHandler::trainingChanged,
					 this, [this](User* user, QString trainingId) {
		m_database->getTrainingById(user, trainingId);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingReceived,
					 this, [](QString trainingId, User* user, QString name, QString planId) {
		user->editTrainingById(trainingId, user->id(), name, planId);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingRemoved,
					 this, [](User* user, QString planId, QString trainingId) {
		user->removeTrainingById(planId, trainingId);
	});

	QObject::connect(m_database, &DatabaseHandler::exerciseAdded,
					 this, [this](User* user, QString planId, QString trainingId) {
		m_database->getExercisesByTrainingId(user, planId, trainingId);
	});

	QObject::connect(m_database, &DatabaseHandler::exercisesReceived,
					 this, [this](User* user, QString planId, QString trainingId, QList<Exercise*> exerciseList) {
		Training* training = user->getTrainingById(planId, trainingId);

		for (auto exercise : exerciseList) {
			if (training->getExerciseById(exercise->id()))
				continue;

			Exercise* exerciseToAdd = new Exercise(training,
												   exercise->id(),
												   exercise->name(),
												   exercise->breakTime(),
												   exercise->trainingId());

			exerciseToAdd->setSets(exercise->sets());

			training->addExercise(exerciseToAdd);
			exercise->deleteLater();
		}

		emit exercisesReady();
	});

	QObject::connect(m_database, &DatabaseHandler::exerciseChanged,
					 this, [this](User* user, QString planId, QString exerciseId) {
		m_database->getExerciseById(user, planId, exerciseId);
	});

	QObject::connect(m_database, &DatabaseHandler::exerciseReceived,
					 this, [](User* user, QString planId, QString exerciseId, QString name, int breakTime, QString trainingId, QList<QString> setList) {
		user->editExerciseById(planId, exerciseId, name, breakTime, trainingId, setList);
	});

	QObject::connect(m_database, &DatabaseHandler::exerciseRemoved,
					 this, [](User* user, QString planId, QString trainingId, QString exerciseId) {
		user->removeExerciseById(planId, trainingId, exerciseId);
	});

	QObject::connect(m_database, &DatabaseHandler::measurementAdded,
					 this, [this](User* user) {
		m_database->getMeasurementsByUser(user);
	});

	QObject::connect(m_database, &DatabaseHandler::measurementsReceived,
					 this, [this](User* user, QList<Measurement*> measurementList) {
		for (auto measurement : measurementList) {
			if (user->getMeasurementById(measurement->id()))
				continue;

			user->addMeasurement(user,
										  measurement->id(),
										  measurement->date(),
										  measurement->weight(),
										  measurement->chest(),
										  measurement->shoulders(),
										  measurement->arm(),
										  measurement->forearm(),
										  measurement->waist(),
										  measurement->hips(),
										  measurement->peace(),
										  measurement->calf());

			measurement->deleteLater();
		}

		emit measurementsReady();
	});
}

MainController::~MainController()
{
	delete m_currentUser;
	delete m_database;
}

MainController*
MainController::instance()
{
	static MainController* instance = new MainController();
	return (instance);
}

DatabaseHandler*
MainController::database() const
{
	if (!m_database)
		return nullptr;

	return m_database;
}

User*
MainController::currentUser() const
{
	return m_currentUser;
}

QVariantMap
MainController::trainersList() const
{
	return m_trainersList;
}

bool
MainController::trainerSectionVisible() const
{
	return m_trainerSectionVisible;
}

void
MainController::setTrainerSectionVisible(bool visible)
{
	m_trainerSectionVisible = visible;

	m_settings->setValue(TRAINER_SECTION_VISIBLE, visible);

	emit settingsChanged();
}

User*
MainController::getCurrentUser()
{
	if (!m_currentUser)
		return nullptr;

	return m_currentUser;
}

void
MainController::autoLogIn()
{
	QString email =  m_settings->value(EMAIL, "").toString().toLower();
	QString password = m_settings->value(PASSWORD, "").toString();

	if (email == "" || password == "")
		return;

	signInUser(email, password);
}

void
MainController::logOut()
{
	m_settings->setValue(EMAIL, "");
	m_settings->setValue(PASSWORD, "");
	m_settings->setValue(TRAINER_SECTION_VISIBLE, true);

	m_database->clearIdToken();

	emit userLoggedOut();
}

TrainingPlan*
MainController::newTrainingPlan(QString ownerId)
{
	return new TrainingPlan(this, ownerId);
}

Training*
MainController::newTraining(QString ownerId, QString planId)
{
	return new Training(this, ownerId, planId);
}

Exercise*
MainController::newExercise(QString trainingId)
{
	return new Exercise(this, trainingId);
}

Training*
MainController::newCompletedTraining()
{
	return new Training();
}

Training*
MainController::newTrainingForSave(QObject *parent, QString ownerId, QString name)
{
	return new Training(parent, ownerId, name);
}

Exercise*
MainController::newExerciseForSave(QObject *parent)
{
	return new Exercise(parent);
}

TrainingPlan*
MainController::getTrainingPlanById(User* user, QString id)
{
	return user->getTrainingPlanById(id);
}

QList<TrainingPlan*>
MainController::getUserTrainingPlans(User* user)
{
	return user->getUserTrainingPlans();
}

Training*
MainController::getTrainingById(User* user, QString planId, QString trainingId)
{
	return user->getTrainingById(planId, trainingId);
}

Exercise*
MainController::getExerciseById(User* user, QString planId, QString trainingId, QString exerciseId)
{
	return user->getExerciseById(planId, trainingId, exerciseId);
}

Measurement*
MainController::getCurrentUserLastMeasurement()
{
	Measurement* tempMeasurement = nullptr;

	for (auto measurement : m_currentUser->measurements()) {
		if (tempMeasurement == nullptr)
			tempMeasurement = measurement;

		if (measurement->date() > tempMeasurement->date())
			tempMeasurement = measurement;
	}

	return tempMeasurement;
}

void
MainController::signUpUser(QString email, QString password)
{
	m_database->signUserUp(email, password);
}

void
MainController::signInUser(QString email, QString password)
{
	m_database->signUserIn(email, password);
}

void
MainController::getDatabaseUserByEmail(QString email)
{
	m_database->getUserByEmail(email.toLower());
}

void
MainController::addDatabaseUser(QString email, bool isTrainer)
{
	m_database->addUser(email.toLower(), isTrainer);
}

void
MainController::checkIsUsernameAvailable(QString username)
{
	m_database->checkIsUsernameAvailable(username);
}

void
MainController::changeDatabaseUser(QString userId, QString email, QString username, bool isTrainer)
{
	m_currentUser->setEmail(email);
	m_currentUser->setName(username);
	m_currentUser->setIsTrainer(isTrainer);

	m_database->changeUsername(userId, email, username, isTrainer);
}

void
MainController::changeDatabaseUserEmail(QString newEmail)
{
	m_database->changeUserEmail(newEmail);
}

void
MainController::changeDatabaseUserPassword(QString newPasword)
{
	m_database->changeUserPassword(newPasword);
}

void
MainController::getDatabaseTrainers()
{
	m_database->getTrainers();
}

void
MainController::getDatabaseUserTrainingPlans(User* user)
{
	m_database->getUserTrainingPlans(user);
}

void
MainController::getDatabaseTrainingsByPlanId(User* user, QString planId)
{
	m_database->getTrainingsByPlanId(user, planId);
}

void
MainController::getDatabaseExercisesByTrainingId(User* user, QString planId, QString trainingId)
{
	m_database->getExercisesByTrainingId(user, planId, trainingId);
}

void
MainController::getDatabaseMeasurementsByUser(User* user)
{
	m_database->getMeasurementsByUser(user);
}

void
MainController::addDatabaseTrainingPlan(User* user, QString name, QString description, bool isDefault)
{
	if (isDefault) {
		for (auto plan : m_currentUser->getUserTrainingPlans()) {
			if (plan->isDefault()) {
				m_database->editTrainingPlan(plan->id(), user, plan->name(), plan->description(), false);
				break;
			}
		}
	}

	m_database->addTrainingPlan(user, name, description, isDefault);
}

void
MainController::addDatabaseTraining(User* user, QString name, QString planId)
{
	m_database->addTraining(user, name, planId);
}

void
MainController::addDatabaseExercise(User* user, QString planId, QString trainingId, QString name, int breakTime, QList<QString> sets)
{
	m_database->addExercise(user, planId, trainingId, name, breakTime, sets);
}

void
MainController::addDatabaseMeasurement(User* user, double weight, double chest, double shoulders, double arm, double forearm,
									   double waist, double hips, double peace, double calf)
{
	m_database->addMeasurement(user, weight, chest, shoulders, arm, forearm, waist, hips, peace, calf);
}

void
MainController::getDabaseCompletedTrainings(User *user)
{
	m_database->getUserCompletedTrainings(user);
}

void
MainController::getDabaseCompletedExercises(QString traininId)
{
	m_database->getUserCompletedExercises(traininId);
}

void
MainController::addDatabaseCompletedTraining(User* user, QString trainingName)
{
	m_database->addCompletedTraining(user, trainingName);
}

void
MainController::deleteDatabaseCompletedTraining(User *user)
{
	m_database->deleteCompletedTraining(user);
}

void
MainController::addDatabaseCompletedExercise(QString trainingId, QString name, QList<QString> sets)
{
	m_database->addCompletedExercise(trainingId, name, sets);
}

void
MainController::completeTraining(QString trainingId)
{
	m_database->completeTraining(trainingId);
}

void
MainController::editDatabaseTrainingPlan(QString planId, User* user, QString name, QString description, bool isDefault)
{
	if (isDefault) {
		for (auto plan : user->getUserTrainingPlans()) {
			if (plan->isDefault()) {
				m_database->editTrainingPlan(plan->id(), user, plan->name(), plan->description(), false);
				break;
			}
		}
	}

	m_database->editTrainingPlan(planId, user, name, description, isDefault);
}

void
MainController::editDatabaseTraining(QString trainingId, User* user, QString name, QString planId)
{
	m_database->editTraining(trainingId, user, name, planId);
}

void
MainController::editDatabaseExercise(User* user, QString planId, QString exerciseId, QString trainingId, QString name, int breakTime, QList<QString> sets)
{
	m_database->editExercise(user, planId, exerciseId, trainingId, name, breakTime, sets);
}

void
MainController::deleteDatabaseTrainingPlan(User* user, QString planId)
{
	auto plan = getTrainingPlanById(user, planId);

	qWarning() << "Check order of removing objects";

	for (auto training : plan->getTrainings()) {
		deleteDatabaseTraining(user, planId, training->id());
	}

	m_database->deleteTrainingPlan(user, planId);
}

void
MainController::deleteDatabaseTraining(User* user, QString planId, QString trainingId)
{
	auto training = getTrainingById(user, planId, trainingId);

	for (auto exercise : training->getAllExercises()) {
		deleteDatabaseExercise(user, planId, trainingId, exercise->id());
	}

	m_database->deleteTraining(user, planId, trainingId);
}

void
MainController::deleteDatabaseExercise(User* user, QString planId, QString trainingId, QString exerciseId)
{
	m_database->deleteExercise(user, planId, trainingId, exerciseId);
}

void
MainController::addRequestForTrainer(QString trainerId)
{
	m_database->addRequestForTrainer(m_currentUser->id(), trainerId);
}

void
MainController::deleteTrainerFromUser(QString trainerId)
{
	m_database->deleteRequestForTrainer(m_currentUser->id(), trainerId);
}

void
MainController::deletePupilFromTrainer(User* trainer, QString pupilId)
{
	m_database->deletePupilFromUser(trainer, pupilId);
}

void
MainController::acceptPupil(QString pupilId)
{
	m_database->acceptPupilRequest(m_currentUser->id(), pupilId);
}

void
MainController::getDatabaseUserTrainerId(QString userId)
{
	m_database->getUserTrainerId(userId);
}

void
MainController::getDatabaseTrainerPupilsIds(QString trainerId)
{
	m_database->getTrainerPupilsIds(trainerId);
}

void
MainController::getDatabasePupilById(QString trainerId, QString pupilId)
{
	m_database->getPupilById(trainerId, pupilId);
}

User*
MainController::createPupilInstance(QObject* parent, QString pupilId, QString pupilUsername)
{
	return new User(parent, pupilId, pupilUsername);
}
