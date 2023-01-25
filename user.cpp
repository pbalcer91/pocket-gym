#include "user.h"
#include <QDebug>

User::User(QObject *parent)
	: QObject{parent},
	  m_trainingsManager(new UserTrainingsManager()),
	  m_id("testoweIdUsera"),
	  m_name("Piotr"),
	  m_email("piotr@piotr.pl"),
	  m_password("haslo")
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

QString
User::password() const
{
	return m_password;
}

QList<Measurement*>
User::measurements() const
{
	return m_measurements;
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
User::setPassword(QString password)
{
	if (password != m_password)
		m_password = password;

	emit userDataChanged();
}

void
User::addMeasurement(QObject* parent,
					 QString id,
					 QDate date,
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
User::createTrainingPlan()
{
	if (!m_trainingsManager)
		return nullptr;

	return m_trainingsManager->createTrainingPlan(this->name());
}

Training*
User::createTraining(QString ownerName, QString planId)
{
	if (!m_trainingsManager)
		return nullptr;

	return m_trainingsManager->createTraining(ownerName, planId);
}

Exercise*
User::createExercise(QString planId, QString trainingId)
{
	if (!m_trainingsManager)
		return nullptr;

	return m_trainingsManager->createExercise(planId, trainingId);
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

	emit userTrainingPlansChanged();
}

Training*
User::getTrainingById(QString planId, QString trainingId)
{
	return m_trainingsManager->getTrainingById(planId, trainingId);
}

void
User::editTrainingById(QString trainingId, QString ownerName, QString name, QString planId)
{
	getTrainingPlanById(planId)->editTrainingById(trainingId, ownerName, name, planId);
}

void
User::removeTrainingById(QString planId, QString trainingId)
{
	m_trainingsManager->removeTrainingById(planId, trainingId);
}

Exercise*
User::getExercisegById(QString planId, QString trainingId, QString exerciseId)
{
	return m_trainingsManager->getExercisegById(planId, trainingId, exerciseId);
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
