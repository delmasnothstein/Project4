/**
 *      Author: Prof. Morales
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: WorldObject.pde
 * Description: When the player touches this, the room will be reset
 */
class Door extends WorldObject {

  public JSONObject serialize() {
    JSONObject obj = new JSONObject();
    obj.setString("className", "Door");
    return obj;
  }

  @Override
  public void draw() {

    //empty for now
  }
}
