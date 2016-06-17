/* EXTRA: plays sound when bouncing */
/*
import processing.sound.*;
SoundFile sound;
//*/

//applets
EdgeDetection edgeDetection;

//objects
Board board;
Ball ball;
Cylinder cylinder;
ArrayList<PVector> cylinderPositions;
Score score;

//mode
Mode mode;
PlayMode play;
EditMode cylinders;

//constants
float gravityConstant;

void settings() {
  size(800, 900, P3D);
}

void setup() {
  edgeDetection = new EdgeDetection();
  String []args = {"Image processing window"};
  PApplet.runSketch(args, edgeDetection);
  
  cylinders = new EditMode();
  play = new PlayMode();
  mode = play;
  
  gravityConstant = 1.1;
  /* EXTRA */
  /*
  sound = new SoundFile(this, "boing.mp3");
  //*/
}

void draw() {
  //directionalLight(50, 100, 125, 0, 0, -1200);
  //ambientLight(255, 255, 255);//102
  directionalLight(229, 255, 204, 0, 1, -1);
  background(200, 200, 200);
  
  translate(width / 2, height / 2 - board.sizeY / 2, 0);
  
  mode.display();
  score.display();
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