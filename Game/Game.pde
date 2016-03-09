float depth = 1000;
int plateSize = 500;
float speed = 1;

void settings() {
  size(500, 500, P3D);
}

void setup() {
  noStroke();
}

void draw() {
  camera(width/2, 0, depth, 250, 250, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, 1, 0);
  ambientLight(102, 102, 102);
  background(200);
  translate(width/2, height/2, 0);
  float rz = map(mouseX, 0, height, -PI/3 * speed, PI/3 * speed);
  float rx = map(mouseY, 0, width, PI/3 * speed, -PI/3 * speed);
  rz = map(rz, 0, height, -PI/3, PI/3);
  rx = map(rx, 0, width, PI/3, -PI/3);
  rotateZ(rz);
  rotateX(rx);
  fill(0, 255, 0);
  box(plateSize, 10, plateSize);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      depth -= 50;
    } else if (keyCode == DOWN) {
      depth += 50;
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  speed = e*100;
}