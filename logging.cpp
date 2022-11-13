#include "logging.h"

#include <QGuiApplication>
#include <QDateTime>

#ifdef Q_OS_ANDROID
	#include <android/log.h>
#endif

Q_LOGGING_CATEGORY(PG_LOG, "PG_LOG")

#define COLOR_DEBUG true

void myMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg) {
#ifdef Q_OS_ANDROID
	android_LogPriority priority = ANDROID_LOG_DEBUG;
	switch (type) {
		case QtDebugMsg: priority = ANDROID_LOG_DEBUG; break;
		case QtInfoMsg: priority = ANDROID_LOG_INFO; break;
		case QtWarningMsg: priority = ANDROID_LOG_WARN; break;
		case QtCriticalMsg: priority = ANDROID_LOG_ERROR; break;
		case QtFatalMsg: priority = ANDROID_LOG_FATAL; break;
	}
#endif

	QString typeString;
#if defined(COLOR_DEBUG)
	switch (type) {
		case QtDebugMsg:
			typeString = QStringLiteral("\033[1;32mDebug\033[0m");
			break;
		case QtInfoMsg:
			typeString = QStringLiteral("\033[36mInfo\033[0m");
			break;
		case QtWarningMsg:
			typeString = QStringLiteral("\033[1;31mWarning\033[0m");
			break;
		case QtCriticalMsg:
			typeString = QStringLiteral("\033[1;37;41mCritical\033[0m");
			break;
		case QtFatalMsg:
			typeString = QStringLiteral("\033[1;37;41mFatal\033[0m");
			break;
	}

	QString message = QStringLiteral("\033[33m%6\033[0m \033[36m[%7]\033[0m %1\033[37m: %2\033[0m \033[37m(\033[36m%3:%4\033[37m, \033[35m%5\033[37m)\n").

#endif

	arg(typeString,
		msg,
		QLatin1String("file:/") +
		(strcmp(context.category, "DEVCONN_LOG") == 0 ?
			  "devconnector/"
			: "") + context.file,
		QString::number(context.line),
		(type == QtInfoMsg ?
			 "-" :
			 context.function),
		(type == QtInfoMsg ?
			 QLatin1String("") :
			 QDateTime::currentDateTime().toString(QStringLiteral("yyyy-MM-dd hh:mm:ss:zzz t"))),
		context.category
		);

#ifdef Q_OS_ANDROID
	__android_log_print(priority,
						qPrintable(QCoreApplication::applicationName()),
						"%s",
						qPrintable(message));
#endif
}
