/**
 *     Authors: Prof. Morales, Delmas Nothstein, Nathan Lafayette
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Obstacle.pde
 * Description: Obstacles that restrict movement and cannot be interacted with
 */

class Obstacle extends WorldObject {

/**
 *      Method: serialize()
 *  Parameters: void
 *      Return: JSONObject - JSON representation of the Obstacle object
 * Description: Converts the Obstacle into a JSON object for potential
 *              saving and loading of game state.
 */
  public JSONObject serialize() {
    JSONObject obj = new JSONObject();
    obj.setString("className", "Obstacle");
    return obj;
  }

/**
 *      Method: draw()
 *  Parameters: void
 *      Return: void
 * Description: Placeholder method required by WorldObject.
 *              Obstacles are rendered by the Scene class instead,
 *              so this method is intentionally left empty.
 */
  @Override
  public void draw() {

    //handled in Scene.pde
  }
}
