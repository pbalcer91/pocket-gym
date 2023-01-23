#include "maincontroller.h"
#include <QDebug>

MainController::MainController(QObject *parent)
	: QObject{parent},
	  m_database(new DatabaseHandler(this))
{
	QObject::connect(m_database, &DatabaseHandler::trainingPlanAdded,
					 this, [this](QString ownerName) {
		m_database->getUserTrainingPlans(ownerName);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingPlansReceived,
					 this, [this](QList<TrainingPlan*> planList) {
		for (auto plan : planList) {
			if (m_currentUser->getTrainingPlanById(plan->id()))
				continue;

			TrainingPlan* planToAdd = new TrainingPlan(m_currentUser, plan->owner(), plan->id());

			planToAdd->setName(plan->name());
			planToAdd->setDescription(plan->description());
			planToAdd->setIsDefault(plan->isDefault());

			m_currentUser->addTraningPlan(planToAdd);
		}

		emit currentUserPlansReady();
	});

	QObject::connect(m_database, &DatabaseHandler::trainingPlanChanged,
					 this, [this](QString planId) {
		m_database->getTrainingPlanById(planId);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingPlanReceived,
					 this, [this](QString planId, QString name, QString description, bool isDefault) {
		m_currentUser->editTrainingPlanById(planId, name, description, isDefault);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingPlanRemoved,
					 this, [this](QString planId) {
		m_currentUser->removeTrainingPlanById(planId);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingAdded,
					 this, [this](QString planId) {
		m_database->getTrainingsByPlanId(planId);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingsReceived,
					 this, [this](QString planId, QList<Training*> trainingList) {
		TrainingPlan* plan = m_currentUser->getTrainingPlanById(planId);

		for (auto training : trainingList) {
			if (plan->getTrainingById(training->id()))
				continue;

			Training* trainingToAdd = new Training(plan,
												   training->id(),
												   training->owner(),
												   training->name(),
												   training->planId());

			plan->addTraining(trainingToAdd);
		}

		emit trainingsReady();
	});

	QObject::connect(m_database, &DatabaseHandler::trainingChanged,
					 this, [this](QString trainingId) {
		m_database->getTrainingById(trainingId);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingReceived,
					 this, [this](QString trainingId, QString ownerName, QString name, QString planId) {
		m_currentUser->editTrainingById(trainingId, ownerName, name, planId);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingRemoved,
					 this, [this](QString planId, QString trainingId) {
		m_currentUser->removeTrainingById(planId, trainingId);
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

void
MainController::createUser()
{
	m_currentUser = new User(this);
	m_currentUser->setName("Piotr");

	qDebug() << "USER: " << m_currentUser->name();
}

User*
MainController::getCurrentUser()
{
	if (!m_currentUser)
		return nullptr;

	return m_currentUser;
}

QString
MainController::getCurrentUserName()
{
	if (!m_currentUser)
		return "";

	return m_currentUser->name();
}

Exercise*
MainController::createExercise()
{
	if (!m_currentUser)
		return nullptr;

	return m_currentUser->createExercise();
}

TrainingPlan*
MainController::newTrainingPlan()
{
	if (!m_currentUser)
		return nullptr;

	return m_currentUser->createTrainingPlan();
}

Training*
MainController::newTraining(QString ownerName, QString planId)
{
	if (!m_currentUser)
		return nullptr;

	return m_currentUser->createTraining(ownerName, planId);
}

TrainingPlan*
MainController::getTrainingPlanById(QString id)
{
	return m_currentUser->getTrainingPlanById(id);
}

QList<TrainingPlan*>
MainController::getUserTrainingPlans()
{
	return m_currentUser->getUserTrainingPlans();
}

bool
MainController::addTraningPlan(TrainingPlan* trainingPlan)
{
	return m_currentUser->addTraningPlan(trainingPlan);
}

Training*
MainController::getTrainingById(QString planId, QString trainingId)
{
	return m_currentUser->getTrainingById(planId, trainingId);
}

Exercise*
MainController::getExercisegById(QString planId, QString trainingId, QString exerciseId)
{
	return m_currentUser->getExercisegById(planId, trainingId, exerciseId);
}

void
MainController::getDatabaseUserTrainingPlans()
{
	m_database->getUserTrainingPlans(m_currentUser->name());
}

void
MainController::getDatabaseTrainingsByPlanId(QString planId)
{
	m_database->getTrainingsByPlanId(planId);
}

void
MainController::getExercisesFromDatabaseByTrainingId(QString planId, QString trainingId)
{
	m_database->getTrainingExercises(trainingId);

	QObject::connect(m_database, &DatabaseHandler::trainingExercisesReceived,
					 this, [this, planId, trainingId](QList<Exercise*> exercisesList) {
		Training* training = m_currentUser->getTrainingById(planId, trainingId);
		training->clearExercises();

		for (auto exercise : exercisesList) {
			Exercise* exerciseToAdd = new Exercise(training, exercise->id());

			exerciseToAdd->setName(exercise->name());
			exerciseToAdd->setRestTime(exercise->restTime());

			for (auto set : exercise->sets()) {
				exerciseToAdd->addSet(set.index, set.repeats, set.isMax);
			}

			training->addExercise(exerciseToAdd);
		}

		emit exercisesReady();

		QObject::disconnect(m_database, &DatabaseHandler::trainingExercisesReceived,
							nullptr, nullptr);
	});
}

void
MainController::addDatabaseTrainingPlan(QString ownerName, QString name, QString description, bool isDefault)
{
	if (isDefault) {
		for (auto plan : m_currentUser->getUserTrainingPlans()) {
			if (plan->isDefault()) {
				m_database->editTrainingPlan(plan->id(), plan->owner(), plan->name(), plan->description(), false);
				break;
			}
		}
	}

	m_database->addTrainingPlan(ownerName, name, description, isDefault);
}

void
MainController::addDatabaseTraining(QString ownerName, QString name, QString planId)
{
	m_database->addTraining(ownerName, name, planId);
}

void
MainController::editDatabaseTrainingPlan(QString planId, QString ownerName, QString name, QString description, bool isDefault)
{
	if (isDefault) {
		for (auto plan : m_currentUser->getUserTrainingPlans()) {
			if (plan->isDefault()) {
				m_database->editTrainingPlan(plan->id(), plan->owner(), plan->name(), plan->description(), false);
				break;
			}
		}
	}

	m_database->editTrainingPlan(planId, ownerName, name, description, isDefault);
}

void
MainController::editDatabaseTraining(QString trainingId, QString ownerName, QString name, QString planId)
{
	m_database->editTraining(trainingId, ownerName, name, planId);
}

void
MainController::editDatabaseExercise(QString trainingId, Exercise* exercise)
{
	m_database->editExercise(trainingId, exercise);

	//na sygnal pobrac jeszcze raz dane z bazy o tym cwiczeniu
}

void
MainController::deleteDatabaseTrainingPlan(QString planId)
{
	m_database->deleteTrainingPlan(planId);
}

void
MainController::deleteDatabaseTraining(QString planId, QString trainingId)
{
	m_database->deleteTraining(planId, trainingId);
}

//void
//MainController::getExercise(QString trainingId, QString exerciseId)
//{
//	m_database->getExercise(trainingId, exerciseId);
//}
