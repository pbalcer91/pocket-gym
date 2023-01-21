#ifndef EXERCISE_H
#define EXERCISE_H

#include <QObject>

struct SetStruct {
	Q_GADGET
	Q_PROPERTY(int index MEMBER index)
	Q_PROPERTY(int repeats MEMBER repeats)
	Q_PROPERTY(double weight MEMBER weight)
	Q_PROPERTY(bool isMax MEMBER isMax)

public:
	int index;
	int repeats;
	double weight;
	bool isMax;

	SetStruct();
	SetStruct(int index,
			  int repeats,
			  bool isMax);
};
Q_DECLARE_METATYPE(SetStruct)

class Exercise : public QObject
{
	Q_OBJECT

	Q_PROPERTY(QString id READ id WRITE setId NOTIFY exerciseChanged)
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY exerciseChanged)
	Q_PROPERTY(int restTime READ restTime WRITE setRestTime NOTIFY exerciseChanged)
	Q_PROPERTY(QList<SetStruct> sets READ sets NOTIFY exerciseChanged)

public:
	explicit Exercise(QObject *parent = nullptr,
					  QString id = "");
	~Exercise() = default;

	QString id() const;
	QString name() const;
	int restTime() const;

	QList<SetStruct> sets();
	SetStruct getSet(int index);

	void setId(QString id);
	void setName(QString name);
	void setRestTime(int restTime);

	void addSet(int index, int repeats, bool isMax);
	bool removeSet(int index);
	bool editSet(int index, int repeats, bool isMax);

signals:
	void exerciseChanged();

private:
	QString m_id;
	QString m_name;
	int m_restTime;
	QList<SetStruct> m_sets;
};

#endif // EXERCISE_H
