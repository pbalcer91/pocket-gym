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
{
	//getTraining("-NK_Y0pRUnoQBFpBBMHG");
}

DatabaseHandler::~DatabaseHandler()
{
	m_networkManager->deleteLater();
}

void
DatabaseHandler::getAllUsers()
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "users.json")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [reply](){
		reply->deleteLater();
	});
}

void
DatabaseHandler::getUser(QString username)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "users/" + username + ".json")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [reply](){
		reply->deleteLater();
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
DatabaseHandler::getPlanTrainings(QString planId)
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
			Training* trainingToAdd = new Training(this, key);

			auto trainingDocument = rootObject.value(key);
			auto trainingObject = trainingDocument.toObject();

			for (const auto &trainingKey : trainingObject.keys()) {
				if (trainingKey == "name") {
					trainingToAdd->setName(trainingObject.value(trainingKey).toString());
					continue;
				}

				if (trainingKey == "owner") {
					trainingToAdd->setOwner(trainingObject.value(trainingKey).toString());
					continue;
				}

				if (trainingKey == "planId")
					trainingToAdd->setPlanId(trainingObject.value(trainingKey).toString());
			}

			trainingList.push_back(trainingToAdd);
		}

		emit planTrainingsReceived(trainingList);
	});
}

void
DatabaseHandler::getTraining(QString trainingId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "trainings/" + trainingId + ".json")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, trainingId, reply](){
		reply->deleteLater();
		Training* training = new Training(this, trainingId);

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		for (const auto &key : rootObject.keys()) {
			if (key == "exercises") {
				auto exerciseListDocument = rootObject.value(key);
				auto exerciseListObject = exerciseListDocument.toObject();

				for (const auto &exerciseListKey : exerciseListObject.keys()) {
					Exercise* exerciseToAdd = new Exercise(this, exerciseListKey);

					auto exerciseDocument = exerciseListObject.value(exerciseListKey);
					auto exerciseObject = exerciseDocument.toObject();

					for (const auto &exerciseKey : exerciseObject.keys()) {
						if (exerciseKey.toUInt()) {
							auto bitArray = stringToBitArray(rootObject.value(exerciseKey).toString());

							bool isMax = getIsMaxFromBitArray(bitArray);

							if (isMax)
								bitArray.clearBit(bitArray.count() - 1);

							auto repeats =  bitArray.toUInt32(QSysInfo::LittleEndian);

							exerciseToAdd->addSet(exerciseKey.toUInt(), repeats, isMax);
							continue;
						}

						if (exerciseKey == "breakTime") {
							exerciseToAdd->setRestTime(rootObject.value(exerciseKey).toInt());
							continue;
						}

						if (exerciseKey == "name")
							exerciseToAdd->setName(rootObject.value(exerciseKey).toString());

					}

					training->addExercise(exerciseToAdd);
				}
				continue;
			}

			if (key == "name") {
				training->setName(rootObject.value(key).toString());
				continue;
			}

			if (key == "owner") {
				training->setOwner(rootObject.value(key).toString());
				continue;
			}

			if (key == "planId")
				training->setPlanId(rootObject.value(key).toString());
		}

		emit trainingReceived(training);
	});
}

void
DatabaseHandler::getTrainingExercises(QString trainingId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "trainings/" + trainingId + "/exercises.json")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, reply](){
		reply->deleteLater();
		QList<Exercise*> exercises;

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		for (const auto &key : rootObject.keys()) {
			Exercise* exerciseToAdd = new Exercise(this, key);

			auto exerciseDocument = rootObject.value(key);
			auto exerciseObject = exerciseDocument.toObject();

			for (const auto &key : exerciseObject.keys()) {
				if (key.toUInt()) {
					auto bitArray = stringToBitArray(exerciseObject.value(key).toString());

					bool isMax = getIsMaxFromBitArray(bitArray);

					if (isMax)
						bitArray.clearBit(bitArray.count() - 1);

					auto repeats =  bitArray.toUInt32(QSysInfo::LittleEndian);

					exerciseToAdd->addSet(key.toUInt(), repeats, isMax);
					continue;
				}

				if (key == "breakTime") {
					exerciseToAdd->setRestTime(exerciseObject.value(key).toInt());
					continue;
				}

				if (key == "name")
					exerciseToAdd->setName(exerciseObject.value(key).toString());
			}

			exercises.push_back(exerciseToAdd);
			//exerciseToAdd->deleteLater();
		}

		emit this->trainingExercisesReceived(exercises);
	});
}

void
DatabaseHandler::getExercise(QString trainingId, QString exerciseId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "trainings/" + trainingId + "/exercises/" + exerciseId + ".json")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, exerciseId, reply](){
		reply->deleteLater();
		Exercise* newExercise = new Exercise(this, exerciseId);

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		for (const auto &key : rootObject.keys()) {
			if (key.toUInt()) {
				auto bitArray = stringToBitArray(rootObject.value(key).toString());

				bool isMax = getIsMaxFromBitArray(bitArray);
				auto repeats = getRepeatsFromBitArray(bitArray);

				newExercise->addSet(key.toUInt(), repeats, isMax);
				continue;
			}

			if (key == "breakTime") {
				newExercise->setRestTime(rootObject.value(key).toInt());
				continue;
			}

			if (key == "name")
				newExercise->setName(rootObject.value(key).toString());
		}

		emit this->exerciseReceived(newExercise);
		//newExercise->deleteLater();
	});
}

void
DatabaseHandler::addUser(QString username, QString email, QString password)
{
	QVariantMap newUser;
	newUser["email"] = email;
	newUser["password"] = password;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(newUser);
	QNetworkRequest request(QUrl(m_url + "users/" + username + ".json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	m_networkManager->put(request, jsonDoc.toJson());
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
					 this, [this, reply](){
		reply->deleteLater();
		emit trainingPlanAdded();
	});
}

void
DatabaseHandler::addTraining(QString username, QString planId, QString name, QDateTime date)
{
	QVariantMap newTraining;
	newTraining["owner"] = username;
	newTraining["planId"] = planId;
	newTraining["name"] = name;

	if (!date.isNull())
		newTraining["date"] = date.toSecsSinceEpoch();

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(newTraining);

	QNetworkRequest request(QUrl(m_url + "trainings.json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	m_networkManager->post(request, jsonDoc.toJson());
}

void
DatabaseHandler::addExercise(QString trainingId, QString name, int breakTime, QList<QString> sets)
{
	QVariantMap newExercise;
	newExercise["name"] = name;
	newExercise["breakTime"] = breakTime;

	for (int i = 0; i < sets.size(); i++) {
		newExercise[QString::number(i + 1)] = sets[i];
	}

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(newExercise);

	QNetworkRequest request(QUrl(m_url + "trainings/" + trainingId + "/exercises.json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	m_networkManager->post(request, jsonDoc.toJson());
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
DatabaseHandler::editExercise(QString trainingId, Exercise* exercise)
{
	QVariantMap newExercise;
	newExercise["name"] = exercise->name();
	newExercise["breakTime"] = exercise->restTime();

	for (auto set : exercise->sets()) {
		newExercise[QString::number(set.index) = setToString(set.repeats, set.isMax)];
	}

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(newExercise);

	QNetworkRequest request(QUrl(m_url + "trainings/" + trainingId + "/exercises/" + exercise->id() + ".json"));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->put(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [reply](){
		reply->deleteLater();

		qDebug() << "DATABASE RESPONDED";
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

QBitArray
DatabaseHandler::stringToBitArray(QString bitString)
{
	QBitArray result(bitString.size());

	for (int i = bitString.size() - 1; i >= 0; i--) {
		if (bitString[i] == '1')
			result[bitString.size() - 1 - i] = 1;
	}

	return result;
}

QString
DatabaseHandler::setToString(int repeats, bool isMax)
{
	QString result = "";

	result += (isMax ? "1" : "0");

	QString stringRepeats = (QString::number(repeats, 2));

	for (int i = 0; i < 5 - stringRepeats.length(); i++) {
		result += "0";
	}

	result += stringRepeats;

	return result;
}

bool
DatabaseHandler::getIsMaxFromBitArray(QBitArray bitArray)
{
	if (bitArray.isEmpty())
		return false;

	return bitArray[bitArray.count() - 1];
}

int
DatabaseHandler::getRepeatsFromBitArray(QBitArray bitArray)
{
	if (bitArray.isEmpty())
		return -1;

	if (getIsMaxFromBitArray(bitArray))
		bitArray.clearBit(bitArray.count() - 1);

	return bitArray.toUInt32(QSysInfo::LittleEndian);
}

