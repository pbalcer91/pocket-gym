#include "user.h"
#include <QDebug>

User::User(QObject *parent)
	: QObject{parent},
	  m_trainingsManager(new UserTrainingsManager()),
	  m_id(""),
	  m_name(""),
	  m_email(""),
	  m_isTrainer(false),
	  m_trainerId(""),
	  m_trainerUsername("")
{}

User::User(QObject *parent, QString id)
	: QObject(parent),
	  m_trainingsManager(new UserTrainingsManager()),
	  m_id(id)
{}

User::User(QObject *parent, QString id, QString username)
	: QObject(parent),
	  m_trainingsManager(new UserTrainingsManager()),
	  m_id(id),
	  m_name(username)
{}

User::User(QObject *parent, QString id, QString username, QString email, bool isTrainer)
	: QObject{parent},
	  m_trainingsManager(new UserTrainingsManager()),
	  m_id(id),
	  m_name(username),
	  m_email(email),
	  m_isTrainer(isTrainer),
	  m_trainerId(""),
	  m_trainerUsername("")
{}

User::~User()
{
	m_trainingsManager->deleteLater();
}

QString
User::id() const
{
	return m_id;
}

QString
User::name() const
{
	return m_name;
}

QString
User::email() const
{
	return m_email;
}

QList<Measurement*>
User::measurements() const
{
	return m_measurements;
}

bool
User::isTrainer() const
{
	return m_isTrainer;
}

QList<QString>
User::pupilsIds() const
{
	return m_pupilsIds;
}

QString
User::trainerId() const
{
	return m_trainerId;
}

QString
User::trainerUsername() const
{
	return m_trainerUsername;
}

bool
User::isTrainerConfirmed() const
{
	return m_isTrainerConfirmed;
}

void
User::setId(QString id)
{
	if (id != m_id)
		m_id = id;

	emit userDataChanged();
}

void
User::setName(QString name)
{
	if (name != m_name)
		m_name = name;

	emit userDataChanged();
}

void
User::setEmail(QString email)
{
	if (email != m_email)
		m_email = email;

	emit userDataChanged();
}

void
User::setIsTrainer(bool isTrainer)
{
	if (isTrainer != m_isTrainer)
		m_isTrainer = isTrainer;

	emit userDataChanged();
}

void
User::setTrainerId(QString trainerId)
{
	if (trainerId != m_trainerId)
		m_trainerId = trainerId;

	emit userDataChanged();
}

void
User::setTrainerUsername(QString username)
{
	if (username != m_trainerUsername)
		m_trainerUsername = username;

	emit userDataChanged();
}

void
User::setIsTrainerConfirmed(bool isConfirmed)
{
	if (isConfirmed != m_isTrainerConfirmed)
		m_isTrainerConfirmed = isConfirmed;

	emit userDataChanged();
}

void
User::addPupilId(QString id)
{
	if (isPupilById(id))
		return;

	m_pupilsIds.push_back(id);

	emit userDataChanged();
}

void
User::clearPupilsIds()
{
	m_pupilsIds.clear();
}

bool
User::isPupilById(QString userId)
{
	for(const auto &pupilId : m_pupilsIds) {
		if (pupilId == userId)
			return (true);
	}

	return (false);
}

void
User::addMeasurement(QObject* parent,
					 QString id,
					 QDateTime date,
					 double weight,
					 double chest,
					 double shoulders,
					 double arm,
					 double forearm,
					 double waist,
					 double hips,
					 double peace,
					 double calf)
{
	if (weight <= 0 || chest <= 0 || shoulders <= 0
			|| arm <= 0|| forearm <= 0 || waist <= 0
			|| hips <= 0 || peace <= 0 || calf <= 0)
		return;


	auto newMeasurement = new Measurement(parent, weight, chest, shoulders, arm,
										  forearm, waist, hips, peace, calf);

	newMeasurement->setId(id);
	newMeasurement->setDate(date);

	m_measurements.push_back(newMeasurement);

}

Measurement*
User::getMeasurementById(QString id)
{
	for (auto measurement : m_measurements) {
		if (measurement->id() == id)
			return measurement;
	}

	return nullptr;
}

TrainingPlan*
User::getTrainingPlanById(QString id)
{
	return m_trainingsManager->getTrainingPlanById(id);
}

QList<TrainingPlan*>
User::getUserTrainingPlans()
{
	return m_trainingsManager->getTrainingPlans();
}

bool
User::addTraningPlan(TrainingPlan* trainingPlan)
{
	bool result = m_trainingsManager->addTraningPlan(trainingPlan);

	emit userTrainingPlansChanged();

	return result;
}

void
User::editTrainingPlanById(QString planId, QString name, QString description, bool isDefault)
{
	if (!getTrainingPlanById(planId))
		return;

	getTrainingPlanById(planId)->setName(name);
	getTrainingPlanById(planId)->setDescription(description);
	getTrainingPlanById(planId)->setIsDefault(isDefault);

	emit userTrainingPlansChanged();
}

void
User::removeTrainingPlanById(QString planId)
{
	m_trainingsManager->removeTrainingPlanById(planId);

	emit userTrainingPlanRemoved();
	emit userTrainingPlansChanged();
}

Training*
User::getTrainingById(QString planId, QString trainingId)
{
	return m_trainingsManager->getTrainingById(planId, trainingId);
}

void
User::editTrainingById(QString trainingId, QString ownerId, QString name, QString planId)
{
	getTrainingPlanById(planId)->editTrainingById(trainingId, ownerId, name, planId);
}

void
User::removeTrainingById(QString planId, QString trainingId)
{
	m_trainingsManager->removeTrainingById(planId, trainingId);
}

Exercise*
User::getExerciseById(QString planId, QString trainingId, QString exerciseId)
{
	return m_trainingsManager->getExerciseById(planId, trainingId, exerciseId);
}

void
User::editExerciseById(QString planId, QString exerciseId, QString name, int breakTime, QString trainingId, QList<QString> setList)
{
	getTrainingById(planId, trainingId)->editExerciseById(exerciseId, name, breakTime, trainingId, setList);
}

void
User::removeExerciseById(QString planId, QString trainingId, QString exerciseId)
{
	m_trainingsManager->removeExerciseById(planId, trainingId, exerciseId);
}
