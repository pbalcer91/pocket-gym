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

Training*
TrainingPlan::getTrainingById(QString id)
{
	for (auto training : m_trainings) {
		if (training->id() == id)
			return training;
	}

	return nullptr;
}

void
TrainingPlan::editTrainingById(QString trainingId, QString ownerName, QString name, QString planId)
{
	if (!getTrainingById(trainingId))
		return;

	getTrainingById(trainingId)->setOwner(ownerName);
	getTrainingById(trainingId)->setName(name);
	getTrainingById(trainingId)->setPlanId(planId);

	emit trainingPlanChanged();
}

void
TrainingPlan::removeTrainingById(QString id)
{
	auto trainingToRemove = getTrainingById(id);

	m_trainings.removeOne(trainingToRemove);

	trainingToRemove->deleteLater();

	emit trainingPlanChanged();
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

