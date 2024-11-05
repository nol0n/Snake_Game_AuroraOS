import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import Nemo.Configuration 1.0

Page {
    objectName: "StartPage"
    id: page

    Component.onCompleted: {
        nameField.text = name.value
        var db = LocalStorage.openDatabaseSync("GameScores", "1.0", "Game Database", 1000000);
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS Players (id INTEGER PRIMARY KEY, name TEXT UNIQUE, score INTEGER)');
        });
    }

    ConfigurationValue {
        id: name
        key: "/apps/snake/name"
        defaultValue: ""
    }

    Column {
        anchors {
            horizontalCenter: page.horizontalCenter
        }
        spacing: 30
        y: page.height / 4

        Label {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            text: "Змея"
            font.pixelSize: 50

            bottomPadding: 150
        }

        TextField {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            id: nameField
            placeholderText: "введите имя"
            text: ""
        }

        Label {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            id: notificationField
            text: " "
            font.pixelSize: 30
            color: "#77b3d3"
        }

        Button {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            id: playButton
            text: "играть"
            onClicked: {
                if (nameField.text === "") {
                    notificationField.text = "введите имя"
                } else if (nameField.text.length > 20) {
                    notificationField.text = "имя должно быть короче 20 символов"
                } else {
                    name.value = nameField.text
                    pageLoader.source = Qt.resolvedUrl("GamePage.qml")
                }
            }
        }
        Button {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            id: playLeaderboard
            text: "рекорды"
            onClicked: {
                pageStack.push(Qt.resolvedUrl("LeaderboardPage.qml"));
            }
        }
    }
}
