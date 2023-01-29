#ifndef TRAINING_H
#define TRAINING_H

#include <QObject>

#include "exercise.h"

class Training : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString id READ id WRITE setId NOTIFY trainingChanged)
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY trainingChanged)
	Q_PROPERTY(QString ownerId READ ownerId WRITE setOwnerId NOTIFY trainingChanged)
	Q_PROPERTY(QString planId READ planId WRITE setPlanId NOTIFY trainingChanged)

public:
	explicit Training(QObject *parent = nullptr);
	Training(QObject *parent, QString ownerId, QString planId);
	Training(QObject *parent, QString id, QString ownerId, QString name, QString planId);
	~Training();

	QString id() const;
	QString name() const;
	QString ownerId() const;
	QString planId() const;

	void setId(QString id);
	void setName(QString name);
	void setOwnerId(QString oownerIdwner);
	void setPlanId(QString planId);

	void addExercise(Exercise* exercise);
	Q_INVOKABLE QList<Exercise*> getAllExercises();
	Exercise* getExerciseById(QString id);
	void editExerciseById(QString exerciseId, QString name, int breakTime, QString trainingId, QList<QString> setList);
	void removeExerciseById(QString exerciseId);

	Q_INVOKABLE void removeTraining();

signals:
	void trainingChanged();

private:
	QString m_id;
	QString m_name;
	QString m_ownerId;
	QString m_planId;

	QList<Exercise*> m_exercises;
};

#endif // TRAINING_H
