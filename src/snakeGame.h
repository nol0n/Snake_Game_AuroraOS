#ifndef SNAKEGAME_H
#define SNAKEGAME_H

#include <QObject>

#include <deque>
#include <random>
#include <unordered_map>

class snakeGame : public QObject
{
    Q_OBJECT
    Q_PROPERTY(unsigned int fieldSize READ fieldSize WRITE setFieldSize NOTIFY fieldSizeChanged)
    Q_PROPERTY(int state READ state NOTIFY stateChanged)
public:
    enum direction { left, up, right, down };
    const int dDirection[4] = {-1, -1, 1, 1};
    const std::unordered_map<int, direction> keyDirection = {
      {119, direction::up},   // W
      {97, direction::left},  // A
      {115, direction::down}, // S
      {100, direction::right} // D
    };

    enum gameState { stopped, running };

    const char items[4] = {' ', 'H', 'S', 'F'};

    struct coordinates {
    int x;
    int y;
    coordinates(int a_x, int a_y) : x(a_x), y(a_y) {}
    };

    explicit snakeGame(QObject *parent = nullptr, unsigned int fieldSize = 11, gameState state = stopped);

    int fieldSize() const;
    void setFieldSize(unsigned int value);

    int state() const;
private:
    unsigned int m_fieldSize;
    unsigned int *m_gameField;

    unsigned int m_snakeSize;
    std::deque<coordinates> m_snakeBody;

    gameState m_state;
    direction m_currentDirection;

    std::mt19937 m_mt;
    std::uniform_int_distribution<> m_intDist;
    bool m_fruitPlaced;
    bool m_directionChanged;

    void p_moveSnake();
    void p_addFruit();
    bool p_checkCollision(coordinates coords, direction dir);
public slots:
    void changeDirection(int key);
    void changeState();
    int fieldCell(unsigned int x, unsigned int y);
    int getScore();
    void reset();
    void update();
signals:
    void stateChanged();
    void fieldSizeChanged();
    void fieldChanged();
};

#endif // SNAKEGAME_H
