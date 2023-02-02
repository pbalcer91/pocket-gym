#ifndef MEASUREMENT_H
#define MEASUREMENT_H

#include <QObject>
#include <QDateTime>

class Measurement : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString id READ id WRITE setId NOTIFY measurementChanged)
	Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY measurementChanged)
	Q_PROPERTY(double weight READ weight WRITE setWeight NOTIFY measurementChanged)
	Q_PROPERTY(double chest READ chest WRITE setChest NOTIFY measurementChanged)
	Q_PROPERTY(double shoulders READ shoulders WRITE setShoulders NOTIFY measurementChanged)
	Q_PROPERTY(double arm READ arm WRITE setArm NOTIFY measurementChanged)
	Q_PROPERTY(double forearm READ forearm WRITE setForearm NOTIFY measurementChanged)
	Q_PROPERTY(double waist READ waist WRITE setWaist NOTIFY measurementChanged)
	Q_PROPERTY(double hips READ hips WRITE setHips NOTIFY measurementChanged)
	Q_PROPERTY(double peace READ peace WRITE setPeace NOTIFY measurementChanged)
	Q_PROPERTY(double calf READ calf WRITE setCalf NOTIFY measurementChanged)

public:
	explicit Measurement(QObject *parent = nullptr);
	Measurement(QObject *parent, double weight);
	Measurement(QObject *parent,
				double weight,
				double chest,
				double shoulders,
				double arm,
				double forearm,
				double waist,
				double hips,
				double peace,
				double calf);

	~Measurement();

	QString id() const;
	QDateTime date() const;
	double weight() const;
	double chest() const;
	double shoulders() const;
	double arm() const;
	double forearm() const;
	double waist() const;
	double hips() const;
	double peace() const;
	double calf() const;

	void setId(QString id);
	void setDate(QDateTime date);
	void setWeight(double weight);
	void setChest(double circuit);
	void setShoulders(double circuit);
	void setArm(double circuit);
	void setForearm(double circuit);
	void setWaist(double circuit);
	void setHips(double circuit);
	void setPeace(double circuit);
	void setCalf(double circuit);

signals:
	void measurementChanged();

private:
	QString m_id;
	QDateTime m_date;
	double m_weight;
	double m_chest;
	double m_shoulders;
	double m_arm;
	double m_forearm;
	double m_waist;
	double m_hips;
	double m_peace;
	double m_calf;
};

#endif // MEASUREMENT_H
