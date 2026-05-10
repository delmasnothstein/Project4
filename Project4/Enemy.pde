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

  int DETECTION_RANGE = 4;

  Position pos = scene.getPosition(this);
  Position playerPos = scene.getPosition(scene.getPlayer());

  if (pos == null || playerPos == null) {
    Action a = Action.MOVE_NORTH;
    updateFacing(a);
    return a;
  }

  int dist = manhattanDistance(pos, playerPos);

  Action chosen;

if (dist == 1) {
  chosen = attackPlayer(pos, playerPos);
}
else if (dist <= DETECTION_RANGE) {
  chosen = chase(pos, playerPos);
}
else {
  chosen = wander();
}

// SAFETY CHECK
if (chosen == null) {
  chosen = Action.MOVE_SOUTH; // or any default safe move
}

updateFacing(chosen);
return chosen;
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

  // try several random moves
  for (int i = 0; i < 10; i++) {
    Action a = options[int(random(options.length))];
    if (this.getActionValidity(a)) {
      return a;
    }
  }

  // default movement
  return Action.MOVE_SOUTH;
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

  private void updateFacing(Action action) {

  if (action == null) return;

  switch (action) {
    case MOVE_NORTH:
    case ATTACK_NORTH:
      facing = Direction.NORTH;
      break;

    case MOVE_SOUTH:
    case ATTACK_SOUTH:
      facing = Direction.SOUTH;
      break;

    case MOVE_EAST:
    case ATTACK_EAST:
      facing = Direction.EAST;
      break;

    case MOVE_WEST:
    case ATTACK_WEST:
      facing = Direction.WEST;
      break;
  }
}


private Action attackPlayer(Position pos, Position playerPos) {

  int dx = playerPos.getX() - pos.getX();
  int dy = playerPos.getY() - pos.getY();

  if (dx == 1)  return Action.ATTACK_EAST;
  if (dx == -1) return Action.ATTACK_WEST;
  if (dy == 1)  return Action.ATTACK_SOUTH;
  if (dy == -1) return Action.ATTACK_NORTH;

  return null;
}

}
