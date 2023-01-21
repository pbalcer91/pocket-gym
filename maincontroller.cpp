#include "maincontroller.h"
#include <QDebug>

MainController::MainController(QObject *parent)
	: QObject{parent},
	  m_database(new DatabaseHandler(this))
{
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
MainController::getUser()
{
	if (!m_currentUser)
		return nullptr;

	return m_currentUser;
}

Exercise*
MainController::createExercise()
{
	if (!m_currentUser)
		return nullptr;

	return m_currentUser->createExercise();
}

Training*
MainController::createTraining()
{
	if (!m_currentUser)
		return nullptr;

	return m_currentUser->createTraining();
}

TrainingPlan*
MainController::newTrainingPlan()
{
	if (!m_currentUser)
		return nullptr;

	return m_currentUser->createTrainingPlan();
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
MainController::getTrainigsFromDatabaseByPlanId(QString planId)
{
	m_database->getPlanTrainings(planId);

	QObject::connect(m_database, &DatabaseHandler::planTrainingsReceived,
					 this, [this, planId](QList<Training*> trainingList) {
		TrainingPlan* plan = m_currentUser->getTrainingPlanById(planId);
		plan->clearTrainings();

		for (auto training : trainingList) {
			Training* trainingToAdd = new Training(plan, training->id());

			trainingToAdd->setName(training->name());
			trainingToAdd->setOwner(training->owner());
			trainingToAdd->setPlanId(plan->id());

			plan->addTraining(trainingToAdd);
		}

		emit trainingsReady();

		QObject::disconnect(m_database, &DatabaseHandler::planTrainingsReceived,
							nullptr, nullptr);
	});
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
	m_database->addTrainingPlan(ownerName, name, description, isDefault);

	//jezeli isDefault to zmien isDefault wszystkich innych (to samo dla edycji)

	QObject::connect(m_database, &DatabaseHandler::trainingPlanAdded,
					 this, [this, ownerName]() {
		m_database->getUserTrainingPlans(ownerName);

		QObject::disconnect(m_database, &DatabaseHandler::trainingPlanAdded,
							nullptr, nullptr);
	});
}

void
MainController::editDatabaseTrainingPlan(QString planId, QString ownerName, QString name, QString description, bool isDefault)
{
	m_database->editTrainingPlan(planId, ownerName, name, description, isDefault);

	QObject::connect(m_database, &DatabaseHandler::trainingPlanReceived,
					 this, [this](QString planId, QString name, QString description, bool isDefault) {
		m_currentUser->editTrainingPlanById(planId, name, description, isDefault);

		emit trainingPlanReady(planId);

		QObject::disconnect(m_database, &DatabaseHandler::trainingPlanReceived,
							nullptr, nullptr);
	});

	QObject::connect(m_database, &DatabaseHandler::trainingPlanChanged,
					 this, [this](QString planId) {
		m_database->getTrainingPlanById(planId);

		QObject::disconnect(m_database, &DatabaseHandler::trainingPlanChanged,
							nullptr, nullptr);
	});
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

	QObject::connect(m_database, &DatabaseHandler::trainingPlanRemoved,
					 this, [this](QString planId) {
		m_currentUser->removeTrainingPlanById(planId);

		QObject::disconnect(m_database, &DatabaseHandler::trainingPlanRemoved,
							nullptr, nullptr);
	});
}

//void
//MainController::getExercise(QString trainingId, QString exerciseId)
//{
//	m_database->getExercise(trainingId, exerciseId);
//}
