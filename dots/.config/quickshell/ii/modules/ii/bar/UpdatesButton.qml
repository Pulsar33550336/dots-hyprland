import qs.modules.common
import qs.modules.common.widgets
import qs.services
import Quickshell
import QtQuick
import QtQuick.Layouts

MouseArea {
     id: root
     implicitWidth: rowLayout.implicitWidth + 10 * 2
     implicitHeight: Appearance.sizes.barHeight
     
     hoverEnabled: true
     acceptedButtons: Qt.LeftButton | Qt.RightButton
     
     onClicked: {
         if (mouse.button === Qt.RightButton) {
            const pkg = Config.options.updates.packageManager;
            if (pkg === "pacman") {
                Quickshell.execDetached(["zsh", "-c", Config.options.apps.update]);
            } else {
                Quickshell.execDetached(["zsh", "-c", Config.options.apps.terminal + " -e " + pkg + " -Syu"]);
            }
        }
     }

     RowLayout {
         id: rowLayout
         anchors.centerIn: parent
         spacing: 4

         MaterialSymbol {
             Layout.alignment: Qt.AlignVCenter
             text: "update"
             iconSize: Appearance.font.pixelSize.large
             color: Appearance.colors.colOnLayer1
         }
         
         StyledText {
             visible: true
             Layout.alignment: Qt.AlignVCenter
             font.pixelSize: Appearance.font.pixelSize.small
             color: Appearance.colors.colOnLayer1
             text: Updates.count
         }
     }

     UpdatesPopup {
        hoverTarget: root
     }
}
