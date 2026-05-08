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

  public Enemy(Direction facing) {
  super(50, 5, facing); // example: weaker than player
  this.facing = facing;
}
  
    @Override
public Action getAction() {

  Action forward;

  switch (this.facing) {
    case NORTH: forward = Action.MOVE_NORTH; break;
    case SOUTH: forward = Action.MOVE_SOUTH; break;
    case EAST:  forward = Action.MOVE_EAST;  break;
    case WEST:  forward = Action.MOVE_WEST;  break;
    default:     forward = Action.MOVE_NORTH; break;
  }

  // If blocked, change direction immediately
  if (!this.getActionValidity(forward)) {
    Direction[] dirs = Direction.values();
    this.facing = dirs[int(random(dirs.length))];

    switch (this.facing) {
      case NORTH: return Action.MOVE_NORTH;
      case SOUTH: return Action.MOVE_SOUTH;
      case EAST:  return Action.MOVE_EAST;
      case WEST:  return Action.MOVE_WEST;
    }
  }

  // occasional random turn
  if (random(1) < 0.1) {
    Direction[] dirs = Direction.values();
    this.facing = dirs[int(random(dirs.length))];
  }

  return forward;
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
}
