import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    objectName: "defaultCover"

    CoverTemplate {
        objectName: "applicationCover"
        primaryText: ""
        secondaryText: qsTr("змэй")
        icon {
            source: Qt.resolvedUrl("../icons/snake.svg")
            sourceSize { width: icon.width; height: icon.height }
        }
    }
}
