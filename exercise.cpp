#include "exercise.h"

Exercise::Exercise(QObject *parent, QString id)
	: QObject{parent},
	  m_id(id),
	  m_name(""),
	  m_restTime(0)
{}

QString
Exercise::id() const
{
	return m_id;
}

QString
Exercise::name() const
{
	return m_name;
}

int
Exercise::restTime() const
{
	return m_restTime;
}

QList<SetStruct>
Exercise::sets()
{
	return m_sets;
}

SetStruct
Exercise::getSet(int index)
{
	if (index < 0 || index >= m_sets.size())
		return SetStruct();

	return m_sets.at(index);
}

void
Exercise::setId(QString id)
{
	if (id != m_id)
		m_id = id;
}

void
Exercise::setName(QString name)
{
	if (name != m_name)
		m_name = name;
}

void
Exercise::setRestTime(int restTime)
{
	if (restTime != m_restTime)
		m_restTime = restTime;
}

void
Exercise::addSet(int index, int repeats, bool isMax)
{
	m_sets.push_back(SetStruct(index, repeats, isMax));
}

bool
Exercise::removeSet(int index)
{
	if (index < 0 || index >= m_sets.size())
		return false;

	m_sets.removeAt(index);
	return true;
}

bool
Exercise::editSet(int index, int repeats, bool isMax)
{
	if (index < 0 || index >= m_sets.size())
		return false;

	m_sets[index].repeats = repeats;
	m_sets[index].isMax = isMax;

	return true;
}

SetStruct::SetStruct()
	: index(0),
	  repeats(0),
	  weight(0),
	  isMax(false)
{}

SetStruct::SetStruct(int index, int repeats, bool isMax)
	: index(index),
	  repeats(repeats),
	  weight(0),
	  isMax(isMax)
{}


