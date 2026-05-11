/**
 *      Authors: Prof. Morales, Delmas Nothstein, Nathan Lafayette
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Bandage.pde
 * Description: Bandages that heal the player when consumed
 */

class Bandage extends Interactable {

  private Scene scene;
  private boolean used = false;

/**
 *      Method: Bandage(Scene scene)
 *  Parameters: Scene scene - The game scene that the bandage exists within
 *      Return: Constructor (no return type)
 * Description: Creates a bandage item and stores a reference to the scene
 *              so it can remove itself after being consumed.
 */
  Bandage(Scene scene) {
    this.scene = scene;
  }

/**
 *      Method: interact(Player player)
 *  Parameters: Player player - The player interacting with the bandage
 *      Return: boolean - Whether the interaction was successful
 * Description: Heals the player if the bandage has not already been used.
 *              Plays a healing sound, marks the bandage as used, and
 *              removes it from the scene so it cannot be reused.
 */
  @Override
  public boolean interact(Player player) {
    if (used) return false;

    player.updateHealth(50); // heal amount
    healSound.play();
    used = true;

    // remove from world
    Position pos = scene.positions.get(this);
    if (pos != null) {
      scene.room[pos.getX()][pos.getY()] = null;
      scene.positions.remove(this);
    }

    return true;
  }

/**
 *      Method: serialize()
 *  Parameters: void
 *      Return: JSONObject - A JSON representation of the bandage
 * Description: Returns a serialized representation of the bandage.
 *              Currently unused for state saving.
 */
  @Override
  public JSONObject serialize() { //COULD NOT GET SAVES TO PROPERLY WORK ON TIME
    return new JSONObject();
  }

/**
 *      Method: draw()
 *  Parameters: void
 *      Return: void
 * Description: Placeholder draw method.
 *              Rendering is handled by the Scene class instead of
 *              individual world objects.
 */
  @Override
  public void draw() {
    // not used (Scene handles rendering)
  }
}
