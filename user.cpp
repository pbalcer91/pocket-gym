#include "user.h"
#include <QDebug>

User::User(QObject *parent)
	: QObject{parent},
	  m_trainingsManager(new UserTrainingsManager()),
	  m_name("Piotr"),
	  m_email("piotr@piotr.pl"),
	  m_password("haslo")
{
	qDebug() << "User created";
}

User::~User()
{
	delete m_trainingsManager;
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

void
User::setName(QString name)
{
	if (name != m_name)
		m_name = name;
}

void
User::setEmail(QString email)
{
	if (email != m_email)
		m_email = email;
}

void
User::setPassword(QString password)
{
	if (password != m_password)
		m_password = password;
}

Exercise*
User::createExercise()
{
	if (!m_trainingsManager)
		return nullptr;

	return m_trainingsManager->createExercise();
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

	emit m_trainingsManager->getTrainingById(planId, trainingId)->trainingChanged();
}

void
User::removeTrainingById(QString planId, QString trainingId)
{
	m_trainingsManager->removeTrainingById(planId, trainingId);

	emit getTrainingPlanById(planId)->trainingPlanChanged();
}

Exercise*
User::getExercisegById(QString planId, QString trainingId, QString exerciseId)
{
	return m_trainingsManager->getExercisegById(planId, trainingId, exerciseId);
}
