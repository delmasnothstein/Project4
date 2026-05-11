/**
 *     Authors: Prof. Morales, Delmas Nothstein Nathan Lafayette
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Door.pde
 * Description: When the player interacts with a door, a new room will be reached
 */
class Door extends WorldObject {

  public JSONObject serialize() {
    JSONObject obj = new JSONObject();
    obj.setString("className", "Door");
    return obj;
  }

  @Override
  public void draw() {

    //handled in Scene.pde, still needed
  }
}
