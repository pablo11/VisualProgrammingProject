//speed and rotation
float rotateX = 0;
float rotateZ = 0;
float speed = 1;
//previous mouse position
float prevMouseX = mouseX;
float prevMouseY = mouseY;

void settings() {
  size(800, 800, P3D);
}

void setup() {
  noStroke();
}

void draw() {
  //set camera and light position and direction
  camera(width/2, 0, 500, 400, 400, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, 1, 0);
  ambientLight(102, 102, 102);
  background(200, 200, 200);
  // movements
  translate(width / 2, height / 2, 0);
  rotateX(rotateX);
  rotateZ(rotateZ);
  //draw box
  fill(0, 255, 0);
  box(400, 10, 400);
}

void mouseDragged() {
  float pi3 = PI / 3;
  
  if (prevMouseX > mouseX && rotateZ >= -pi3) {
    rotateZ -= max((PI / 60) * speed, -pi3);
  } else if (prevMouseX < mouseX && rotateZ <= pi3) {
    rotateZ += min((PI / 60) * speed, pi3);
  }
  prevMouseX = mouseX;
  
  if (prevMouseY < mouseY && rotateX >= -pi3) {
    rotateX -= max((PI / 60) * speed, -pi3);
  } else if (prevMouseY > mouseY && rotateX <= pi3) {
    rotateX += min((PI / 60) * speed, pi3);
  }
  prevMouseY = mouseY;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  float x = (e < 0) ? speed * 1.1 : speed * 0.9;
  speed = clamp(x, 0.2, 1.5);
}

//clamp constraints value to a minimum and maximum value
float clamp(float value, float min, float max) {
  if (value > max) return max;
  else if (value < min) return min;
  else return value;
}