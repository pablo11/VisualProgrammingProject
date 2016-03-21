/*
import processing.sound.*;
SoundFile sound;
*/

Board board;
BallMover ball;

void settings() {
  size(800, 800, P3D);
}

void setup() {
  noStroke();
  board = new Board(400, 10, 400);
  ball = new BallMover();
  
  //sound = new SoundFile(this, "boing.mp3");
}

void draw() {
  //set camera and light position and direction
  camera(width/2, 0, 500, 400, 400, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, 1, 0);
  ambientLight(102, 102, 102);
  background(200, 200, 200);
  // movements
  board.display();
  ball.display();
}

void mouseDragged() {
  board.move();
}

void mouseWheel(MouseEvent event) {
  board.changeSpeed(event);
}