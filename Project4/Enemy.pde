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

  Action action = null;

  switch (this.facing) {
    case NORTH: action = Action.MOVE_NORTH; break;
    case SOUTH: action = Action.MOVE_SOUTH; break;
    case EAST:  action = Action.MOVE_EAST;  break;
    case WEST:  action = Action.MOVE_WEST;  break;
  }

  if (random(1) < 0.2) {
    Direction[] dirs = Direction.values();
    this.facing = dirs[int(random(dirs.length))];
    return null;
  }

  return action;
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
