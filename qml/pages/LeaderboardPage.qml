import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

Page {
    objectName: "LeaderboardPage"

    Column {
        x: 50
        y: 200

        width: parent.width
        height: parent.height

        Label {
            text: "Таблица лидеров"
            font.pixelSize: 50
            color: "Skyblue"
            bottomPadding: 50
        }

        ListView {
            width: parent.width
            height: parent.height

            model: ListModel {
                id: leaderboardModel
            }

            delegate: Item {
                width: parent.width
                height: 50
                Row {
                   spacing: 20

                   // Номер игрока
                   Label {
                       text: (index + 1) + "."
                       font.pixelSize: 35
                       width: 50  // Фиксированная ширина для номера
                       horizontalAlignment: Text.AlignRight
                   }

                   // Имя игрока
                   Label {
                       text: model.name
                       font.pixelSize: 35
                       width: 300  // Фиксированная ширина для имени
                       elide: Text.ElideRight  // Обрезка текста при слишком длинных именах
                   }

                   // Очки игрока
                   Label {
                       text: model.score
                       font.pixelSize: 35
                       width: 100  // Фиксированная ширина для счета
                       horizontalAlignment: Text.AlignRight
                   }
                }
            }
        }
    }

    Component.onCompleted: {
        var db = LocalStorage.openDatabaseSync("GameScores", "1.0", "Game Database", 1000000);
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT name, score FROM Players ORDER BY score DESC');
            leaderboardModel.clear();
            for (var i = 0; i < rs.rows.length; i++) {
                leaderboardModel.append({name: rs.rows.item(i).name, score: rs.rows.item(i).score});
            }
        });
    }
}

