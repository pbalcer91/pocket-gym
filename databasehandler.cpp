#include "databasehandler.h"

#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QVariantMap>
#include <QDebug>

DatabaseHandler::DatabaseHandler(QObject *parent)
	: QObject{parent},
	  m_networkManager(new QNetworkAccessManager(this)),
	  m_url("https://pocket-gym-b561a-default-rtdb.europe-west1.firebasedatabase.app/"),
	  m_apiKey("AIzaSyAa6IKwcf3b-HOIL9f1DYbZZDLROOl13Ds")
{}

DatabaseHandler::~DatabaseHandler()
{
	m_networkManager->deleteLater();
}

void
DatabaseHandler::signUserUp(const QString &email, const QString &password)
{
	QString signUpEndPoint = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + m_apiKey;

	QVariantMap variantPayload;
	variantPayload["email"] = email;
	variantPayload["password"] = password;
	variantPayload["returnSecureToken"] = true;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(variantPayload);

	QNetworkRequest request((QUrl(signUpEndPoint)));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->post(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		for (const auto &key : rootObject.keys()) {
			if (key == "error") {
				auto errorDocument = rootObject.value(key);
				auto errorObject = errorDocument.toObject();

				QString errorMessage = errorObject.value("message").toString();

				if (errorMessage == "EMAIL_EXISTS") {
					emit signUpFailed(SU_EMAIL_EXISTS);
					return;
				}

				if (errorMessage == "TOO_MANY_ATTEMPTS_TRY_LATER") {
					emit signUpFailed(SU_TOO_MANY_ATTEMPTS_TRY_LATER);
					return;
				}

				emit signUpFailed(SU_UNKNOWN_ERROR);
				return;
			}
		}

		m_idToken = rootObject.value("idToken").toString();

		emit signUpSucceed();
	});

}

void
DatabaseHandler::signUserIn(const QString &email, const QString &password)
{
	QString signInEndPoint = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + m_apiKey;

	QVariantMap variantPayload;
	variantPayload["email"] = email;
	variantPayload["password"] = password;
	variantPayload["returnSecureToken"] = true;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(variantPayload);

	QNetworkRequest request((QUrl(signInEndPoint)));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->post(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, email, password, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		for (const auto &key : rootObject.keys()) {
			if (key == "error") {
				auto errorDocument = rootObject.value(key);
				auto errorObject = errorDocument.toObject();

				QString errorMessage = errorObject.value("message").toString();

				if (errorMessage == "EMAIL_NOT_FOUND") {
					emit signInFailed(SI_EMAIL_NOT_FOUND);
					return;
				}

				if (errorMessage == "USER_DISABLED") {
					emit signInFailed(SI_USER_DISABLED);
					return;
				}

				if (errorMessage == "INVALID_PASSWORD") {
					emit signInFailed(SI_INVALID_PASSWORD);
					return;
				}

				emit signInFailed(SI_UNKNOWN_ERROR);
				return;
			}
		}

		m_idToken = rootObject.value("idToken").toString();

		emit signInSucceed(email.toLower(), password);
	});
}

void
DatabaseHandler::checkIsUsernameAvailable(QString username)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "users.json?auth=" + m_idToken)));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, username, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		for (const auto &key : rootObject.keys()) {
			auto userDocument = rootObject.value(key);
			auto userObject = userDocument.toObject();

			if (userObject.value("username").toString() == username) {
				emit usernameVerificationReceived(false);
				return;
			}
		}

		emit usernameVerificationReceived(true);
	});
}

void
DatabaseHandler::changeUsername(QString userId, QString email, QString username, bool isTrainer)
{
	QVariantMap userDatabase;
	userDatabase["email"] = email.toLower();
	userDatabase["username"] = username;
	userDatabase["isTrainer"] = isTrainer;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(userDatabase);

	QNetworkRequest request(QUrl(m_url + "users/" + userId + ".json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->put(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, reply](){
		reply->deleteLater();

		emit usernameChanged();
	});
}

void
DatabaseHandler::getUserByEmail(QString email)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "users.json?auth=" + m_idToken + "&orderBy=\"email\"&equalTo=\"" + email.toLower() + "\"")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		for (const auto &key : rootObject.keys()) {
			auto userDocument = rootObject.value(key);
			auto userObject = userDocument.toObject();

			QString id = key;
			QString username = userObject.value("username").toString();
			QString email = userObject.value("email").toString();
			bool isTrainer = userObject.value("isTrainer").toBool();

			emit userLoggedIn(id, username, email.toLower(), isTrainer);

			return;
		}
	});
}

void
DatabaseHandler::getTrainerById(QString trainerId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "users.json?auth=" + m_idToken + "&orderBy=\"isTrainer\"&equalTo=true")));

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
					QUrl(m_url + "users.json?auth=" + m_idToken + "&orderBy=\"isTrainer\"&equalTo=true")));

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
					QUrl(m_url + "users.json?auth=" + m_idToken + "&orderBy=\"isTrainer\"&equalTo=true")));

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
DatabaseHandler::getTrainerPupilsIds(QString trainerId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "users/" + trainerId + ".json?auth=" + m_idToken)));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		auto pupilListDocument = rootObject.value("pupils");
		auto pupilListObject = pupilListDocument.toObject();

		QList<QString> pupilsIdsList;

		for (const auto &key : pupilListObject.keys()) {
			pupilsIdsList.push_back(key);
		}

		emit trainerPupilsIdsReceived(pupilsIdsList);
	});
}

void
DatabaseHandler::getPupilById(QString trainerId, QString pupilId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "users/" + pupilId + ".json?auth=" + m_idToken)));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, trainerId, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QString username = rootObject.value("username").toString();

		auto trainerDocument = rootObject.value("trainer");
		auto trainerObject = trainerDocument.toObject();

		bool isConfirmed = trainerObject.value(trainerId).toBool();

		emit pupilReceived(username, isConfirmed);
	});
}

void
DatabaseHandler::getUserTrainingPlans(User* user)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "trainingPlans.json?auth=" + m_idToken + "&orderBy=\"ownerId\"&equalTo=\"" + user->id() + "\"")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QList<TrainingPlan*> planList;

		for (const auto &key : rootObject.keys()) {
			auto planDocument = rootObject.value(key);
			auto planObject = planDocument.toObject();

			QString id = key;
			QString ownerId = planObject.value("ownerId").toString();

			TrainingPlan* plan = new TrainingPlan(this, ownerId, id);

			plan->setName(planObject.value("name").toString());
			plan->setDescription(planObject.value("description").toString());
			plan->setIsDefault(planObject.value("isDefault").toBool());

			planList.push_back(plan);
		}

		emit trainingPlansReceived(user, planList);
	});
}

void
DatabaseHandler::getTrainingPlanById(User* user, QString id)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "trainingPlans/" + id + ".json?auth=" + m_idToken)));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, id, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QString name = rootObject.value("name").toString();
		QString description = rootObject.value("description").toString();
		bool isDefault = rootObject.value("isDefault").toBool();

		emit trainingPlanReceived(user, id, name, description, isDefault);
	});
}

void
DatabaseHandler::getTrainingsByPlanId(User* user, QString planId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "trainings.json?auth=" + m_idToken + "&orderBy=\"planId\"&equalTo=\"" + planId + "\"")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, planId, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QList<Training*> trainingList;

		for (const auto &key : rootObject.keys()) {
			auto trainingDocument = rootObject.value(key);
			auto trainingObject = trainingDocument.toObject();

			QString id = key;
			QString ownerId = trainingObject.value("ownerId").toString();
			QString name = trainingObject.value("name").toString();
			QString planId = trainingObject.value("planId").toString();

			Training* training = new Training(this, id, ownerId, name, planId);

			trainingList.push_back(training);
		}

		emit trainingsReceived(user, planId, trainingList);
	});
}

void
DatabaseHandler::getTrainingById(User* user, QString trainingId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "trainings/" + trainingId + ".json?auth=" + m_idToken)));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, trainingId, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QString name = rootObject.value("name").toString();
		QString planId = rootObject.value("planId").toString();

		emit trainingReceived(trainingId, user, name, planId);
	});
}

void
DatabaseHandler::getExercisesByTrainingId(User* user, QString planId, QString trainingId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "exercises.json?auth=" + m_idToken + "&orderBy=\"trainingId\"&equalTo=\"" + trainingId + "\"")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, planId, trainingId, reply](){
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

		emit exercisesReceived(user, planId, trainingId, exerciseList);
	});
}

void
DatabaseHandler::getExerciseById(User* user, QString planId, QString exerciseId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "exercises/" + exerciseId + ".json?auth=" + m_idToken)));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, planId, exerciseId, reply](){
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

		emit exerciseReceived(user, planId, exerciseId, name, breakTime, trainingId, setList);
	});
}

void
DatabaseHandler::getMeasurementsByUser(User* user)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "measurements.json?auth=" + m_idToken + "&orderBy=\"userId\"&equalTo=\"" + user->id() + "\"")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, reply](){
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
			measurement->setDate(dateTime);

			measurementList.push_back(measurement);
		}

		emit measurementsReceived(user, measurementList);
	});
}

void
DatabaseHandler::addUser(QString email, bool isTrainer)
{
	QVariantMap databaseUser;
	databaseUser["email"] = email.toLower();
	databaseUser["isTrainer"] = isTrainer;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databaseUser);
	QNetworkRequest request(QUrl(m_url + "users.json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->post(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, email, reply](){
		reply->deleteLater();
		emit userAdded(email.toLower());
	});
}

void
DatabaseHandler::addTrainingPlan(User* user, QString name, QString description, bool isDefault)
{
	QVariantMap databasePlan;
	databasePlan["name"] = name;
	databasePlan["description"] = description;
	databasePlan["isDefault"] = isDefault;
	databasePlan["ownerId"] = user->id();

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databasePlan);
	QNetworkRequest request(QUrl(m_url + "trainingPlans.json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->post(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, reply](){
		reply->deleteLater();
		emit trainingPlanAdded(user);
	});
}

void
DatabaseHandler::addTraining(User* user, QString name, QString planId)
{
	QVariantMap databaseTraining;
	databaseTraining["ownerId"] = user->id();
	databaseTraining["name"] = name;
	databaseTraining["planId"] = planId;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databaseTraining);

	QNetworkRequest request(QUrl(m_url + "trainings.json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->post(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, planId, reply](){
		reply->deleteLater();
		emit trainingAdded(user, planId);
	});
}

void
DatabaseHandler::addExercise(User* user, QString planId, QString trainingId, QString name, int breakTime, QList<QString> sets)
{
	QVariantMap databaseExercise;
	databaseExercise["name"] = name;
	databaseExercise["breakTime"] = breakTime;
	databaseExercise["trainingId"] = trainingId;

	for (int i = 0; i < sets.size(); i++) {
		databaseExercise[QString::number(i + 1)] = sets[i];
	}

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databaseExercise);

	QNetworkRequest request(QUrl(m_url + "exercises.json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->post(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, planId, trainingId, reply](){
		reply->deleteLater();
		emit exerciseAdded(user, planId, trainingId);
	});
}

void
DatabaseHandler::addMeasurement(User* user, double weight, double chest, double shoulders, double arm,
								double forearm, double waist, double hips, double peace, double calf)
{
	QVariantMap databaseMeasurement;
	databaseMeasurement["userId"] = user->id();
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

	QNetworkRequest request(QUrl(m_url + "measurements.json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->post(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, reply](){
		reply->deleteLater();
		emit measurementAdded(user);
	});
}

void
DatabaseHandler::addCompletedTraining(User *user, QString trainingName)
{
	QVariantMap databaseTraining;
	databaseTraining["userId"] = user->id();
	databaseTraining["timestamp"] = QDateTime::currentSecsSinceEpoch();
	databaseTraining["name"] = trainingName;
	databaseTraining["completed"] = false;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databaseTraining);

	QNetworkRequest request(QUrl(m_url + "completedTrainings.json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->post(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, reply](){
		reply->deleteLater();
		emit completedTrainingAdded(user);
	});
}

void
DatabaseHandler::getUserCompletedTrainings(User *user)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "completedTrainings.json?auth=" + m_idToken + "&orderBy=\"userId\"&equalTo=\"" + user->id() + "\"")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QList<Training*> trainingsList;

		for (const auto &key : rootObject.keys()) {
			auto trainingDocument = rootObject.value(key);
			auto trainingObject = trainingDocument.toObject();

			if (!trainingObject.value("completed").toBool())
				continue;

			long long timestamp = trainingObject.value("timestamp").toInteger();
			QDateTime dateTime;
			dateTime.setSecsSinceEpoch(timestamp);
			QString name = trainingObject.value("name").toString();

			Training* trainingToAdd = new Training();
			trainingToAdd->setId(key);
			trainingToAdd->setName(name);
			trainingToAdd->setDate(dateTime);


			trainingsList.push_back(trainingToAdd);
		}

		emit completedTrainingsReceived(trainingsList);
	});
}

void
DatabaseHandler::getUserCompletedExercises(QString trainingId)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "completedTrainings/" + trainingId + ".json?auth=" + m_idToken)));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		QList<Exercise*> exercisesList;

		for (const auto &key : rootObject.keys()) {
			if (key == "userId" || key == "name" || key == "timestamp" || key == "completed")
				continue;

			auto exercisetDocument = rootObject.value(key);
			auto exerciseObject = exercisetDocument.toObject();

			QString name = exerciseObject.value("name").toString();
			QList<QString> setsList;

			for (const auto &exerciseKey : exerciseObject.keys()) {
				if (exerciseKey.toUInt()) {
					auto set = exerciseObject.value(exerciseKey).toString();
					setsList.push_back(set);
				}
			}

			Exercise* exerciseToAdd = new Exercise();
			exerciseToAdd->setName(name);
			exerciseToAdd->replaceCompletedSetsList(setsList);

			exercisesList.push_back(exerciseToAdd);
		}

		emit completedExercisesReceived(exercisesList);
	});
}

void
DatabaseHandler::getUserUncompletedTrainings(User* user)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "completedTrainings.json?auth=" + m_idToken + "&orderBy=\"userId\"&equalTo=\"" + user->id() + "\"")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		for (const auto &key : rootObject.keys()) {
			auto trainingDocument = rootObject.value(key);
			auto trainingObject = trainingDocument.toObject();

			if (trainingObject.value("completed").toBool())
				continue;

			emit uncompletedTrainingIdReceived(key);
		}
	});
}

void
DatabaseHandler::deleteCompletedTraining(User *user)
{
	auto reply = m_networkManager->get(
				QNetworkRequest(
					QUrl(m_url + "completedTrainings.json?auth=" + m_idToken + "&orderBy=\"userId\"&equalTo=\"" + user->id() + "\"")));

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, reply](){
		reply->deleteLater();

		auto rootDocument = QJsonDocument::fromJson(reply->readAll());
		auto rootObject = rootDocument.object();

		for (const auto &key : rootObject.keys()) {
			if (rootObject.value("completed").toBool())
				continue;

			QNetworkRequest request(QUrl(m_url + "completedTrainings/" + key + ".json?auth=" + m_idToken));
			request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

			m_networkManager->deleteResource(request);
		}
	});
}

void
DatabaseHandler::addCompletedExercise(QString trainingId, QString name, QList<QString> sets)
{
	QVariantMap databaseExercise;
	databaseExercise["name"] = name;
	for (int i = 0; i < sets.size(); i++) {
		databaseExercise[QString::number(i + 1)] = sets[i];
	}

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databaseExercise);

	QNetworkRequest request(QUrl(m_url + "completedTrainings/" + trainingId + ".json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	m_networkManager->post(request, jsonDoc.toJson());
}

void
DatabaseHandler::completeTraining(QString trainingId)
{
	QByteArray someData = "true";

	QNetworkRequest request(QUrl(m_url + "completedTrainings/" + trainingId + "/completed.json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->put(request, someData);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, reply](){
		reply->deleteLater();

		emit trainingCompleted();
	});
}

void
DatabaseHandler::editTrainingPlan(QString planId, User* user, QString name, QString description, bool isDefault)
{
	QVariantMap databasePlan;
	databasePlan["name"] = name;
	databasePlan["description"] = description;
	databasePlan["isDefault"] = isDefault;
	databasePlan["ownerId"] = user->id();

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databasePlan);

	QNetworkRequest request(QUrl(m_url + "trainingPlans/" + planId + ".json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->put(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, planId, reply](){
		reply->deleteLater();
		emit trainingPlanChanged(user, planId);
	});
}

void
DatabaseHandler::editTraining(QString trainingId, User* user, QString name, QString planId)
{
	QVariantMap databaseTraining;
	databaseTraining["ownerId"] = user->id();
	databaseTraining["name"] = name;
	databaseTraining["planId"] = planId;

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databaseTraining);

	QNetworkRequest request(QUrl(m_url + "trainings/" + trainingId + ".json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->put(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, trainingId, reply](){
		reply->deleteLater();
		emit trainingChanged(user, trainingId);
	});
}

void
DatabaseHandler::editExercise(User* user, QString planId, QString exerciseId, QString trainingId, QString name, int breakTime, QList<QString> sets)
{
	QVariantMap databaseExercise;
	databaseExercise["name"] = name;
	databaseExercise["breakTime"] = breakTime;
	databaseExercise["trainingId"] = trainingId;

	for (int i = 0; i < sets.size(); i++) {
		databaseExercise[QString::number(i + 1)] = sets[i];
	}

	QJsonDocument jsonDoc = QJsonDocument::fromVariant(databaseExercise);

	QNetworkRequest request(QUrl(m_url + "exercises/" + exerciseId + ".json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->put(request, jsonDoc.toJson());

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, planId, exerciseId, reply](){
		reply->deleteLater();
		emit exerciseChanged(user, planId, exerciseId);
	});
}

void
DatabaseHandler::deleteTrainingPlan(User* user, QString planId)
{
	QNetworkRequest request(QUrl(m_url + "trainingPlans/" + planId + ".json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->deleteResource(request);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user,  planId, reply](){
		reply->deleteLater();

		emit trainingPlanRemoved(user, planId);
	});
}

void
DatabaseHandler::deleteTraining(User* user, QString planId, QString trainingId)
{
	QNetworkRequest request(QUrl(m_url + "trainings/" + trainingId + ".json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->deleteResource(request);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user,  planId, trainingId, reply](){
		reply->deleteLater();

		emit trainingRemoved(user, planId, trainingId);
	});
}

void
DatabaseHandler::deleteExercise(User* user, QString planId, QString trainingId, QString exerciseId)
{
	QNetworkRequest request(QUrl(m_url + "exercises/" + exerciseId + ".json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->deleteResource(request);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, user, planId, trainingId, exerciseId, reply](){
		reply->deleteLater();

		emit exerciseRemoved(user, planId, trainingId, exerciseId);
	});
}

void
DatabaseHandler::addRequestForTrainer(QString userId, QString trainerId)
{
	QByteArray someData = "false";

	QNetworkRequest request(QUrl(m_url + "users/" + trainerId + "/pupils/" + userId +".json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->put(request, someData);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, userId, trainerId, reply](){
		reply->deleteLater();

		addTrainerToUser(userId, trainerId);
	});
}

void
DatabaseHandler::acceptPupilRequest(QString trainerId, QString pupilId)
{
	QByteArray someData = "true";

	QNetworkRequest request(QUrl(m_url + "users/" + trainerId + "/pupils/" + pupilId +".json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->put(request, someData);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, trainerId, pupilId, reply](){
		reply->deleteLater();

		acceptTrainer(trainerId, pupilId);
	});
}

void
DatabaseHandler::acceptTrainer(QString trainerId, QString pupilId)
{
	QByteArray someData = "true";

	QNetworkRequest request(QUrl(m_url + "users/" + pupilId + "/trainer/" + trainerId +".json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->put(request, someData);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, trainerId, reply](){
		reply->deleteLater();

		emit pupilRequestAccepted(trainerId);
	});
}

void
DatabaseHandler::deleteRequestForTrainer(QString userId, QString trainerId)
{
	QNetworkRequest request(QUrl(m_url + "users/" + trainerId + "/pupils/" + userId + ".json?auth=" + m_idToken));
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

	QNetworkRequest request(QUrl(m_url + "users/" + userId + "/trainer.json?auth=" + m_idToken));
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
	QNetworkRequest request(QUrl(m_url + "users/" + userId + "/trainer.json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->deleteResource(request);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, reply](){
		reply->deleteLater();

		emit trainerRequestRemoved();
	});
}

void
DatabaseHandler::deletePupilFromUser(User* trainer, QString pupilId)
{
	QNetworkRequest request(QUrl(m_url + "users/" + trainer->id() + "/pupils/" + pupilId + ".json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->deleteResource(request);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, trainer, pupilId, reply](){
		reply->deleteLater();

		deleteTrainerFromPupil(trainer->id(), pupilId);
	});
}

void
DatabaseHandler::deleteTrainerFromPupil(QString trainerId, QString pupilId)
{
	QNetworkRequest request(QUrl(m_url + "users/" + pupilId + "/trainer.json?auth=" + m_idToken));
	request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));

	auto reply = m_networkManager->deleteResource(request);

	QObject::connect(reply, &QNetworkReply::finished,
					 this, [this, trainerId, reply](){
		reply->deleteLater();

		emit pupilRemoved(trainerId);
	});
}
