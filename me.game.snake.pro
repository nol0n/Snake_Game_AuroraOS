TARGET = me.game.snake

CONFIG += \
    auroraapp

PKGCONFIG += \

SOURCES += \
    src/main.cpp \
    src/snakeGame.cpp

HEADERS += \
    src/snakeGame.h

DISTFILES += \
    qml/pages/GamePage.qml \
    qml/pages/LeaderboardPage.qml \
    rpm/me.game.snake.spec \

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/me.game.snake.ts \
    translations/me.game.snake-ru.ts \

RESOURCES +=
