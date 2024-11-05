#include <auroraapp.h>
#include <QtQuick>
#include "snakeGame.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<snakeGame>("SnakeGame", 1, 0, "SnakeGame");

    QScopedPointer<QGuiApplication> application(Aurora::Application::application(argc, argv));
    application->setOrganizationName(QStringLiteral("me.game"));
    application->setApplicationName(QStringLiteral("snake"));

    QScopedPointer<QQuickView> view(Aurora::Application::createView());
    view->setSource(Aurora::Application::pathTo(QStringLiteral("qml/snake.qml")));
    view->show();

    return application->exec();
}
