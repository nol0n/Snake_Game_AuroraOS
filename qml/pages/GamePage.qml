import QtQuick 2.0
import Sailfish.Silica 1.0
import SnakeGame 1.0
import Nemo.Configuration 1.0
import QtQuick.LocalStorage 2.0

Page {
    objectName: "GamePage"
    id: page

    property int buttonSize: 120
    property int score: 0
    property bool state: false
    property string playerName: ""

    function startGame(state) {
        if (state === false) {
            state = true
            game.changeState();
            gameEnd.text = " ";
        }
    }

    function updateScore(playerName, score) {
        var db = LocalStorage.openDatabaseSync("GameScores", "1.0", "Game Database", 1000000);
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT score FROM Players WHERE name = ?', [playerName]);

            if (rs.rows.length > 0) {
                var currentScore = rs.rows.item(0).score;

                if (score > currentScore) {
                    tx.executeSql('UPDATE Players SET score = ? WHERE name = ?', [score, playerName]);
                }
            } else {
                tx.executeSql('INSERT INTO Players (name, score) VALUES (?, ?)', [playerName, score]);
            }
        });
    }

    ConfigurationValue {
        id: name
        key: "/apps/snake/name"
        defaultValue: ""
    }

    Component.onCompleted: {
        playerName = name.value;
    }

    SnakeGame {
        id: game
    }

    Timer {
        id: gameTimer
        interval: 250
        running: state
        repeat: true
        onTriggered: {
            game.update()
            picture.requestPaint()
        }
    }

    Connections {
        target: game
        onStateChanged: {
            page.state = game.state;
            if (page.state === false) {
                gameEnd.text = "Игрок: " + playerName + " | Счет: " + score
                updateScore(playerName, score)
                game.reset()
            }
        }
        onFieldChanged: {
            picture.requestPaint()
            score = game.getScore() - 1
        }
    }

    Column {
        id: col
        width: page.width

        Button {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            id: exitButton
            text: "в галвное меню"
            onClicked: {
                pageLoader.source = Qt.resolvedUrl("StartPage.qml");
            }
        }

        Rectangle {
            height: 50
            width: 1
            color: "transparent"
        }

        Label {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            id: gameEnd
            text: " "
            bottomPadding: 50
            font.pixelSize: 50
        }

        Label {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            id: gameScore
            text: "Счет: " + score
            bottomPadding: 50
            font.pixelSize: 50
        }

        Item {
            id: gameCanvas
            width: parent.width
            height: parent.width

            Canvas {
                id: picture
                anchors.centerIn: parent
                width: gameCanvas.width
                height: gameCanvas.width

                onPaint: {
                    var ctx = getContext("2d");
                    var i = 0;

                    // отрисовка поля
                    var rSize = width / game.fieldSize;

                    for (var y = 0; y < game.fieldSize; ++y) {
                        for (var x = 0; x < game.fieldSize; ++x) {
                            if ((x + y) % 2 === 0) {
                                ctx.fillStyle = "#aad751";
                            } else {
                                ctx.fillStyle = "#a2d149";
                            }

                            ctx.fillRect(y * rSize, x * rSize, rSize, rSize);

                            var cell = game.fieldCell(y, x);
                            if (cell === 1) {
                                ctx.fillStyle = "darkgreen";
                                ctx.fillRect(y * rSize, x * rSize, rSize, rSize);
                            } else if (cell === 2) {
                                ctx.fillStyle = "green";
                                ctx.fillRect(y * rSize, x * rSize, rSize, rSize);
                            } else if (cell === 3) {
                                ctx.fillStyle = "darkred";
                                ctx.beginPath();
                                ctx.arc(y * rSize + rSize/2, x * rSize + rSize/2, rSize/2, 0, 2 * Math.PI);
                                ctx.fill();
                            }
                        }
                    }

                }
            }
        }

        Rectangle {
            height: 50
            width: 1
            color: "transparent"
        }

        IconButton {
            id: dirUp
            height: buttonSize
            width: buttonSize
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            icon.source: "image://theme/icon-l-play"
            rotation: -90
            onClicked: {
                startGame(page.state);
                game.changeDirection(119);
            }
        }

        Row {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            spacing: 100
            IconButton {
                id: dirLeft;
                height: buttonSize
                width: buttonSize
                icon.source: "image://theme/icon-l-play"
                rotation: 180
                onClicked: {
                    startGame(page.state);
                    game.changeDirection(97);
                }
            }

            IconButton {
                id: dirRight;
                height: buttonSize
                width: buttonSize
                icon.source: "image://theme/icon-l-play"
                onClicked: {
                    startGame(page.state);
                    game.changeDirection(100);
                }
            }
        }

        IconButton {
            id: dirDown
            height: buttonSize
            width: buttonSize
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            icon.source: "image://theme/icon-l-play"
            rotation: 90
            onClicked: {
                startGame(page.state);
                game.changeDirection(115);
            }
        }
    }
}
