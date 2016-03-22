import processing.sound.*;
SoundFile sound;

Board board;
BallMover ball;

float gravityConstant;

void settings() {
  size(800, 800, P3D);
}

void setup() {
  noStroke();
  
  sound = new SoundFile(this, "boing.mp3");
  
  board = new Board(400, 10, 400);
  ball = new BallMover();
  
  gravityConstant = 1.1;
}

void draw() {
  
  
  //set camera and light position and direction
  camera(width/2, 0, 500, 400, 400, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, 1, 0);
  ambientLight(102, 102, 102);
  background(200, 200, 200);
  
  pushMatrix();
  translate(0, -1, 0);
  stroke(0, 0, 0);
  textSize(20);
  text("speed: " + speed, 120, 100, 0);
  popMatrix();
  noStroke();
  
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