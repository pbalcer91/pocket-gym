#include "exercise.h"
#include <bitset>
#include <QDebug>

Exercise::Exercise(QObject *parent)
	: QObject{parent},
	  m_id(""),
	  m_name(""),
	  m_breakTime(0),
	  m_trainingId("")
{}

Exercise::Exercise(QObject *parent, QString trainingId)
	: QObject{parent},
	  m_id(""),
	  m_name(""),
	  m_breakTime(0),
	  m_trainingId(trainingId)
{}

Exercise::Exercise(QObject *parent, QString id, QString name, int breakTime, QString trainingId)
	: QObject{parent},
	  m_id(id),
	  m_name(name),
	  m_breakTime(breakTime),
	  m_trainingId(trainingId)
{}

Exercise::~Exercise()
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
Exercise::breakTime() const
{
	return m_breakTime;
}

QString
Exercise::trainingId() const
{
	return m_trainingId;
}

QList<QByteArray>
Exercise::sets()
{
	return m_sets;
}

QByteArray
Exercise::getSet(int index)
{
	if (index < 0 || index >= m_sets.size())
		return QByteArray(2, 0);

	return m_sets.at(index);
}

void
Exercise::addSet(int repeats, int weight)
{
	auto setToAdd = QByteArray(2, 0);

	setToAdd[0] = static_cast<char>(repeats);
	setToAdd[1] = static_cast<char>(weight);

	m_sets.push_back(setToAdd);
}

void
Exercise::clearSets()
{
	m_sets.clear();
}

void
Exercise::setId(QString id)
{
	if (id != m_id)
		m_id = id;

	emit exerciseChanged();
}

void
Exercise::setName(QString name)
{
	if (name != m_name)
		m_name = name;

	emit exerciseChanged();
}

void
Exercise::setBreakTime(int breakTime)
{
	if (breakTime != m_breakTime)
		m_breakTime = breakTime;

	emit exerciseChanged();
}

void
Exercise::setTrainingId(QString trainingId)
{
	if (trainingId != m_trainingId)
		m_trainingId = trainingId;

	emit exerciseChanged();
}

void
Exercise::setSets(QList<QByteArray> sets)
{
	m_sets = sets;

	emit exerciseChanged();
}

void
Exercise::replaceSetsList(QList<QString> setList)
{
	m_sets.clear();

	for (const auto &set : setList) {
		auto convertedSet = stringToByteArray(set);
		m_sets.push_back(convertedSet);
	}

	emit exerciseChanged();
}

void
Exercise::replaceCompletedSetsList(QList<QString> setList)
{
	m_sets.clear();

	for (const auto &set : setList) {
		auto convertedSet = stringToByteArrayForCompleted(set);
		m_sets.push_back(convertedSet);
	}
}

int
Exercise::getSetRepeats(QByteArray set)
{
	if (set.isEmpty())
		return -1;


	return set.at(set.size() - 1);
}

bool
Exercise::getSetIsMax(QByteArray set)
{
	if (set.isEmpty())
		return false;

	return set.at(0);
}

QString
Exercise::setToString(int repeats, bool isMax)
{
	QString result = (isMax ? "1" : "0");

	std::string stringRepeats = std::bitset<4>(repeats).to_string();

	result += QString::fromUtf8(stringRepeats.c_str());

	return result;
}

int
Exercise::getCompletedSetRepeats(QByteArray set)
{
	if (set.isEmpty())
		return -1;

	return set.at(0);
}

int
Exercise::getCompletedSetWeight(QByteArray set)
{
	if (set.isEmpty())
		return -1;

	return set.at(1);
}

QString
Exercise::completedSetToString(int repeats, int weight)
{
	QString result;

	std::string stringWeight = std::bitset<8>(weight).to_string();
	result += QString::fromUtf8(stringWeight.c_str());


	std::string stringRepeats = std::bitset<8>(repeats).to_string();
	result += QString::fromUtf8(stringRepeats.c_str());

	return result;
}

void
Exercise::removeExercise()
{
	this->deleteLater();
}

QByteArray
Exercise::stringToByteArray(QString bitsString)
{
	auto result = QByteArray(2, 0);

	if (bitsString[0] == '1')
		result[0] = 1;

	char repeats = 0;

	for (int i = 1; i < bitsString.size(); i++) {
		if (bitsString[i] == '0')
			continue;

		repeats += static_cast<int>(pow(2, bitsString.size() - i - 1));
	}

	result[result.size() - 1] = repeats;

	return result;
}

QByteArray
Exercise::stringToByteArrayForCompleted(QString bitString)
{
	auto result = QByteArray(2, 0);

	char repeats = 0;

	for (int i = 1; i < bitString.size(); i++) {
		if (bitString[i] == '0')
			continue;

		repeats += static_cast<int>(pow(2, bitString.size() - i - 1));
	}

	result[0] = repeats;

	char weight = 0;

	for (int i = 1; i < bitString.size(); i++) {
		if (bitString[i] == '0')
			continue;

		weight += static_cast<int>(pow(2, bitString.size() - i - 1));
	}

	result[1] = weight;

	return result;
}

