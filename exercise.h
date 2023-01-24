#ifndef EXERCISE_H
#define EXERCISE_H

#include <QObject>

class Exercise : public QObject
{
	Q_OBJECT

	Q_PROPERTY(QString id READ id WRITE setId NOTIFY exerciseChanged)
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY exerciseChanged)
	Q_PROPERTY(int breakTime READ breakTime WRITE setBreakTime NOTIFY exerciseChanged)
	Q_PROPERTY(QString trainingId READ trainingId WRITE setTrainingId NOTIFY exerciseChanged)
	Q_PROPERTY(QList<QByteArray> sets READ sets NOTIFY exerciseChanged)

public:
	explicit Exercise(QObject *parent = nullptr);
	Exercise(QObject *parent, QString trainingId);
	Exercise(QObject *parent, QString id, QString name, int breakTime, QString trainingId);
	~Exercise();

	QString id() const;
	QString name() const;
	int breakTime() const;
	QString trainingId() const;

	QList<QByteArray> sets();
	QByteArray getSet(int index);

	void setId(QString id);
	void setName(QString name);
	void setBreakTime(int breakTime);
	void setTrainingId(QString trainingId);
	void setSets(QList<QByteArray> sets);

	void replaceSetsList(QList<QString> setList);

	Q_INVOKABLE int getSetRepeats(QByteArray set);
	Q_INVOKABLE bool getSetIsMax(QByteArray set);
	Q_INVOKABLE QString setToString(int repeats, bool isMax);

	Q_INVOKABLE void removeExercise();

signals:
	void exerciseChanged();

private:
	QString m_id;
	QString m_name;
	int m_breakTime;
	QString m_trainingId;
	QList<QByteArray> m_sets;

	QString byteArrayToString(QByteArray bits);
	QByteArray stringToByteArray(QString bitString);
};

#endif // EXERCISE_H
