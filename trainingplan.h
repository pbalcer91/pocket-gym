#ifndef TRAININGPLAN_H
#define TRAININGPLAN_H

#include <QObject>

#include "training.h"

class TrainingPlan : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString id READ id WRITE setId NOTIFY trainingPlanChanged)
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY trainingPlanChanged)
	Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY trainingPlanChanged)
	Q_PROPERTY(bool isDefault READ isDefault WRITE setIsDefault NOTIFY trainingPlanChanged)
	Q_PROPERTY(QString ownerId READ ownerId WRITE setOwnerId NOTIFY trainingPlanChanged)

public:
	explicit TrainingPlan(QObject *parent = nullptr);
	TrainingPlan(QObject *parent, QString ownerId);
	TrainingPlan(QObject *parent, QString ownerId, QString id);
	~TrainingPlan();

	QString id() const;
	QString name() const;
	QString description() const;
	bool isDefault() const;
	QString ownerId() const;

	void setId(QString id);
	void setName(QString name);
	void setDescription(QString description);
	void setIsDefault(bool isDefault);
	void setOwnerId(QString ownerId);

	Q_INVOKABLE QList<Training*> getTrainings();
	Training* getTrainingById(QString id);
	void editTrainingById(QString trainingId, QString ownerId, QString name, QString planId);
	void removeTrainingById(QString id);

	Q_INVOKABLE void removeTrainingPlan();

	Q_INVOKABLE bool addTraining(Training* training);

signals:
	void trainingPlanChanged();

private:
	QString m_id;
	QString m_name;
	QString m_description;
	bool m_isDefault;
	QString m_ownerId;

	QList<Training*> m_trainings;
};

#endif // TRAININGPLAN_H
