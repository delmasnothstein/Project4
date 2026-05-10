/**
 *      Authors: Prof. Morales, Delmas Nothstein, Nathan Lafayette, Claire Kolovich
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

  Bandage(Scene scene) {
    this.scene = scene;
  }

  @Override
  public boolean interact(Player player) {
    if (used) return false;

    player.updateHealth(50); // heal amount
    used = true;

    // remove from world
    Position pos = scene.positions.get(this);
    if (pos != null) {
      scene.room[pos.getX()][pos.getY()] = null;
      scene.positions.remove(this);
    }

    return true;
  }

  @Override
  public JSONObject serialize() {
    return new JSONObject();
  }

  @Override
  public void draw() {
    // not used (Scene handles rendering)
  }
}
