/* EXTRA: plays sound when bouncing */
/*
import processing.sound.*;
SoundFile sound;
//*/

//objects
Board board;
Ball ball;
Cylinder cylinder;
ArrayList<PVector> cylinderPositions;

//mode
Mode mode;
PlayMode play;
PositionCylindersMode cylinders;

//constants
float gravityConstant;

void settings() {
  size(800, 800, P3D);
}

void setup() {
  cylinders = new PositionCylindersMode();
  play = new PlayMode();
  mode = play;
  
  gravityConstant = 1.1;
  /* EXTRA */
  /*
  sound = new SoundFile(this, "boing.mp3");
  //*/
}

void draw() {
  //set camera and light position and direction
  camera(width/2, 0, width/2 + 100, 400, 400, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, 1, 0);
  ambientLight(102, 102, 102);
  background(200, 200, 200);
  
  translate(0, -board.boardSizeY / 2, 0);
  
  mode.display();
}

void mouseDragged() {
  mode.mouseDragged();
}

void mouseWheel(MouseEvent event) {
  mode.mouseWheel(event);
}

void mouseClicked() {
  mode.mouseClicked();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      mode = cylinders;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      mode = play;
    }
  }
}