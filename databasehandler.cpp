#include "databasehandler.h"

#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QVariantMap>
#include <QDebug>

DatabaseHandler::DatabaseHandler(QObject *parent)
	: QObject{parent},
	  m_networkManager(new QNetworkAccessManager(this)),
	  m_connection(std::make_shared<QMetaObject::Connection>()),
	  m_url("https://pocket-gym-b561a-default-rtdb.europe-west1.firebasedatabase.app/")
{}

DatabaseHandler::~DatabaseHandler()
{
	m_networkManager->deleteLater();
}

void
DatabaseHandler::getUserByLogIn(QString email, QString password)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "users.json?orderBy=\"email\"&equalTo=\"" + email + "\"")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, password, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		for (const auto &key : rootObject.keys()) {
			auto userDocument = rootObject.value(key);
			auto userObject = userDocument.toObject();

			if (userObject.value("password").toString() != password)
				return;

			QString id = key;
			QString username = userObject.value("username").toString();
			QString email = userObject.value("email").toString();
			QString password = userObject.value("password").toString();
			bool isTrainer = userObject.value("isTrainer").toBool();

			emit userLoggedIn(id, username, email, password, isTrainer);

			return;
		}
	});
}

void
DatabaseHandler::getTrainerById(QString trainerId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "users.json?orderBy=\"isTrainer\"&equalTo=true")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, trainerId, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		for (const auto &key : rootObject.keys()) {
			if (key != trainerId)
				continue;

			auto trainerDocument = rootObject.value(key);
			auto trainerObject = trainerDocument.toObject();

			QString id = key;
			QString username = trainerObject.value("username").toString();

			emit trainerReceived(id, username);
			return;
		}
	});
}

void
DatabaseHandler::getTrainers()
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "users.json?orderBy=\"isTrainer\"&equalTo=true")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QVariantMap trainersList;

		for (const auto &key : rootObject.keys()) {
			auto userDocument = rootObject.value(key);
			auto userObject = userDocument.toObject();

			QString id = key;
			QString username = userObject.value("username").toString();

			trainersList.insert(id, username);
		}

		emit trainersReceived(trainersList);
	});
}

void
DatabaseHandler::getUserTrainerId(QString userId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "users/.json?orderBy=\"isTrainer\"&equalTo=true")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, userId, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		for (const auto &key : rootObject.keys()) {
			auto trainerDocument = rootObject.value(key);
			auto trainerObject = trainerDocument.toObject();

			QString id = key;
			QString username = trainerObject.value("username").toString();

			auto pupilListDocument = trainerObject.value("pupils");
			auto pupilListObject = pupilListDocument.toObject();

			for (const auto &pupilKey : pupilListObject.keys()) {
				if (pupilKey != userId)
					continue;

				bool isConfirmed = pupilListObject.value(pupilKey).toBool();

				emit userTrainerIdReceived(id, username, isConfirmed);
				return;
			}
		}
	});
}

void
DatabaseHandler::getUserTrainingPlans(QString username)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "trainingPlans.json?orderBy=\"owner\"&equalTo=\"" + username + "\"")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, username, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QList<TrainingPlan*> planList;

		for (const auto &key : rootObject.keys()) {
			auto planDocument = rootObject.value(key);
			auto planObject = planDocument.toObject();

			QString id = key;
			QString ownerName = planObject.value("owner").toString();

			TrainingPlan* plan = new TrainingPlan(this, ownerName, id);

			plan->setName(planObject.value("name").toString());
			plan->setDescription(planObject.value("description").toString());
			plan->setIsDefault(planObject.value("isDefault").toBool());

			planList.push_back(plan);
		}

		emit trainingPlansReceived(planList);
	});
}

void
DatabaseHandler::getTrainingPlanById(QString id)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "trainingPlans/" + id + ".json")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, id, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QString name = rootObject.value("name").toString();
		QString description = rootObject.value("description").toString();
		bool isDefault = rootObject.value("isDefault").toBool();

		emit trainingPlanReceived(id, name, description, isDefault);
	});
}

void
DatabaseHandler::getTrainingsByPlanId(QString planId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "trainings.json?orderBy=\"planId\"&equalTo=\"" + planId + "\"")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, planId, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QList<Training*> trainingList;

		for (const auto &key : rootObject.keys()) {
			auto trainingDocument = rootObject.value(key);
			auto trainingObject = trainingDocument.toObject();

			QString id = key;
			QString ownerName = trainingObject.value("owner").toString();
			QString name = trainingObject.value("name").toString();
			QString planId = trainingObject.value("planId").toString();

			Training* training = new Training(this, id, ownerName, name, planId);

			trainingList.push_back(training);
		}

		emit trainingsReceived(planId, trainingList);
	});
}

void
DatabaseHandler::getTrainingById(QString trainingId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "trainings/" + trainingId + ".json")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, trainingId, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QString ownerName = rootObject.value("owner").toString();
		QString name = rootObject.value("name").toString();
		QString planId = rootObject.value("planId").toString();

		emit trainingReceived(trainingId, ownerName, name, planId);
	});
}

void
DatabaseHandler::getExercisesByTrainingId(QString planId, QString trainingId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "exercises.json?orderBy=\"trainingId\"&equalTo=\"" + trainingId + "\"")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, planId, trainingId, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QList<Exercise*> exerciseList;

		for (const auto &key : rootObject.keys()) {
			auto exerciseDocument = rootObject.value(key);
			auto exerciseObject = exerciseDocument.toObject();

			QString id = key;
			QString name = exerciseObject.value("name").toString();
			int breakTime = exerciseObject.value("breakTime").toInt();
			QString trainingId = exerciseObject.value("trainingId").toString();

			Exercise* exercise = new Exercise(this, id, name, breakTime, trainingId);

			QList<QString> setList;

			for (const auto &key : exerciseObject.keys()) {
				if (key.toUInt()) {
					auto set = exerciseObject.value(key).toString();
					setList.push_back(set);
				}
			}

			exercise->replaceSetsList(setList);

			exerciseList.push_back(exercise);		
		}

		emit exercisesReceived(planId, trainingId, exerciseList);
	});
}

void
DatabaseHandler::getExerciseById(QString planId, QString exerciseId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "exercises/" + exerciseId + ".json")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, planId, exerciseId, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QString name = rootObject.value("name").toString();
		int breakTime = rootObject.value("breakTime").toInt();
		QString trainingId = rootObject.value("trainingId").toString();

		QList<QString> setList;

		for (const auto &key : rootObject.keys()) {
			if (key.toUInt()) {
				auto set = rootObject.value(key).toString();
				setList.push_back(set);
			}
		}

		emit exerciseReceived(planId, exerciseId, name, breakTime, trainingId, setList);
	});
}

void
DatabaseHandler::getMeasurementsByUserId(QString userId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "measurements.json?orderBy=\"userId\"&equalTo=\"" + userId + "\"")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, userId, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QList<Measurement*> measurementList;

		for (const auto &key : rootObject.keys()) {
			auto measurementDocument = rootObject.value(key);
			auto measurementObject = measurementDocument.toObject();

			QString id = key;
			double weight = measurementObject.value("weight").toDouble();
			double chest = measurementObject.value("chest").toDouble();
			double shoulders = measurementObject.value("shoulders").toDouble();
			double arm = measurementObject.value("arm").toDouble();
			double forearm = measurementObject.value("forearm").toDouble();
			double waist = measurementObject.value("waist").toDouble();
			double hips = measurementObject.value("hips").toDouble();
			double peace = measurementObject.value("peace").toDouble();
			double calf = measurementObject.value("calf").toDouble();
			long long timestamp = measurementObject.value("timestamp").toInteger();

			Measurement* measurement = new Measurement(this, weight, chest, shoulders, arm,
													   forearm, waist, hips, peace, calf);

			QDateTime dateTime;
			dateTime.setSecsSinceEpoch(timestamp);

			measurement->setId(id);
			measurement->setDate(dateTime.date());

			measurementList.push_back(measurement);
		}

		emit measurementsReceived(userId, measurementList);
	});
}

void
DatabaseHandler::addUser(QString username, QString email, QString password, bool isTrainer)
{
	QVariantMap databaseUser;
	databaseUser["username"] = username;
	databaseUser["email"] = email;
	databaseUser["password"] = password;
	databaseUser["isTrainer"] = isTrainer;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databaseUser);
	QNetworkRequest request(QUrl(m_url + "users.json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->post(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, reply](){
		reply->deleteLater();
		emit userAdded();
	});
}

void
DatabaseHandler::addTrainingPlan(QString ownerName, QString name, QString description, bool isDefault)
{
	QVariantMap databasePlan;
	databasePlan["name"] = name;
	databasePlan["description"] = description;
	databasePlan["isDefault"] = isDefault;
	databasePlan["owner"] = ownerName;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databasePlan);
	QNetworkRequest request(QUrl(m_url + "trainingPlans.json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->post(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, ownerName, reply](){
		reply->deleteLater();
		emit trainingPlanAdded(ownerName);
	});
}

void
DatabaseHandler::addTraining(QString ownerName, QString name, QString planId)
{
	QVariantMap databaseTraining;
	databaseTraining["owner"] = ownerName;
	databaseTraining["name"] = name;
	databaseTraining["planId"] = planId;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databaseTraining);

	QNetworkRequest request(QUrl(m_url + "trainings.json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->post(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, planId, reply](){
		reply->deleteLater();
		emit trainingAdded(planId);
	});
}

void
DatabaseHandler::addExercise(QString planId, QString trainingId, QString name, int breakTime, QList<QString> sets)
{
	QVariantMap databaseExercise;
	databaseExercise["name"] = name;
	databaseExercise["breakTime"] = breakTime;
	databaseExercise["trainingId"] = trainingId;

	for (int i = 0; i < sets.size(); i++) {
		databaseExercise[QString::number(i + 1)] = sets[i];
	}

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databaseExercise);

	QNetworkRequest request(QUrl(m_url + "exercises.json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->post(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, planId, trainingId, reply](){
		reply->deleteLater();
		emit exerciseAdded(planId, trainingId);
	});
}

void
DatabaseHandler::addMeasurement(QString userId, double weight, double chest, double shoulders, double arm,
								double forearm, double waist, double hips, double peace, double calf)
{
	QVariantMap databaseMeasurement;
	databaseMeasurement["userId"] = userId;
	databaseMeasurement["timestamp"] = QDateTime::currentSecsSinceEpoch();
	databaseMeasurement["weight"] = weight;
	databaseMeasurement["chest"] = chest;
	databaseMeasurement["shoulders"] = shoulders;
	databaseMeasurement["arm"] = arm;
	databaseMeasurement["forearm"] = forearm;
	databaseMeasurement["waist"] = waist;
	databaseMeasurement["hips"] = hips;
	databaseMeasurement["peace"] = peace;
	databaseMeasurement["calf"] = calf;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databaseMeasurement);

	QNetworkRequest request(QUrl(m_url + "measurements.json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->post(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, userId, reply](){
		reply->deleteLater();
		emit measurementAdded(userId);
	});
}

void
DatabaseHandler::editTrainingPlan(QString planId, QString ownerName, QString name, QString description, bool isDefault)
{
	QVariantMap databasePlan;
	databasePlan["name"] = name;
	databasePlan["description"] = description;
	databasePlan["isDefault"] = isDefault;
	databasePlan["owner"] = ownerName;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databasePlan);

	QNetworkRequest request(QUrl(m_url + "trainingPlans/" + planId + ".json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->put(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, planId, reply](){
		reply->deleteLater();
		emit trainingPlanChanged(planId);
	});
}

void
DatabaseHandler::editTraining(QString trainingId, QString ownerName, QString name, QString planId)
{
	QVariantMap databaseTraining;
	databaseTraining["owner"] = ownerName;
	databaseTraining["name"] = name;
	databaseTraining["planId"] = planId;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databaseTraining);

	QNetworkRequest request(QUrl(m_url + "trainings/" + trainingId + ".json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->put(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, trainingId, reply](){
		reply->deleteLater();
		emit trainingChanged(trainingId);
	});
}

void
DatabaseHandler::editExercise(QString planId, QString exerciseId, QString trainingId, QString name, int breakTime, QList<QString> sets)
{
	QVariantMap databaseExercise;
	databaseExercise["name"] = name;
	databaseExercise["breakTime"] = breakTime;
	databaseExercise["trainingId"] = trainingId;

	for (const auto &set : sets) {
		databaseExercise[QString::number(sets.indexOf(set) + 1)] = set;
	}

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databaseExercise);

	QNetworkRequest request(QUrl(m_url + "exercises/" + exerciseId + ".json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->put(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, planId, exerciseId, reply](){
		reply->deleteLater();
		emit exerciseChanged(planId, exerciseId);
	});
}

void
DatabaseHandler::deleteTrainingPlan(QString planId)
{
	QNetworkRequest request(QUrl(m_url + "trainingPlans/" + planId + ".json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->deleteResource(request);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, planId, reply](){
		reply->deleteLater();

		emit trainingPlanRemoved(planId);
	});
}

void
DatabaseHandler::deleteTraining(QString planId, QString trainingId)
{
	QNetworkRequest request(QUrl(m_url + "trainings/" + trainingId + ".json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->deleteResource(request);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, planId, trainingId, reply](){
		reply->deleteLater();

		emit trainingRemoved(planId, trainingId);
	});
}

void
DatabaseHandler::deleteExercise(QString planId, QString trainingId, QString exerciseId)
{
	QNetworkRequest request(QUrl(m_url + "exercises/" + exerciseId + ".json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->deleteResource(request);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, planId, trainingId, exerciseId, reply](){
		reply->deleteLater();

		emit exerciseRemoved(planId, trainingId, exerciseId);
	});
}

void
DatabaseHandler::addRequestForTrainer(QString userId, QString trainerId)
{
	QVariantMap databasePupil;
	databasePupil[userId] = false;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databasePupil);

	QNetworkRequest request(QUrl(m_url + "users/" + trainerId + "/pupils.json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->put(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this,userId, trainerId, reply](){
		reply->deleteLater();

		addTrainerToUser(userId, trainerId);
	});
}

void
DatabaseHandler::deleteRequestForTrainer(QString userId, QString trainerId)
{
	QNetworkRequest request(QUrl(m_url + "users/" + trainerId + "/pupils/" + userId + ".json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->deleteResource(request);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, userId, trainerId, reply](){
		reply->deleteLater();

		deleteTrainerFromUser(userId);
	});
}

void
DatabaseHandler::addTrainerToUser(QString userId, QString trainerId)
{
	QVariantMap databaseTrainer;
	databaseTrainer[trainerId] = false;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databaseTrainer);

	QNetworkRequest request(QUrl(m_url + "users/" + userId + "/trainer.json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->put(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, trainerId, reply](){
		reply->deleteLater();

		emit trainerRequestAdded(trainerId);
	});
}

void
DatabaseHandler::deleteTrainerFromUser(QString userId)
{
	QNetworkRequest request(QUrl(m_url + "users/" + userId + "/trainer.json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->deleteResource(request);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, reply](){
		reply->deleteLater();

		emit trainerRequestRemoved();
	});
}
