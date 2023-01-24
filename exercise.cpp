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

void
Exercise::removeExercise()
{
	this->deleteLater();
}

QString
Exercise::byteArrayToString(QByteArray bits)
{
	if (bits.isEmpty())
		return "00000";

	QString convertedSet;

	for (int i = bits.size() - 1; i >= 0; i--) {
		convertedSet.push_back(bits.at(i) ? '1' : '0');
	}

	return convertedSet;
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

