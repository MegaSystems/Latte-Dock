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

import QtQuick 2.1
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kquickcontrolsaddons 2.0

MouseArea {
    id: configurationArea

    z: 1000

    anchors {
        fill: parent
        rightMargin: (plasmoid.formFactor !== PlasmaCore.Types.Vertical) ? toolBox.width : 0
        bottomMargin: (plasmoid.formFactor === PlasmaCore.Types.Vertical) ? toolBox.height : 0
    }

    hoverEnabled: true

    property bool isResizingLeft: false
    property bool isResizingRight: false
    property Item currentApplet
    property Item previousCurrentApplet

    property int lastX
    property int lastY
    property int appletX
    property int appletY

    readonly property int spacerHandleSize: units.smallSpacing

    onHeightChanged: tooltip.visible = false;
    onWidthChanged: tooltip.visible = false;

    onPositionChanged: {
        /*if (currentApplet && currentApplet.applet &&
                currentApplet.applet.pluginName == "org.kde.plasma.panelspacer") {
            if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
                if ((mouse.y - handle.y) < spacerHandleSize ||
                        (mouse.y - handle.y) > (handle.height - spacerHandleSize)) {
                    configurationArea.cursorShape = Qt.SizeVerCursor;
                } else {
                    configurationArea.cursorShape = Qt.ArrowCursor;
                }
            } else {
                if ((mouse.x - handle.x) < spacerHandleSize ||
                        (mouse.x - handle.x) > (handle.width - spacerHandleSize)) {
                    configurationArea.cursorShape = Qt.SizeHorCursor;
                } else {
                    configurationArea.cursorShape = Qt.ArrowCursor;
                }
            }
        } else {
            configurationArea.cursorShape = Qt.ArrowCursor;
        }*/

        if (pressed) {
            /* if (currentApplet && currentApplet.applet &&
                    currentApplet.applet.pluginName == "org.kde.plasma.panelspacer") {

                if (isResizingLeft) {
                    if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
                        handle.y += (mouse.y - lastY);
                        //      handle.height = currentApplet.height + (currentApplet.y - handle.y);
                    } else {
                        handle.x += (mouse.x - lastX);
                        //     handle.width = currentApplet.width + (currentApplet.x - handle.x);
                    }

                    lastX = mouse.x;
                    lastY = mouse.y;
                    return;

                } else if (isResizingRight) {
                    /*  if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
                        handle.height = mouse.y - handle.y;
                    } else {
                        handle.width = mouse.x - handle.x;
                    } */

            /*      lastX = mouse.x;
                    lastY = mouse.y;
                    return;
                }
            }*/

            var padding = units.gridUnit * 3;
            if (currentApplet && (mouse.x < -padding || mouse.y < -padding ||
                                  mouse.x > width + padding || mouse.y > height + padding)) {
                var newCont = plasmoid.containmentAt(mouse.x, mouse.y);

                if (newCont && newCont != plasmoid) {
                    var newPos = newCont.mapFromApplet(plasmoid, mouse.x, mouse.y);
                    newCont.addApplet(currentApplet.applet, newPos.x, newPos.y);
                    root.dragOverlay.currentApplet = null;
                    return;
                }
            }

            if(currentApplet){
                if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
                    currentApplet.y += (mouse.y - lastY);
                    //    handle.y = currentApplet.y;
                } else {
                    currentApplet.x += (mouse.x - lastX);
                    //     handle.x = currentApplet.x;
                }
            }

            lastX = mouse.x;
            lastY = mouse.y;

            var relevantLayout = mapFromItem(mainLayout, 0, 0);
            var item = mainLayout.childAt(mouse.x-relevantLayout.x, mouse.y-relevantLayout.y);

            if (item && item !== placeHolder) {
                //      placeHolder.width = item.width;
                //     placeHolder.height = item.height;
                placeHolder.parent = configurationArea;
                var posInItem = mapToItem(item, mouse.x, mouse.y);

                if ((plasmoid.formFactor === PlasmaCore.Types.Vertical && posInItem.y < item.height/2) ||
                        (plasmoid.formFactor !== PlasmaCore.Types.Vertical && posInItem.x < item.width/2)) {
                    root.layoutManager.insertBefore(item, placeHolder);
                } else {
                    root.layoutManager.insertAfter(item, placeHolder);
                }
            }

        } else {
            var relevantLayout = mapFromItem(mainLayout,0,0);

            var item = mainLayout.childAt(mouse.x-relevantLayout.x, mouse.y-relevantLayout.y);
            if (root.dragOverlay && item && item !== lastSpacer) {
                root.dragOverlay.currentApplet = item;
            } else {
                root.dragOverlay.currentApplet = null;
            }
        }

        if (root.dragOverlay.currentApplet && !currentApplet.isInternalViewSplitter) {
            hideTimer.stop();

            tooltip.visible = true;
            tooltip.raise();
        }
    }

    onExited: hideTimer.restart();

    onCurrentAppletChanged: {
        if(previousCurrentApplet && previousCurrentApplet.showZoomed)
            previousCurrentApplet.showZoomed = false;

        previousCurrentApplet = currentApplet;


        if (!currentApplet
                || !root.dragOverlay.currentApplet
                || (currentApplet &&currentApplet.isInternalViewSplitter)) {
            hideTimer.restart();
            return;
        }

        if(currentApplet.showZoomed !== undefined)
            currentApplet.showZoomed = true;

        var relevantLayout = mapFromItem(mainLayout, 0, 0);

        handle.x = relevantLayout.x + currentApplet.x;
        handle.y = relevantLayout.y + currentApplet.y;
        handle.width = currentApplet.width;
        handle.height = currentApplet.height;

        lockButton.checked = currentApplet.lockZoom;

        repositionHandler.restart();
    }

    onPressed: {
        if (!root.dragOverlay.currentApplet) {
            return;
        }

        /*
        if (currentApplet.applet.pluginName == "org.kde.plasma.panelspacer") {
            if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
                if ((mouse.y - handle.y) < spacerHandleSize) {
                    configurationArea.isResizingLeft = true;
                    configurationArea.isResizingRight = false;
                } else if ((mouse.y - handle.y) > (handle.height - spacerHandleSize)) {
                    configurationArea.isResizingLeft = false;
                    configurationArea.isResizingRight = true;
                } else {
                    configurationArea.isResizingLeft = false;
                    configurationArea.isResizingRight = false;
                }

            } else {
                if ((mouse.x - handle.x) < spacerHandleSize) {
                    configurationArea.isResizingLeft = true;
                    configurationArea.isResizingRight = false;
                } else if ((mouse.x - handle.x) > (handle.width - spacerHandleSize)) {
                    configurationArea.isResizingLeft = false;
                    configurationArea.isResizingRight = true;
                } else {
                    configurationArea.isResizingLeft = false;
                    configurationArea.isResizingRight = false;
                }
            }
        }*/

        var relevantApplet = mapFromItem(currentApplet, 0, 0);
        appletX = mouse.x - relevantApplet.x;
        appletY = mouse.y - relevantApplet.y;

        lastX = mouse.x;
        lastY = mouse.y;
        placeHolder.width = currentApplet.width;
        placeHolder.height = currentApplet.height;
        handle.width = currentApplet.width;
        handle.height = currentApplet.height;
        root.layoutManager.insertBefore(currentApplet, placeHolder);
        currentApplet.parent = root;
        currentApplet.x = lastX-appletX;
        currentApplet.y = lastY-appletY;
        currentApplet.z = 900;
    }

    onReleased: {
        if (!root.dragOverlay.currentApplet) {
            return;
        }

        if(currentApplet && currentApplet.applet){
            if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
                currentApplet.applet.configuration.length = handle.height;
            } else {
                currentApplet.applet.configuration.length = handle.width;
            }
        }

        configurationArea.isResizingLeft = false;
        configurationArea.isResizingRight = false;

        root.layoutManager.insertBefore(placeHolder, currentApplet);
        placeHolder.parent = configurationArea;
        currentApplet.z = 1;

        var relevantLayout = mapFromItem(mainLayout, 0, 0);

        handle.x = relevantLayout.x + currentApplet.x;
        handle.y = relevantLayout.y + currentApplet.y;
        //     handle.width = currentApplet.width;
        //    handle.height = currentApplet.height;
        root.layoutManager.save();
    }

    Item {
        id: placeHolder
        visible: configurationArea.containsMouse
        Layout.fillWidth: currentApplet ? currentApplet.Layout.fillWidth : false
        Layout.fillHeight: currentApplet ? currentApplet.Layout.fillHeight : false
    }

    //Because of the animations for the applets the handler can not catch up to
    //reposition itself when the currentApplet position or size changes.
    //This timer fixes that situation
    Timer {
        id: repositionHandler
        interval: 100
        onTriggered: handle.updatePlacement();
    }

    Timer {
        id: hideTimer
        interval: units.longDuration * 2
        onTriggered: tooltip.visible = false;
    }

    Connections {
        target: currentApplet
        onXChanged: handle.updatePlacement();
        onYChanged: handle.updatePlacement();
        onWidthChanged: handle.updatePlacement();
        onHeightChanged: handle.updatePlacement()
    }

    Rectangle {
        id: handle
        visible: configurationArea.containsMouse
        color: theme.backgroundColor
        radius: 3
        opacity: currentApplet ? 0.5 : 0

        //BEGIN functions
        function updatePlacement(){
            if(currentApplet){
                var transformChoords = root.mapFromItem(currentApplet, 0, 0)

                handle.x = transformChoords.x;
                handle.y = transformChoords.y;
                handle.width = currentApplet.width;
                handle.height = currentApplet.height;

                repositionHandler.restart();
            }
        }

        //END functions
        PlasmaCore.IconItem {
            source: "transform-move"
            width: Math.min(parent.width, parent.height)
            height: width
            anchors.centerIn: parent
        }
        /*  Rectangle {
            anchors {
                left: parent.left
                top: parent.top
                bottom: (plasmoid.formFactor !== PlasmaCore.Types.Vertical) ? parent.bottom : undefined
                right: (plasmoid.formFactor !== PlasmaCore.Types.Vertical) ? undefined : parent.right
            }
            visible: currentApplet && currentApplet.applet.pluginName == "org.kde.plasma.panelspacer"
            opacity: visible && !xAnim.running && !yAnim.running ? 1.0 : 0
            width: configurationArea.spacerHandleSize
            height: configurationArea.spacerHandleSize
            color: theme.textColor
            Behavior on opacity {
                NumberAnimation {
                    duration: units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }
        Rectangle {
            anchors {
                right: parent.right
                top: (plasmoid.formFactor !== PlasmaCore.Types.Vertical) ? parent.top : undefined
                bottom: parent.bottom
                left: (plasmoid.formFactor !== PlasmaCore.Types.Vertical) ? undefined : parent.left
            }
            visible: currentApplet && currentApplet.applet.pluginName == "org.kde.plasma.panelspacer"
            opacity: visible && !xAnim.running && !yAnim.running ? 1.0 : 0
            width: configurationArea.spacerHandleSize
            height: configurationArea.spacerHandleSize
            color: theme.textColor
            Behavior on opacity {
                NumberAnimation {
                    duration: units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }*/

        PlasmaComponents.Button{
            id: lockButton
            checkable: true
            iconSource: checked ? "lock" : "unlock"
            width: units.iconSizes.large
            visible: currentApplet &&
                     ((currentApplet.applet &&
                       ((currentApplet.applet.pluginName === "org.kde.plasma.systemtray")
                        || (currentApplet.applet.pluginName === root.plasmoidName)) )
                      || (currentApplet.isInternalViewSplitter))
                     ? false : true

            anchors.margins: 2*units.smallSpacing
            tooltip: "Lock/Unlock zoom effect"

            onCheckedChanged: {
                currentApplet.lockZoom = checked;
                root.layoutManager.saveLocks();
            }

            states: [
                State {
                    name: "left"
                    when: plasmoid.location === PlasmaCore.Types.LeftEdge

                    AnchorChanges {
                        target: lockButton
                        anchors{ top:parent.top; bottom:undefined; left:undefined; right:parent.right; }
                    }
                },
                State {
                    name: "right"
                    when: plasmoid.location === PlasmaCore.Types.RightEdge

                    AnchorChanges {
                        target: lockButton
                        anchors{ top:parent.top; bottom:undefined; left:parent.left; right:undefined; }
                    }
                },
                State {
                    name: "bottom"
                    when: plasmoid.location === PlasmaCore.Types.BottomEdge

                    AnchorChanges {
                        target: lockButton
                        anchors{ top:parent.top; bottom:undefined; left:parent.left; right:undefined; }
                    }
                },
                State {
                    name: "top"
                    when: plasmoid.location === PlasmaCore.Types.TopEdge

                    AnchorChanges {
                        target: lockButton
                        anchors{ top:undefined; bottom:parent.bottom; left:undefined; right:parent.right; }
                    }
                }
            ]
        }

        Behavior on x {
            enabled: !configurationArea.pressed
            NumberAnimation {
                id: xAnim
                duration: units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on y {
            id: yAnim
            enabled: !configurationArea.pressed
            NumberAnimation {
                duration: units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on width {
            enabled: !configurationArea.pressed
            NumberAnimation {
                duration: units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on height {
            enabled: !configurationArea.pressed
            NumberAnimation {
                duration: units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
    PlasmaCore.Dialog {
        id: tooltip
        visualParent: currentApplet

        type: PlasmaCore.Dialog.Dock
        flags: Qt.WindowStaysOnTopHint|Qt.WindowDoesNotAcceptFocus|Qt.BypassWindowManagerHint
        location: plasmoid.location

        onVisualParentChanged: {
            if (visualParent && currentApplet && currentApplet.applet) {
                configureButton.visible = currentApplet.applet.action("configure") && currentApplet.applet.action("configure").enabled;
                closeButton.visible = currentApplet.applet.action("remove") && currentApplet.applet.action("remove").enabled;
                label.text = currentApplet.applet.title;
            }
        }

        mainItem: MouseArea {
            enabled: currentApplet
            width: handleRow.childrenRect.width + (2 * handleRow.spacing)
            height: Math.max(configureButton.height, label.contentHeight, closeButton.height)
            hoverEnabled: true
            onEntered: hideTimer.stop();
            onExited:  hideTimer.restart();
            Row {
                id: handleRow
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: units.smallSpacing
                PlasmaComponents.ToolButton {
                    id: configureButton
                    anchors.verticalCenter: parent.verticalCenter
                    iconSource: "configure"
                    onClicked: {
                        tooltip.visible = false;
                        currentApplet.applet.action("configure").trigger()
                    }
                }
                PlasmaComponents.Label {
                    id: label
                    anchors.verticalCenter: parent.verticalCenter
                    textFormat: Text.PlainText
                    maximumLineCount: 1
                }
                PlasmaComponents.ToolButton {
                    id: closeButton
                    anchors.verticalCenter: parent.verticalCenter
                    iconSource: "window-close"
                    onClicked: {
                        tooltip.visible = false;
                        if(currentApplet && currentApplet.applet)
                            currentApplet.applet.action("remove").trigger();
                    }
                }
            }
        }
    }
}
