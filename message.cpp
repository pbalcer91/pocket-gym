#include "message.h"

Message::Message(QObject *parent)
	: QObject{parent}
{}

Message::Message(QObject *parent,
				 QString id,
				 QString sender,
				 QString receiver,
				 QString signature,
				 QString message)
	: QObject{parent},
	  m_id(id),
	  m_sender(sender),
	  m_receiver(receiver),
	  m_signature(signature),
	  m_message(message)
{}

Message::~Message()
{}

QString
Message::id() const
{
	return m_id;
}

QString
Message::sender() const
{
	return m_sender;
}

QString
Message::receiver() const
{
	return m_receiver;
}

QString
Message::signature() const
{
	return m_signature;
}

QString
Message::message() const
{
	return m_message;
}
