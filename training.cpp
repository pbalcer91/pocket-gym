#include "training.h"


#include <QDebug>

Training::Training(QObject *parent)
	: QObject{parent},
	  m_id(""),
	  m_name(""),
	  m_owner(""),
	  m_planId("")
{}

Training::Training(QObject *parent, QString ownerName, QString planId)
	: QObject{parent},
	  m_id(""),
	  m_name(""),
	  m_owner(ownerName),
	  m_planId(planId)
{}

Training::Training(QObject *parent, QString id, QString ownerName, QString name, QString planId)
	: QObject{parent},
	  m_id(id),
	  m_name(name),
	  m_owner(ownerName),
	  m_planId(planId)
{}

Training::~Training()
{

}

QString
Training::id() const
{
	return m_id;
}

QString Training::name() const
{
	return m_name;
}

QString
Training::owner() const
{
	return m_owner;
}

QString
Training::planId() const
{
	return m_planId;
}

void
Training::setId(QString id)
{
	if (id == m_id)
		return;

	m_id = id;
	emit trainingChanged();
}

void Training::setName(QString name)
{
	if (name == m_name)
		return;

	m_name = name;
	emit trainingChanged();
}

void
Training::setOwner(QString owner)
{
	if (owner == m_owner)
		return;

	m_owner = owner;
	emit trainingChanged();
}

void
Training::setPlanId(QString planId)
{
	if (planId == m_planId)
		return;

	m_planId = planId;
	emit trainingChanged();
}

void
Training::addExercise(Exercise* exercise)
{
	m_exercises.push_back(exercise);
}

QList<Exercise*>
Training::getAllExercises()
{
	return m_exercises;
}

Exercise*
Training::getExerciseById(QString id)
{
	for (auto exercise : m_exercises) {
		if (exercise->id() == id)
			return exercise;
	}

	return nullptr;
}

void
Training::clearExercises()
{
	m_exercises.clear();
}

void
Training::removeTraining()
{
	delete this;
}
