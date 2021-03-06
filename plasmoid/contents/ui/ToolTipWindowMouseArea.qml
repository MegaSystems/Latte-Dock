/*
*  Copyright 2016  Smith AR <audoban@openmailbox.org>
*                  Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of Latte-Dock
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0

import org.kde.plasma.components 2.0 as PlasmaComponents

MouseArea {
    property var modelIndex
    property int winId // FIXME Legacy
    property Item thumbnailItem

    acceptedButtons: Qt.LeftButton
    hoverEnabled: true
    enabled: winId != 0

    onClicked: {
        tasksModel.requestActivate(modelIndex);
        windowsPreviewDlg.hide();
        //toolTip.hideToolTip();
    }

    onContainsMouseChanged: {
        tooltipContentItem.checkMouseInside();

        root.windowsHovered([winId], containsMouse);
    }

    PlasmaComponents.ToolButton {
        anchors {
            top: parent.top
            topMargin: thumbnailItem ? (thumbnailItem.height - thumbnailItem.paintedHeight) / 2 : 0
            right: parent.right
            rightMargin: thumbnailItem ? (thumbnailItem.width - thumbnailItem.paintedWidth) / 2 : 0
        }

        iconSource: "window-close"
        visible: parent.containsMouse && winId != 0
        tooltip: i18nc("close this window", "Close")

        onClicked: tasksModel.requestClose(modelIndex);
    }
}
