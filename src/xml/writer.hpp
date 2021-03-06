/* Copyright (C) 2015  Moritz Nisblé <moritz.nisble@gmx.de>
 *
 * This file is part of QTouch.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

/**
 * \file writer.hpp
 *
 * \date 09.07.2015
 * \author Moritz Nisblé moritz.nisble@gmx.de
 */

#ifndef WRITER_HPP_
#define WRITER_HPP_

#include <QtContainerFwd>

#include "entities/course.hpp"
#include "utils/exceptions.hpp"

namespace qtouch
{
namespace xml
{

void writeCourse(const Course& course, const QString& file_path);

} /* namespace xml */
} /* namespace qtouch */

#endif /* WRITER_HPP_ */
