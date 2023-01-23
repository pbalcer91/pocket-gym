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


	void getTrainingExercises(QString trainingId);
	void getExercise(QString trainingId, QString exerciseId);

	//getUserTrainings

	void addUser(QString username, QString email, QString password);

	//sprawdzone do dodawanaia
	void addTrainingPlan(QString ownerName, QString name, QString description, bool isDefault);
	void addTraining(QString ownerName, QString name, QString planId);


	void addExercise(QString trainingId, QString name, int breakTime, QList<QString> sets);

	//addUserTraining

	//sprawdzone do edycji
	void editTrainingPlan(QString planId, QString ownerName, QString name, QString description, bool isDefault);
	void editTraining(QString trainingId, QString ownerName, QString name, QString planId);



	void editExercise(QString trainingId, Exercise* exercise);

	//sprawdzone do usuwania
	void deleteTrainingPlan(QString planId);
	void deleteTraining(QString planId, QString trainingId);

signals:
	void trainingExercisesReceived(QList<Exercise*> exercises);
	void exerciseReceived(Exercise* exercise);

	//sprawdzone
	void trainingPlansReceived(QList<TrainingPlan*> plans);
	void trainingPlanReceived(QString planId, QString name, QString description, bool isDefault);
	void trainingsReceived(QString planId, QList<Training*> trainings);
	void trainingReceived(QString trainingId, QString ownerName, QString name, QString planId);

	void trainingPlanAdded(QString ownerName);
	void trainingAdded(QString planId);

	void trainingPlanChanged(QString planId);
	void trainingChanged(QString trainingId);

	void trainingPlanRemoved(QString planId);
	void trainingRemoved(QString planId, QString trainingId);


private:
	QNetworkAccessManager* m_networkManager;

	std::shared_ptr<QMetaObject::Connection> m_connection;

	QString m_url;

	QBitArray stringToBitArray(QString bitString);
	QString setToString(int repeats, bool isMax);

	bool getIsMaxFromBitArray(QBitArray bitArray);
	int getRepeatsFromBitArray(QBitArray bitArray);
};

#endif // DATABASEHANDLER_H
