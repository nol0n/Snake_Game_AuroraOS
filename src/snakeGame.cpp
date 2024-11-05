#include "snakeGame.h"

#include <chrono>
#include <random>

snakeGame::snakeGame(QObject *parent, unsigned int fieldSize, gameState state) : QObject(parent)
{
    m_fieldSize = fieldSize;
    m_state = state;

    m_gameField = new unsigned int[fieldSize * fieldSize]{};

    m_snakeSize = 1;
    m_currentDirection = direction::left;
    m_snakeBody.push_front(
        coordinates(m_fieldSize / 2, m_fieldSize / 2));
    m_gameField[(m_fieldSize / 2 * m_fieldSize) + m_fieldSize / 2] = 1;

    int seed =
        std::chrono::system_clock::now().time_since_epoch().count();
    m_mt = std::mt19937(seed);
    m_intDist =
        std::uniform_int_distribution<>(0, fieldSize * fieldSize - 1);
    p_addFruit();
    m_fruitPlaced = true;
    m_directionChanged = false;
}

int snakeGame::fieldSize() const
{
    return m_fieldSize;
}

void snakeGame::setFieldSize(unsigned int value)
{
    if (m_fieldSize != value) {
        m_fieldSize = value;
        reset();
        emit fieldSizeChanged();
    }
}

int snakeGame::fieldCell(unsigned int x, unsigned int y) {
    if (x < m_fieldSize && y < m_fieldSize)
        return m_gameField[y * m_fieldSize + x];
    return -1;
}

int snakeGame::getScore() {
    return m_snakeSize;
}

int snakeGame::state() const
{
    return m_state;
}

void snakeGame::update() {
  p_moveSnake();
  if (!m_fruitPlaced) {
    p_addFruit();
    m_fruitPlaced = true;
  }
}

void snakeGame::reset() {
  m_snakeBody.clear();

  delete[] m_gameField;
  m_gameField = new unsigned int[m_fieldSize * m_fieldSize]{};

  m_snakeSize = 1;
  m_currentDirection = direction::left;
  m_snakeBody.push_front(
      coordinates(m_fieldSize / 2, m_fieldSize / 2));
  m_gameField[(m_fieldSize / 2 * m_fieldSize) + m_fieldSize / 2] = 1;
  m_state = gameState::stopped;
  m_intDist =
      std::uniform_int_distribution<>(0, m_fieldSize * m_fieldSize - 1);
  p_addFruit();
  m_fruitPlaced = true;
  m_directionChanged = false;
  emit fieldChanged();
}

void snakeGame::p_moveSnake() {
  if (p_checkCollision(m_snakeBody.front(), m_currentDirection)) {
    changeState();
    return;
  }

  int deltaX = (m_currentDirection == direction::left ||
                m_currentDirection == direction::right)
                   ? dDirection[m_currentDirection]
                   : 0;
  int deltaY = (m_currentDirection == direction::up ||
                m_currentDirection == direction::down)
                   ? dDirection[m_currentDirection]
                   : 0;

  coordinates head = m_snakeBody.front();
  m_gameField[head.y * m_fieldSize + head.x] = 2;

  if (m_gameField[(head.y + deltaY) * m_fieldSize +
                  (head.x + deltaX)] == 3) {
    m_snakeSize++;
    m_fruitPlaced = false;
  } else {
    coordinates back = m_snakeBody.back();
    m_gameField[back.y * m_fieldSize + back.x] = 0;
    m_snakeBody.pop_back();
  }

  m_snakeBody.push_front(
      snakeGame::coordinates(head.x + deltaX, head.y + deltaY));

  coordinates newHead = m_snakeBody.front();
  m_gameField[newHead.y * m_fieldSize + newHead.x] = 1;

  m_directionChanged = false;
  emit fieldChanged();
}

void snakeGame::p_addFruit() {
  while (true) {
    int pos = m_intDist(m_mt);

    if (m_gameField[pos] == 0) {
      m_gameField[pos] = 3;
      break;
    }
  }
}

bool snakeGame::p_checkCollision(coordinates coords, direction dir) {
  int deltaX = (dir == direction::left || dir == direction::right)
                   ? dDirection[dir]
                   : 0;
  int deltaY = (dir == direction::up || dir == direction::down)
                   ? dDirection[dir]
                   : 0;

  int newX = coords.x + deltaX;
  int newY = coords.y + deltaY;

  if (newX < 0 || newX >= static_cast<int>(m_fieldSize) || newY < 0 ||
      newY >= static_cast<int>(m_fieldSize) ||
      m_gameField[newY * m_fieldSize + newX] == 1 ||
      m_gameField[newY * m_fieldSize + newX] == 2) {
    return true;
  }
  return false;
}

void snakeGame::changeDirection(int key) {
  if (m_directionChanged)
    return;

  auto it = keyDirection.find(key);

  if (it != keyDirection.end()) {
    direction dir = it->second;

    if ((static_cast<int>(dir) + 2) % 4 !=
        static_cast<int>(m_currentDirection) || m_snakeSize == 1)
      m_currentDirection = dir;
    m_directionChanged = true;
  }
}

void snakeGame::changeState() {
  if (m_state == gameState::running)
    m_state = gameState::stopped;
  else
    m_state = gameState::running;
  emit stateChanged();
}
