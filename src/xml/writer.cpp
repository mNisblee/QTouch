/**
 * \file writer.cpp
 *
 * \date 09.07.2015
 * \author Moritz Nisblé moritz.nisble@gmx.de
 */

#include "writer.hpp"

#include <QFile>
#include <QXmlStreamWriter>
#include <QDomDocument>
#include <QDomElement>

#include <QDebug>

namespace qtouch
{
namespace xml
{

void writeCourse(const CoursePtr& course, const QString& file_path) throw (FileException, XmlException)
{
	QFile output(file_path);
	if (!output.open(QIODevice::WriteOnly))
	{
		throw FileException("Cannot open file for writing", output.fileName());
	}

	QXmlStreamWriter writer(&output);
	writer.setAutoFormatting(true);
	writer.setAutoFormattingIndent(1);

	writer.writeStartDocument();

	writer.writeStartElement("course");

	writer.writeStartElement("id");
	writer.writeCharacters(course->getId().toString());
	writer.writeEndElement();

	writer.writeStartElement("title");
	writer.writeCharacters(course->getTitle());
	writer.writeEndElement();

	writer.writeStartElement("description");
	writer.writeCharacters(course->getDescription());
	writer.writeEndElement();

	writer.writeStartElement("keyboardLayout");
	// TODO: Add keyboardLayout
	writer.writeEndElement();

	writer.writeStartElement("lessons");
	for (Course::const_iterator it = course->begin(); it != course->end(); ++it)
	{
		writer.writeStartElement("lesson");

		writer.writeStartElement("id");
		writer.writeCharacters((*it)->getId().toString());
		writer.writeEndElement();

		writer.writeStartElement("title");
		writer.writeCharacters((*it)->getTitle());
		writer.writeEndElement();

		writer.writeStartElement("newCharacters");
		writer.writeCharacters((*it)->getNewChars());
		writer.writeEndElement();

		writer.writeStartElement("text");
		writer.writeCharacters((*it)->getText());
		writer.writeEndElement();

		writer.writeEndElement(); // </lesson>
	}
	writer.writeEndElement(); // </lessons>

	writer.writeEndElement(); // </course>

	writer.writeEndDocument();
}

} /* namespace xml */
} /* namespace qtouch */
