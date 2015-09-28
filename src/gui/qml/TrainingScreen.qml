/* Copyright (C) 2015  Moritz Nisblé <moritz.nisble@gmx.de>
**
** This file is part of QTouch.
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License along
** with this program; if not, write to the Free Software Foundation, Inc.,
** 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
**/
import QtQuick 2.3
import QtQuick.Controls 1.3
import QtGraphicalEffects 1.0

import de.nisble.qtouch 1.0
import "items" as Items

FocusScope {
    id: root

    // Configuration properties
    property int horizontalSheetMargin: 60
    property int verticalSheetMargin: 60

    // Input property interface
    // Lesson title
    property alias title: trainingWidget.title
    // Lesson text
    property alias text: trainingWidget.text

    signal quit

    function reset() {
        trainingWidget.reset()
    }

    Column {
        id: columnLayout

        anchors.fill: root

        Item {
            id: statsContainer

            property int tbMargins: 8
            property int lrMargins: 8
            property int spacing: 10

            anchors {
                left: columnLayout.left
                right: columnLayout.right
            }
            height: 120

            Items.ElapsedTimeWidget {
                id: elapsedTime
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    topMargin: statsContainer.tbMargins
                    bottomMargin: statsContainer.tbMargins
                    leftMargin: statsContainer.lrMargins
                }
                width: (parent.width - 2 * statsContainer.lrMargins - 2
                        * statsContainer.spacing) / 3
                // TODO
                currentMillis: 10000
            }

            Items.RateWidget {
                id: strokeRate
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: elapsedTime.right
                    right: hitRate.left
                    topMargin: statsContainer.tbMargins
                    bottomMargin: statsContainer.tbMargins
                    leftMargin: statsContainer.spacing
                    rightMargin: statsContainer.spacing
                }
                min: 0
                max: 240
                target: 180
                //                current: target / 60 * timer.secs
                current: target / 60
                previous: 230
                heading: qsTr("Strokes per minute")
            }

            Items.RateWidget {
                id: hitRate
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                    topMargin: statsContainer.tbMargins
                    bottomMargin: statsContainer.tbMargins
                    rightMargin: statsContainer.lrMargins
                }
                width: (parent.width - 2 * statsContainer.lrMargins - 2
                        * statsContainer.spacing) / 3
                min: 0
                max: 100
                target: 96
                //                current: target / 60 * timer.secs
                current: target / 60
                previous: 94
                heading: qsTr("Hits rate")
                postifx: "%"
            }
        }

        ProgressBar {
            id: progressIndicator
            anchors {
                left: columnLayout.left
                right: columnLayout.right
            }
            value: trainingWidget.progress
        }

        Item {
            id: widgetContainer

            anchors {
                left: columnLayout.left
                right: columnLayout.right
            }
            height: root.height - progressIndicator.height - statsContainer.height

            ScrollView {
                id: widgetScroller

                anchors.fill: parent

                verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

                focus: true
                clip: true

                flickableItem.boundsBehavior: Flickable.StopAtBounds

                Rectangle {
                    id: widgetBackground

                    anchors.centerIn: parent
                    width: widgetBorder.width + 2 * horizontalSheetMargin
                    height: widgetBorder.height + 2 * verticalSheetMargin

                    color: "lightgray"

                    // Only a border that fits its content and centers in its parent
                    Rectangle {
                        id: widgetBorder

                        anchors.centerIn: parent
                        width: trainingWidget.width
                        height: trainingWidget.height

                        border {
                            width: 1
                            color: "black"
                        }

                        TrainingWidget {
                            id: trainingWidget

                            focus: true

                            // A minimum width is needed for the widget to
                            // be able to scale the font size
                            minWidth: widgetContainer.width - 2 * horizontalSheetMargin
                            maxWidth: widgetContainer.width - 2 * horizontalSheetMargin

                            textMargin: 25

                            //                            docClipRect: Qt.rect(
                            //                                          0,
                            //                                          widgetScroller.flickableItem.contentY
                            //                                          - verticalSheetMargin,
                            //                                          widgetScroller.viewport.childrenRect.width,
                            //                                          widgetScroller.viewport.childrenRect.height)

                            // Note: title and text are set by root item via property alias
                            onEscape: root.quit()

                            onCursorRectangleChanged: {
                                // When cursor is not fully visible, scroll the flickable.
                                if (cursorRectangle.y < (widgetScroller.flickableItem.contentY
                                                         - verticalSheetMargin)
                                        || (cursorRectangle.y + cursorRectangle.height
                                            > (widgetScroller.flickableItem.contentY
                                               - verticalSheetMargin
                                               + widgetScroller.viewport.childrenRect.height))) {
                                    scrollAnimation.to = cursorRectangle.y
                                    scrollAnimation.start()
                                }

                                //                                if (cursorRectangle.y < (widgetScroller.flickableItem.contentY
                                //                                                         - verticalSheetMargin)) {
                                //                                    // Scroll down
                                //                                    scrollAnimation.to = cursorRectangle.y
                                //                                    scrollAnimation.start()
                                //                                } else if (cursorRectangle.y + cursorRectangle.height
                                //                                           > (widgetScroller.flickableItem.contentY
                                //                                              - verticalSheetMargin
                                //                                              + widgetScroller.viewport.childrenRect.height)) {
                                //                                    // Scroll up
                                //                                    scrollAnimation.to = cursorRectangle.y + cursorRectangle.height
                                //                                            - widgetScroller.viewport.childrenRect.height + verticalSheetMargin
                                //                                    scrollAnimation.start()
                                //                                }
                            }

                            onCursorPositionChanged: {
                                if (0 == cursorPosition
                                        && 0 == activeLineNumber) {
                                    scrollAnimation.to = 0
                                    scrollAnimation.start()
                                }
                            }
                        } // trainingWidget
                    } // widgetBorder

                    DropShadow {
                        anchors.centerIn: parent
                        width: widgetBorder.width
                        height: widgetBorder.height
                        horizontalOffset: 3
                        verticalOffset: -3
                        radius: 1
                        samples: 2
                        color: widgetBorder.border.color
                        source: widgetBorder
                    }
                } // widgetBackground
            } // widgetScroller
        } // widgetContainer
    } // Column

    NumberAnimation {
        id: scrollAnimation
        target: widgetScroller.flickableItem
        duration: 350
        property: "contentY"
        easing.type: Easing.InOutSine
    }
} // root
