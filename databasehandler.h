#ifndef DATABASEHANDLER_H
#define DATABASEHANDLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

#include <QBitArray>

#include "exercise.h"
#include "training.h"
#include "trainingplan.h"

class DatabaseHandler : public QObject
{
	Q_OBJECT

public:
	explicit DatabaseHandler(QObject *parent = nullptr);
	~DatabaseHandler();

	void getAllUsers();
	void getUser(QString username);

	//sprawdzone gettery
	void getUserTrainingPlans(QString username);
	void getTrainingPlanById(QString id);
	void getTrainingsByPlanId(QString planId);
	void getTrainingById(QString trainingId);
	void getExercisesByTrainingId(QString planId, QString trainingId);
	void getExerciseById(QString planId, QString exerciseId);

	//getUserTrainings

	void addUser(QString username, QString email, QString password);

	//sprawdzone do dodawanaia
	void addTrainingPlan(QString ownerName, QString name, QString description, bool isDefault);
	void addTraining(QString ownerName, QString name, QString planId);
	void addExercise(QString planId, QString trainingId, QString name, int breakTime, QList<QString> sets);

	//addUserTraining

	//sprawdzone do edycji
	void editTrainingPlan(QString planId, QString ownerName, QString name, QString description, bool isDefault);
	void editTraining(QString trainingId, QString ownerName, QString name, QString planId);
	void editExercise(QString planId, QString exerciseId, QString trainingId, QString name, int breakTime, QList<QString> sets);

	//sprawdzone do usuwania
	void deleteTrainingPlan(QString planId);
	void deleteTraining(QString planId, QString trainingId);
	void deleteExercise(QString planId, QString trainingId, QString exerciseId);

signals:
	void trainingPlansReceived(QList<TrainingPlan*> plans);
	void trainingPlanReceived(QString planId, QString name, QString description, bool isDefault);
	void trainingsReceived(QString planId, QList<Training*> trainings);
	void trainingReceived(QString trainingId, QString ownerName, QString name, QString planId);
	void exercisesReceived(QString planId, QString trainingId, QList<Exercise*> exercises);
	void exerciseReceived(QString planId, QString exerciseId, QString name, int breakTime, QString trainingId, QList<QString> setList);

	void trainingPlanAdded(QString ownerName);
	void trainingAdded(QString planId);
	void exerciseAdded(QString planId, QString trainingId);

	void trainingPlanChanged(QString planId);
	void trainingChanged(QString trainingId);
	void exerciseChanged(QString planId, QString exerciseId);

	void trainingPlanRemoved(QString planId);
	void trainingRemoved(QString planId, QString trainingId);
	void exerciseRemoved(QString planId, QString trainingId, QString exerciseId);

private:
	QNetworkAccessManager* m_networkManager;
	std::shared_ptr<QMetaObject::Connection> m_connection;
	QString m_url;
};

#endif // DATABASEHANDLER_H
