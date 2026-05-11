/**
 *     Authors: Prof. Morales, Delmas Nothstein, Nathan Lafayette
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

/**
 *      Method: Enemy(Scene scene, Direction direction)
 *  Parameters: Scene scene - The game scene the enemy exists within
 *              Direction direction - The initial facing direction of the enemy
 *      Return: Constructor (no return type)
 * Description: Creates an enemy actor with default health and damage values,
 *              and assigns it a reference to the current game scene.
 */
  Enemy(Scene scene, Direction direction) {
  super(100, 25, direction);   // health, damage, facing
  this.scene = scene;
}

/**
 *      Method: getAction()
 *  Parameters: void
 *      Return: Action - The next action the enemy will perform
 * Description: Determines the enemy's next move based on the player's
 *              distance. The enemy will attack if adjacent, chase if
 *              within detection range, or wander randomly otherwise.
 */
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

/**
 *      Method: draw()
 *  Parameters: void
 *      Return: void
 * Description: Required override from WorldObject.
 *              Enemy rendering is handled externally in Scene,
 *              so this method is intentionally empty.
 */
  @Override
  public void draw() {
    // required by WorldObject, not used
  }

/**
 *      Method: render(float x, float y, float size)
 *  Parameters: float x - Screen x-position to draw the enemy
 *              float y - Screen y-position to draw the enemy
 *              float size - Size of the grid cell for scaling
 *      Return: void
 * Description: Visually renders the enemy as a red square with a
 *              directional indicator showing its current facing direction.
 */
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
  
  /**
 *      Method: wander()
 *  Parameters: void
 *      Return: Action - A random valid movement action
 * Description: Attempts to select a random valid movement direction.
 *              If no valid moves are found after several attempts,
 *              defaults to moving south.
 */
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

/**
 *      Method: chase(Position pos, Position playerPos)
 *  Parameters: Position pos - Current position of the enemy
 *              Position playerPos - Current position of the player
 *      Return: Action - A movement action toward the player
 * Description: Determines the best movement direction to approach
 *              the player. Attempts primary axis movement first,
 *              then falls back to an alternate direction or wandering.
 */
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

/**
 *      Method: updateFacing(Action action)
 *  Parameters: Action action - The action used to determine facing direction
 *      Return: void
 * Description: Updates the enemy's facing direction based on the
 *              direction of movement or attack action.
 */
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

/**
 *      Method: manhattanDistance(Position a, Position b)
 *  Parameters: Position a - First position
 *              Position b - Second position
 *      Return: int - The Manhattan distance between two positions
 * Description: Calculates grid-based distance between two points
 *              using only horizontal and vertical movement.
 */
  private int manhattanDistance(Position a, Position b) { //I wrote this a few days ago and I cannot remember where I learned it from, I'm sorry -Del
  return abs(a.getX() - b.getX()) + abs(a.getY() - b.getY());
}


/**
 *      Method: attackPlayer(Position pos, Position playerPos)
 *  Parameters: Position pos - Enemy position
 *              Position playerPos - Player position
 *      Return: Action - Attack action toward the player, or null if invalid
 * Description: Determines the correct attack direction when the player
 *              is directly adjacent to the enemy.
 */
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
