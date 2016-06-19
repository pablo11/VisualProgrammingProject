import processing.video.*;
/* EXTRA: plays sound when bouncing */
/*
import processing.sound.*;
 SoundFile sound;
 //*/

//applets
EdgeDetection edgeDetection;

Movie mov;

PGraphics edges;

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
  size(1000, 900, P3D);
}

void setup() {
  mov = new Movie(this, "testvideo.mp4");
  mov.loop();
  
  edgeDetection = new EdgeDetection();
  edges = createGraphics(640, 2*480, P2D);

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
  directionalLight(229, 255, 204, 0, 1, -1);
  background(200, 200, 200);

  pushMatrix();
  translate(width / 2, height / 2 - board.sizeY / 2, 0);
  mode.display();
  popMatrix();
  
  score.display();
  
  edges.beginDraw();
  edges.background(0);
  edgeDetection.display(mov.get());
  edges.endDraw();
  image(edges, width - 640, 0);
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

void movieEvent(Movie m) {
  m.read();
}