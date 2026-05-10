/**
 *     Authors: Prof. Morales, Delmas Nothstein, Nathan Lafayette, Claire Kolovich
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Enemy.pde
 * Description: Enemies that damage the player and take their turns
 */

class Enemy extends Actor {

  private Scene scene;

  Enemy(Scene scene, Direction direction) {
  super(50, 5, direction);   // health, damage, facing
  this.scene = scene;
}

  @Override
public Action getAction() {
  int DETECTION_RANGE = 2; // tweak this later
  Position pos = scene.getPosition(this);
  Position playerPos = scene.getPosition(scene.getPlayer());

  if (pos == null || playerPos == null) {
    return Action.MOVE_NORTH;
  }

  // detection check
  int dist = manhattanDistance(pos, playerPos);

  if (dist > DETECTION_RANGE) {
    return wander();
  }

  // OTHERWISE → chase player
  return chase(pos, playerPos);
}

  @Override
  public void draw() {
    // required by WorldObject, not used
  }

  public void render(float x, float y, float size) {

    fill(200, 0, 0);
    rect(x, y, size, size);

    fill(255);

    float cx = x + size / 2;
    float cy = y + size / 2;
    float offset = size * 0.25;

    switch (facing) {
      case NORTH:
        triangle(cx, cy - offset,
                 cx - offset, cy,
                 cx + offset, cy);
        break;

      case SOUTH:
        triangle(cx, cy + offset,
                 cx - offset, cy,
                 cx + offset, cy);
        break;

      case EAST:
        triangle(cx + offset, cy,
                 cx, cy - offset,
                 cx, cy + offset);
        break;

      case WEST:
        triangle(cx - offset, cy,
                 cx, cy - offset,
                 cx, cy + offset);
        break;
    }
  }
  
  private boolean canMoveTo(int dx, int dy) {
  Position pos = scene.getPosition(this);
  if (pos == null) return false;

  int x = pos.getX() + dx;
  int y = pos.getY() + dy;

  // bounds
  if (x < 0 || y < 0 || x >= scene.getRoomWidth() || y >= scene.getRoomHeight()) {
    return false;
  }

  // blocked tile
  WorldObject obj = scene.getObjectAt(x, y);
  return obj == null || obj instanceof Player;
  }
  
  private int manhattanDistance(Position a, Position b) {
  return abs(a.getX() - b.getX()) + abs(a.getY() - b.getY());
}

private Action wander() {

  Action[] options = {
    Action.MOVE_NORTH,
    Action.MOVE_SOUTH,
    Action.MOVE_EAST,
    Action.MOVE_WEST
  };

  // try random valid move
  for (int i = 0; i < options.length; i++) {
    Action a = options[int(random(options.length))];
    if (this.getActionValidity(a)) {
      return a;
    }
  }

  return null;
}

private Action chase(Position pos, Position playerPos) {

  int dx = Integer.compare(playerPos.getX(), pos.getX());
  int dy = Integer.compare(playerPos.getY(), pos.getY());

  Action preferred;

  if (dx > 0) preferred = Action.MOVE_EAST;
  else if (dx < 0) preferred = Action.MOVE_WEST;
  else if (dy > 0) preferred = Action.MOVE_SOUTH;
  else preferred = Action.MOVE_NORTH;

  if (this.getActionValidity(preferred)) {
    return preferred;
  }

  Action alternate;

  if (preferred == Action.MOVE_EAST || preferred == Action.MOVE_WEST) {
    alternate = (dy > 0) ? Action.MOVE_SOUTH : Action.MOVE_NORTH;
  } else {
    alternate = (dx > 0) ? Action.MOVE_EAST : Action.MOVE_WEST;
  }

  if (this.getActionValidity(alternate)) {
    return alternate;
  }

  return wander();
}

}
