#include <QGuiApplication>
#include <QQmlApplicationEngine>


int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);

	QQmlApplicationEngine engine;
	engine.addImportPath("qrc:///qml");

	QObject::connect(&engine, &QQmlEngine::quit,
					 &app, &QGuiApplication::quit, Qt::QueuedConnection);

	engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

	if (engine.rootObjects().isEmpty())
		return (-1);

	return (QGuiApplication::exec());
}
