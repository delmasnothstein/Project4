/**
 *     Authors: Prof. Morales, Delmas Nothstein, Nathan Lafayette, Claire Kolovich
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Obstacle.pde
 * Description: Obstacles that restrict movement and cannot be interacted with
 */

class Obstacle extends WorldObject {

  public JSONObject serialize() {
    JSONObject obj = new JSONObject();
    obj.setString("className", "Obstacle");
    return obj;
  }

  @Override
  public void draw() {

    //empty for now
  }
}
