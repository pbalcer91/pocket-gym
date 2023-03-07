#ifndef MESSAGE_H
#define MESSAGE_H

#include <QObject>

class Message : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString id READ id CONSTANT)
	Q_PROPERTY(QString sender READ sender CONSTANT)
	Q_PROPERTY(QString receiver READ receiver CONSTANT)
	Q_PROPERTY(QString signature READ signature CONSTANT)
	Q_PROPERTY(QString message READ message CONSTANT)

public:
	explicit Message(QObject *parent = nullptr);
	explicit Message(QObject *parent,
					 QString id,
					 QString sender,
					 QString receiver,
					 QString signature,
					 QString message);

	~Message();

	QString id() const;
	QString sender() const;
	QString receiver() const;
	QString signature() const;
	QString message() const;

private:
	QString m_id;
	QString m_sender;
	QString m_receiver;
	QString m_signature;
	QString m_message;

};

#endif // MESSAGE_H
