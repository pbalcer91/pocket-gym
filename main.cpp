#include <QApplication>
#include <QQmlApplicationEngine>

#include "maincontroller.h"
#include "exercise.h"
#include "training.h"
#include "trainingplan.h"
#include "user.h"
#include "usertrainingsmanager.h"


int main(int argc, char *argv[])
{
	QApplication app(argc, argv);

	//qml registrations
	qmlRegisterSingletonType<MainController>("pl.com.thesis", 1, 0,
											 "MainController",
											 [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
		Q_UNUSED(engine)
		Q_UNUSED(scriptEngine)

		return (MainController::instance());
	});

	qmlRegisterType<Exercise>("pl.com.thesis", 1, 0, "Exercise");
	qmlRegisterType<Training>("pl.com.thesis", 1, 0, "Training");
	qmlRegisterType<TrainingPlan>("pl.com.thesis", 1, 0, "TrainingPlan");
	qmlRegisterType<User>("pl.com.thesis", 1, 0, "User");
	qmlRegisterType<UserTrainingsManager>("pl.com.thesis", 1, 0, "UserTrainingsManager");

	QQmlApplicationEngine engine;
	engine.addImportPath("qrc:///qml");

	QObject::connect(&engine, &QQmlEngine::quit,
					 &app, &QGuiApplication::quit, Qt::QueuedConnection);

	engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

	if (engine.rootObjects().isEmpty())
		return (-1);

	return (QGuiApplication::exec());
}
