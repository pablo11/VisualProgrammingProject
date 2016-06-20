import processing.video.*;

EdgeDetection edgeDetection;

//video
Movie mov;

//webcam
Capture cam;

//set to true for webcam use, false for video
Boolean isWebcam = false;

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
  size(1200, 900, P3D);
}

void setup() {
  //Webcam
  if (isWebcam) {
    String[] cameras = Capture.list();
    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      cam = new Capture(this, cameras[0]);
      cam.start();
    }
  } else { //video
    mov = new Movie(this, "testvideo.mp4");
    mov.loop();
  }

  edgeDetection = new EdgeDetection();
  edges = createGraphics(320, 480, P2D);

  cylinders = new EditMode();
  play = new PlayMode();
  mode = play;

  gravityConstant = 1.1;
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

  //for webcam
  if (isWebcam) {
    if (cam.available() == true) {
      cam.read();
    }
    edgeDetection.display(cam.get());
  } else { // video
    edgeDetection.display(mov.get());
  }

  edges.endDraw();
  image(edges, width-edges.width, 0);
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