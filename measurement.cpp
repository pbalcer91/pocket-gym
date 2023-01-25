#include "measurement.h"

Measurement::Measurement(QObject *parent)
	: QObject{parent},
	  m_weight(0),
	  m_chest(0),
	  m_shoulders(0),
	  m_arm(0),
	  m_forearm(0),
	  m_waist(0),
	  m_hips(0),
	  m_peace(0),
	  m_calf(0)
{}

Measurement::Measurement(QObject *parent, double weight)
	: QObject{parent},
	  m_weight(weight),
	  m_chest(0),
	  m_shoulders(0),
	  m_arm(0),
	  m_forearm(0),
	  m_waist(0),
	  m_hips(0),
	  m_peace(0),
	  m_calf(0)
{}

Measurement::Measurement(QObject *parent,
						 double weight,
						 double chest,
						 double shoulders,
						 double arm,
						 double forearm,
						 double waist,
						 double hips,
						 double peace,
						 double calf)
	: QObject{parent},
	  m_weight(weight),
	  m_chest(chest),
	  m_shoulders(shoulders),
	  m_arm(arm),
	  m_forearm(forearm),
	  m_waist(waist),
	  m_hips(hips),
	  m_peace(peace),
	  m_calf(calf)
{}

Measurement::~Measurement()
{}

QString
Measurement::id() const
{
	return m_id;
}

QDate
Measurement::date() const
{
	return m_date;
}

double
Measurement::weight() const
{
	return m_weight;
}

double
Measurement::chest() const
{
	return m_chest;
}

double
Measurement::shoulders() const
{
	return m_shoulders;
}

double
Measurement::arm() const
{
	return m_arm;
}

double
Measurement::forearm() const
{
	return m_forearm;
}

double
Measurement::waist() const
{
	return m_waist;
}

double
Measurement::hips() const
{
	return m_hips;
}

double
Measurement::peace() const
{
	return m_peace;
}

double
Measurement::calf() const
{
	return m_calf;
}

void
Measurement::setId(QString id)
{
	m_id = id;

	emit measurementChanged();
}

void
Measurement::setDate(QDate date)
{
	m_date = date;

	emit measurementChanged();
}

void
Measurement::setWeight(double weight)
{
	m_weight = weight;

	emit measurementChanged();
}

void
Measurement::setChest(double circuit)
{
	m_chest = circuit;

	emit measurementChanged();
}

void
Measurement::setShoulders(double circuit)
{
	m_shoulders = circuit;

	emit measurementChanged();
}

void
Measurement::setArm(double circuit)
{
	m_arm = circuit;

	emit measurementChanged();
}

void
Measurement::setForearm(double circuit)
{
	m_forearm = circuit;

	emit measurementChanged();
}

void Measurement::setWaist(double circuit)
{
	m_waist = circuit;

	emit measurementChanged();
}

void Measurement::setHips(double circuit)
{
	m_hips = circuit;

	emit measurementChanged();
}

void Measurement::setPeace(double circuit)
{
	m_peace = circuit;

	emit measurementChanged();
}

void Measurement::setCalf(double circuit)
{
	m_calf = circuit;

	emit measurementChanged();
}
