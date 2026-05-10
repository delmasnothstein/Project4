/**
 *      Authors: Prof. Morales, Delmas Nothstein, Nathan Lafayette, Claire Kolovich
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Scene.pde
 * Description: The game scene that handles each room
 *              and all objects within those rooms,
 *              including the player and enemies
 */

import java.util.LinkedList;

class Scene {
  private int roomWidth;
  private int roomHeight;
  public Scene() {

  this.roomWidth = 20;
  this.roomHeight = 15;

  this.room = new WorldObject[roomWidth][roomHeight];

  this.enemies = new LinkedList<Actor>();
  this.positions = new HashMap<WorldObject, Position>();
  this.doors = new HashMap<Direction, Position>();
}
  public Scene(JSONObject data) { //ALL TEMPORARY, UPDATE LATER
  this.roomWidth = 20;
  this.roomHeight = 15;

  this.room = new WorldObject[roomWidth][roomHeight];
  this.enemies = new LinkedList<Actor>();
  this.positions = new HashMap<WorldObject, Position>();
  this.doors = new HashMap<Direction, Position>();
}
  private JSONObject serialize() {
  return new JSONObject(); //UPDATE LATER
}
private WorldObject[][] room;
  private Direction entry;
  private Player player;
  private LinkedList<Actor> enemies;
  private HashMap<WorldObject, Position> positions;
  private HashMap<Direction, Position> doors;

  /**
   *      Method: private reset()
   *  Parameters: Direction entry - The direction from which
   *                                the player entered the room
   *      Return: void
   * Description: Resets the room to a random state
   */

  private void reset(Direction entry) {
  this.entry = entry;

  if (entry == null) {
    return;
  }

  // reset first
  this.room = new WorldObject[roomWidth][roomHeight];
  this.positions.clear();
  this.enemies.clear();

  // spawn player
  if (this.player == null) {
    this.player = new Player(entry);
  }

  int px = roomWidth / 2;
  int py = roomHeight / 2;

  this.room[px][py] = this.player;
  this.positions.put(this.player, new Position(px, py, this));

  // spawn enemy AFTER grid exists
  int enemyCount = 3;

for (int i = 0; i < enemyCount; i++) {

  Enemy enemy = new Enemy(this, Direction.SOUTH);

  int ex, ey;

  // find empty tile
  do {
    ex = int(random(roomWidth));
    ey = int(random(roomHeight));
  }
  while (this.room[ex][ey] != null ||
       (abs(ex - px) <= 1 && abs(ey - py) <= 1));

  this.room[ex][ey] = enemy;
  this.positions.put(enemy, new Position(ex, ey, this));
  this.enemies.add(enemy);
}
  
  int obstacleCount = 20; // amount of obstacles in the room

  for (int i = 0; i < obstacleCount; i++) {

  int ox, oy;

    do {
    ox = int(random(roomWidth));
    oy = int(random(roomHeight));
    }
  while (this.room[ox][oy] != null);

  Obstacle obstacle = new Obstacle();

  this.room[ox][oy] = obstacle;
  this.positions.put(obstacle, new Position(ox, oy, this));

//DOOR CODE HERE//
int dx = int(random(roomWidth));
int dy = int(roomHeight);
Door door = new Door();
this.room[dx][dy] = door;
this.positions.put(door, new Position(dx,dy, this));
//DOOR CODE HERE//
  }

  Bandage heal = new Bandage(this);

int hx, hy;

do {
  hx = int(random(roomWidth));
  hy = int(random(roomHeight));
}
while (room[hx][hy] != null);

room[hx][hy] = heal;
positions.put(heal, new Position(hx, hy, this));

Bandage b = new Bandage(this);

}

  /**
   *      Method: private updateActions()
   *  Parameters: Actor actor - The actor whose actions will be
   *                            updated to reflect their validity
   *      Return: void
   * Description: Updates an actor's list of valid actions
   */

  private void updateActions(Actor actor) {
    for (Action action: Action.values()) {
      actor.setActionValidity(action, this.isActionValid(actor, action));
    }
  }

  /**
   *      Method: public tryTurn()
   *  Parameters: void
   *      Return: boolean - Whether or not the state of
   *                        the scene should be saved
   * Description: Tries to execute a single turn of game
   *              logic for the player and all enemies
   */

  public boolean tryTurn() {
    // If the player is dead, reset the room
    if (this.player == null || this.player.getHealth() == 0) {
      Direction[] directions = Direction.values();
      Direction direction = directions[int(random(directions.length))];
      this.player = new Player(direction);
      this.reset(direction);
    }

    // Update player valid actions FIRST
    this.updateActions(this.player);

    // Get the player's action
    Action action = this.player.getAction();

    // If no action was chosen, do nothing
    if (action == null) {
      return false;
    }

    // If the player attacked or entered a new room, save the game
    Position door = this.doors.get(action.direction);
    boolean save = action.isAttack || door != null && door.equals(this.positions.get(this.player)) && this.enemies.size() == 0;

    // If the action failed, do nothing
    if (!this.tryAction(this.player, action)) {
      return false;
    }

    for (int i = 0; i < this.enemies.size(); ++i) {

  Actor enemy = this.enemies.get(i);

  // remove dead enemies
  if (enemy.getHealth() <= 0) {

    Position pos = this.positions.get(enemy);

    if (pos != null) {
      this.room[pos.getX()][pos.getY()] = null;
    }

    this.positions.remove(enemy);
    this.enemies.remove(i--);

    continue;
  }

      // Get the enemy's action
      this.updateActions(enemy);
      action = enemy.getAction();

      if (this.tryAction(enemy, action) && action.isAttack) {
        // If the player died, reset the room and save the game
        if (player.getHealth() == 0) {
          Direction[] directions = Direction.values();
          Direction direction = directions[int(random(directions.length))];
          this.player = new Player(direction);
          this.reset(direction);
          return true;
        }

        // If the enemy attacked, save the game
        save = true;
      }
    }

    this.updateActions(this.player);
    return save;
  }

  /**
   *      Method: private tryAction()
   *  Parameters: Actor  actor  - The actor performing the action
   *              Action action - The action being performed
   *      Return: boolean - Whether or not the action succeeded
   * Description: Tries to execute an action on behalf of an actor
   */

  private boolean tryAction(Actor actor, Action action) {
    if (!isActionValid(actor, action)) {
      return false;
    }

    Position position = this.positions.get(actor);

    if (position == null) {
      return false;
    }

    // Get the position of the cell being targeted
    int x = position.getX() + action.direction.x;
    int y = position.getY() + action.direction.y;

    // Check if the player can enter a new room
    if (!action.isAttack && actor == this.player && action.direction != this.entry.inverse() && this.enemies.size() == 0) {
      Position door = this.doors.get(action.direction);

      if (door != null && door.equals(position)) {
        this.reset(action.direction);
        return true;
      }
    }

    // Check if the actor is facing a wall
    if (x < 0 || x >= this.roomWidth || y < 0 || y >= this.roomHeight) {
      return false;
    }

    // Check if the actor can attack
    if (action.isAttack) {
      boolean isActionValid = this.room[x][y] instanceof Actor && (actor == this.player || this.room[x][y] == this.player);

      if (isActionValid) {
        Actor enemy = (Actor)this.room[x][y];

        if (enemy.getHealth() > 0) {
          enemy.updateHealth(-actor.getDamage());
        } else {
          this.room[x][y] = null;
        }
      }

      return isActionValid;
    }

    // Check if the actor can interact with an interactable object
    if (actor == this.player && this.room[x][y] instanceof Interactable) {
      Interactable interactable = (Interactable)this.room[x][y];

      if (!interactable.interact(this.player)) {
        return false;
      }
    } else if (this.room[x][y] != null) {
      return false;
    }

    // Check if the actor can move
    this.room[x][y] = actor;
    this.room[position.getX()][position.getY()] = null;
    position.move(action.direction);
    return true;
  }

  /**
   *      Method: private isActionValid()
   *  Parameters: Actor  actor  - The actor performing the action
   *              Action action - The action being performed
   *      Return: boolean - Whether or not the action is valid
   * Description: Determines if an actor's action would be valid
   */

  private boolean isActionValid(Actor actor, Action action) {
    if (actor == null || action == null || actor.getHealth() == 0) {
      return false;
    }

    Position position = this.positions.get(actor);

    if (position == null) {
      return false;
    }

    // Get the position of the cell being targeted
    int x = position.getX() + action.direction.x;
    int y = position.getY() + action.direction.y;

    // Check if the player can enter a new room
    if (!action.isAttack && actor == this.player && action.direction != this.entry.inverse() && this.enemies.size() == 0) {
      Position door = this.doors.get(action.direction);

      if (door != null && door.equals(position)) {
        return true;
      }
    }

    // Check if the actor is facing a wall
    if (x < 0 || x >= this.roomWidth || y < 0 || y >= this.roomHeight) {
      return false;
    }

    // Check if the actor can attack
    if (action.isAttack) {
      return this.room[x][y] instanceof Actor && (actor == this.player || this.room[x][y] == this.player);
    }

    // Check if the actor can move
    return this.room[x][y] == null || this.room[x][y] instanceof Interactable && actor == this.player;
  }

  /**
   *      Method: public getRoomWidth()
   *  Parameters: void
   *      Return: int - The width of the room, in number of columns
   * Description: Returns the width of the room
   */

  public int getRoomWidth() {
    return roomWidth;
  }

  /**
   *      Method: public getRoomHeight()
   *  Parameters: void
   *      Return: int - The height of the room, in number of rows
   * Description: Returns the height of the room
   */

  public int getRoomHeight() {
    return roomHeight;
  }

  /**
   *      Method: public keyPressed()
   *  Parameters: void
   *      Return: void
   * Description: Passes key press events to the player
   */

  public void keyPressed() {
    if (this.player != null) {
      this.player.keyPressed();
    }
  }

  /**
   *      Method: public keyReleased()
   *  Parameters: void
   *      Return: void
   * Description: Passes key release events to the player
   */

  public void keyReleased() {
    if (this.player != null) {
      this.player.keyReleased();
    }
  }

  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the scene
   */

  public void draw() {
    //println("roomWidth:", roomWidth, "roomHeight:", roomHeight); //debug purposes
    // Determine the floor size
    float size = min((float)width / (this.roomWidth + 2), (float)height / (this.roomHeight + 2));

    
  background(40);

  float startX = (width - roomWidth * size) / 2;
  float startY = (height - roomHeight * size) / 2;

  stroke(255);
  fill(120);
  
  for (int x = 0; x < roomWidth; x++) {
    for (int y = 0; y < roomHeight; y++) {
      rect(startX + x * size,
           startY + y * size,
           size,
           size);
      }
    }
    
  for (WorldObject obj : positions.keySet()) {
    
    Position pos = positions.get(obj);
    
    float drawX = startX + pos.getX() * size;
    float drawY = startY + pos.getY() * size;
    
    if (obj instanceof Player) {
      Player p = (Player)obj;

     drawHealthBar(drawX, drawY, size, p);

      fill(0, 200, 0);
      rect(drawX, drawY, size, size);
      }
    else if (obj instanceof Enemy) {
      Enemy e = (Enemy)obj;

      drawHealthBar(drawX, drawY, size, e);

      e.render(drawX, drawY, size);
      }
      
      else if (obj instanceof Obstacle) {

  fill(200);
  stroke(255);

  triangle(
    drawX + size/2, drawY + size*0.2,
    drawX + size*0.2, drawY + size*0.8,
    drawX + size*0.8, drawY + size*0.8
  );
}

//DOOR CODE HERE
  else if (obj instanceof Door) {
fill(200,100,100);
triangle(
    drawX + size/2, drawY + size*0.2,
    drawX + size*0.2, drawY + size*0.8,
    drawX + size*0.8, drawY + size*0.8
  );
}
//DOOR CODE HERE



    else if (obj instanceof Bandage) {
  fill(100, 100, 255);
  stroke(255);

  float bandageSize = size * 0.5;

  float bx = drawX + (size - bandageSize) / 2;
  float by = drawY + (size - bandageSize) / 2;

  rect(bx, by, bandageSize, bandageSize);
}

    }
  }
  
  public Position getPosition(WorldObject obj) {
  return this.positions.get(obj);
  }
  
  public WorldObject getObjectAt(int x, int y) {
  return room[x][y];
}
public Player getPlayer() {
  return this.player;
}

public void removeObject(WorldObject obj) {

  Position pos = positions.get(obj);

  if (pos != null) {
    room[pos.getX()][pos.getY()] = null;
  }

  positions.remove(obj);
}

}

private void drawHealthBar(float x, float y, float size, Actor actor) {

  float ratio = actor.getHealth(); // already 0–1

  float barWidth = size;
  float barHeight = size * 0.12;

  // empty health
  fill(120, 0, 0);
  rect(x, y - barHeight - 2, barWidth, barHeight);

  // filled health
  fill(0, 220, 0);
  rect(x, y - barHeight - 2, barWidth * ratio, barHeight);
}
