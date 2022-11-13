#ifndef LOGGING_H
#define LOGGING_H

#include <QtDebug>
#include <QLoggingCategory>

Q_DECLARE_LOGGING_CATEGORY(PG_LOG)

void myMessageOutput(QtMsgType type, const QMessageLogContext &context,
					 const QString &msg);

#endif // LOGGING_H
