import processing.sound.*;
SoundFile music;
SoundFile attackSound;
SoundFile enemyDeath;
SoundFile healSound;
SoundFile stairClimb;

/**
 *      Authors: Prof. Morales, Delmas Nothstein, Nathan Lafayette, Claire Kolovich
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Project4.pde
 * Description: A dungeon crawler game
 */

Scene scene;
String fileName;

/**
 *      Method: setup()
 *  Parameters: void
 *      Return: void
 * Description: Constructs a scene from JSON
 *              save data or in a random state
 */

void setup() {
  music = new SoundFile(this, "Ancient Mystery Waltz Vivace.mp3");
  attackSound = new SoundFile(this, "roblox sword swing.mp3");
  enemyDeath = new SoundFile(this, "happy wheels limb rip.mp3");
  healSound = new SoundFile(this, "heal.mp3");
  stairClimb = new SoundFile(this, "stairs.mp3");
  music.loop();
  music.amp(0.3);
  fullScreen(P2D);
  pixelDensity(1);
  fileName = sketchPath("data/save.json");
  File file = new File(fileName);

  if (file.exists()) {
    JSONObject data = loadJSONObject(fileName);
    scene = new Scene(data);
  } else {
    scene = new Scene();
    JSONObject data = scene.serialize();
    file.getParentFile().mkdirs();
    saveJSONObject(data, fileName);
  }
}

/**
 *      Method: draw()
 *  Parameters: void
 *      Return: void
 * Description: Draws the scene and all objects
 *              within it, additionally performing
 *              logic for the main game loop
 */

void draw() {
  background(0);

  if (scene.tryTurn()) {
    // Save the state of the scene
    saveJSONObject(scene.serialize(), fileName);
  }

  scene.draw();
}

/**
 *      Method: keyPressed()
 *  Parameters: void
 *      Return: void
 * Description: Passes key press events to the scene
 */

void keyPressed() {
  scene.keyPressed();
}

/**
 *      Method: keyReleased()
 *  Parameters: void
 *      Return: void
 * Description: Passes key release events to the scene
 */

void keyReleased() {
  scene.keyReleased();
}
