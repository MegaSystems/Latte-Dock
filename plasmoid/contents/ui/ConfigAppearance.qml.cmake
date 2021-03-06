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
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: mainItem

    width: childrenRect.width
    height: childrenRect.height

    property bool vertical: (plasmoid.formFactor == PlasmaCore.Types.Vertical)

    property alias cfg_zoomHelper: zoomHelper.checked
    property alias cfg_zoomLevel: zoomLevel.value
    property alias cfg_showShadows: showShadows.checked
    property alias cfg_showGlow: showGlow.checked
    property alias cfg_iconSize: iconSizeCmb.realValue
    property alias cfg_threeColorsWindows: threeColorsWindows.checked
    property alias cfg_dotsOnActive: dotsOnActive.checked
    property alias cfg_durationTime : durationTime.value
    property alias cfg_reverseLinesPosition : reverseLinesPosition.checked

    property alias cfg_isInNowDockPanel: mainItem.isInNowDockPanel

    property bool isInNowDockPanel

    ColumnLayout {
        id:mainColumn
        spacing: 15
        width: parent.width-40

        //Layout.fillWidth: true

        GroupBox {
            title: ""
            flat: true
            Layout.fillWidth: true

            ColumnLayout {
                Layout.fillWidth: true
                width: mainItem.width-40

                RowLayout{

                    Label {
                        text: i18n("Icon size: ")
                    }

                    ComboBox {
                        // 16, 22, 32, 48, 64,128, 256
                        id: iconSizeCmb
                        enabled: !mainItem.isInNowDockPanel

                        property int realValue
                        property bool startup: true
                        model: ["16px.", "22px.", "32px.", "48px.", "64px.", "96px", "128px.", "256px."]

                        onCurrentIndexChanged: {
                            switch(currentIndex){
                            case 0:
                                realValue = 16;
                                break;
                            case 1:
                                realValue = 22;
                                break;
                            case 2:
                                realValue = 32;
                                break;
                            case 3:
                                realValue = 48;
                                break;
                            case 4:
                                realValue = 64;
                                break;
                            case 5:
                                realValue = 96;
                                break;
                            case 6:
                                realValue = 128;
                                break;
                            case 7:
                                realValue = 256;
                                break;
                            default:
                                realValue = 64;
                                break
                            }
                        }

                        onRealValueChanged: {
                            if(startup){
                                switch (realValue){
                                case 16:
                                    currentIndex = 0;
                                    break;
                                case 22:
                                    currentIndex = 1;
                                    break;
                                case 32:
                                    currentIndex = 2;
                                    break;
                                case 48:
                                    currentIndex = 3;
                                    break;
                                case 64:
                                    currentIndex = 4;
                                    break;
                                case 96:
                                    currentIndex = 5;
                                    break;
                                case 128:
                                    currentIndex = 6;
                                    break;
                                case 256:
                                    currentIndex = 7;
                                    break;
                                default:
                                    currentIndex = 4;
                                    break
                                }
                                startup = false;
                            }
                        }
                    }

                    Label {
                        id: versionLabel

                        font.italic: true
                        horizontalAlignment: Text.AlignRight
                        Layout.alignment: Qt.AlignRight
                        Layout.fillWidth: true

                        text: i18n("ver: ") + "@VERSION@"
                    }
                }


                CheckBox {
                    id: showShadows
                    text: i18n("Enable shadows for icons")
                    enabled: true
                }

                CheckBox {
                    id: showGlow
                    text: i18n("Show glow around windows points")
                    enabled: true
                }

                CheckBox {
                    id: threeColorsWindows
                    text: i18n("Different color for minimized windows")
                    enabled: true
                }

                CheckBox {
                    id: dotsOnActive
                    text: i18n("Dots on active window")
                    enabled: true
                }

                CheckBox {
                    id: reverseLinesPosition
                    text: i18n("Reverse position for lines and dots")
                    enabled: true
                }
            }
        }

        GridLayout{
            id: animationsGridLayout
            Layout.fillWidth: true
            columns: 3


            Label {
                id: durationTimeLabel

                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter

                text: i18n("Animations: ")
            }

            Slider {
                id: durationTime
                enabled: true
                Layout.fillWidth: true
                minimumValue: 0
                maximumValue: 3
                stepSize: 1
                tickmarksEnabled: true
            }
            Label {
                enabled: durationTime.value > 0
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                font.italic: durationTime.value > 0 ? false : true

                property string textUsed: durationTime.value > 0 ? i18n("duration") : i18n("disabled")

                text: (durationTime.value > 0 ? ("x" + durationTime.value) + " " + textUsed : textUsed )
            }

            Label{Layout.columnSpan: 3}

            Item{
                enabled: !mainItem.isInNowDockPanel
                Layout.columnSpan: 3
                Layout.fillWidth: true
                Label {
                    text: i18n("Zoom")
                    anchors.centerIn: parent
                    font.bold: true
                    font.italic: true
                }
            }

            //////

            Label {
                enabled: !mainItem.isInNowDockPanel
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter

                text: i18n("Level: ")
            }

            Slider {
                id: zoomLevel
                enabled: !mainItem.isInNowDockPanel
                Layout.fillWidth: true
                minimumValue: 0
                maximumValue: 20
                stepSize: 1
                tickmarksEnabled: true
            }

            Label {
                id:zoomLevelText
                enabled: !mainItem.isInNowDockPanel
                Layout.minimumWidth: metricsLabel2.width
                Layout.maximumWidth: metricsLabel2.width
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                //Layout.alignment: Qt.AlignRight


                property real fixedZoom: (1 + (zoomLevel.value / 20))
                text:  "x"+ fixedZoom.toFixed(2)

                Label{
                    id:metricsLabel2
                    visible: false
                    text: "x1.50"
                }
            }
            /////
            //spacer to set a minimumWidth for sliders
            //Layout.minimumWidth didnt work
            Label{}
            //  Label{Layout.maximumWidth: 275}
            Label{}

            ////////

            CheckBox {
                id: zoomHelper
                enabled: !mainItem.isInNowDockPanel
                text: i18n("Show a red line on the limit needed for animations")

                Layout.columnSpan: 3
            }
        }
    }

    DropShadow {
        id:shadowText
        anchors.fill: inNowDockLabel
        enabled: isInNowDockPanel
        radius: 3
        samples: 5
        color: "#cc080808"
        source: inNowDockLabel

        verticalOffset: 2
        horizontalOffset: -1
        visible: isInNowDockPanel
    }


    Label {
        id:inNowDockLabel
        anchors.horizontalCenter: mainItem.horizontalCenter
        anchors.bottom: mainColumn.bottom
        anchors.bottomMargin: mainColumn.height / 12
      //  anchors.verticalCenterOffset:  (mainColumn.height / 4)

        width: 0.85 * mainItem.width
        text: i18n("For the disabled settings you should use the Latte Dock Configuration Window")
        visible: mainItem.isInNowDockPanel

        horizontalAlignment: Text.AlignHCenter
        //  font.bold: true
        font.italic: true
        font.pointSize: 1.2 * theme.defaultFont.pointSize

        wrapMode: Text.WordWrap
    }
}
