#include "trainingplan.h"

#include <QDebug>

TrainingPlan::TrainingPlan(QObject *parent)
	: QObject{parent},
	  m_id(""),
	  m_name(""),
	  m_description(""),
	  m_isDefault(false),
	  m_owner("")
{}

TrainingPlan::TrainingPlan(QObject *parent, QString ownerName)
	: QObject{parent},
	  m_id(""),
	  m_name(""),
	  m_description(""),
	  m_isDefault(false),
	  m_owner(ownerName)
{}

TrainingPlan::TrainingPlan(QObject *parent, QString ownerName, QString id)
	: QObject{parent},
	  m_id(id),
	  m_name(""),
	  m_description(""),
	  m_isDefault(false),
	  m_owner(ownerName)
{}

TrainingPlan::~TrainingPlan()
{

}

QString
TrainingPlan::id() const
{
	return m_id;
}

QString
TrainingPlan::name() const
{
	return m_name;
}

QString
TrainingPlan::description() const
{
	return m_description;
}

bool
TrainingPlan::isDefault() const
{
	return m_isDefault;
}

QString
TrainingPlan::owner() const
{
	return m_owner;
}

void
TrainingPlan::setId(QString id)
{
	if (id == m_id)
		return;

	m_id = id;
	emit trainingPlanChanged();
}

void
TrainingPlan::setName(QString name)
{
	if (name == m_name)
		return;

	m_name = name;
	emit trainingPlanChanged();
}

void
TrainingPlan::setDescription(QString description)
{
	if (description == m_description)
		return;

	m_description = description;
	emit trainingPlanChanged();
}

void
TrainingPlan::setIsDefault(bool isDefault)
{
	if (isDefault == m_isDefault)
		return;

	m_isDefault = isDefault;
	emit trainingPlanChanged();
}

void
TrainingPlan::setOwner(QString owner)
{
	if (owner == m_owner)
		return;

	m_owner = owner;
	emit trainingPlanChanged();
}

QList<Training*>
TrainingPlan::getTrainings()
{
	return m_trainings;
}

QList<Training*>
TrainingPlan::getTrainingsToAdd()
{
	return m_trainingsToAdd;
}

void
TrainingPlan::clearTrainingsToAdd()
{
	m_trainingsToAdd.clear();
}

void
TrainingPlan::removeTrainingPlan()
{
	delete this;
}

bool
TrainingPlan::addTraining(Training* training)
{
	m_trainings.push_back(training);

	return true;
}

bool
TrainingPlan::addTrainingList()
{
	if (m_trainingsToAdd.empty())
		return false;

	for (Training* training : m_trainingsToAdd) {
		m_trainings.append(training);
	}

	clearTrainingsToAdd();

	return true;
}

void
TrainingPlan::clearTrainings()
{
	m_trainings.clear();
}
