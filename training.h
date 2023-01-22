#ifndef TRAINING_H
#define TRAINING_H

#include <QObject>

#include "exercise.h"

class Training : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString id READ id WRITE setId NOTIFY trainingChanged)
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY trainingChanged)
	Q_PROPERTY(QString owner READ owner WRITE setOwner NOTIFY trainingChanged)
	Q_PROPERTY(QString planId READ planId WRITE setPlanId NOTIFY trainingChanged)

public:
	explicit Training(QObject *parent = nullptr,
					  QString id= "");
	~Training();

	QString id() const;
	QString name() const;
	QString owner() const;
	QString planId() const;

	void setId(QString id);
	void setName(QString name);
	void setOwner(QString owner);
	void setPlanId(QString planId);

	void addExercise(Exercise* exercise);
	Q_INVOKABLE QList<Exercise*> getAllExercises();
	Exercise* getExerciseById(QString id);

	void clearExercises();

	Q_INVOKABLE void removeTraining();

signals:
	void trainingChanged();

private:
	QString m_id;
	QString m_name;
	QString m_owner;
	QString m_planId;

	QList<Exercise*> m_exercises;

};

#endif // TRAINING_H