class Board {
  int sizeX;
  int sizeY;
  int sizeZ;
  color colour;
  
  //speed and rotation
  float rotateX;
  float rotateZ;
  float speed;
  
  //previous mouse position
  float prevMouseX;
  float prevMouseY;

  Board(int boardSizeX, int boardSizeY, int boardSizeZ) {
    sizeX = boardSizeX;
    sizeY = boardSizeY;
    sizeZ = boardSizeZ;
    colour = color(0, 255, 0);
    
    rotateX = 0;
    rotateZ = 0;
    speed = 1;
    
    prevMouseX = mouseX;
    prevMouseY = mouseY;
  }

  void display(boolean mooving) {
    noStroke();
    if (mooving) {
      rotateX(rotateX);
      rotateZ(rotateZ);
    }
    fill(colour);
    box(sizeX, sizeY, sizeZ);
  }

  //board movements
  void move() {
    //rotation around z axis
    if (prevMouseX > mouseX && rotateZ >= -PI / 3) {
      rotateZ -= max((PI / 60) * speed, -PI / 3);
    } else if (prevMouseX < mouseX && rotateZ <= PI / 3) {
      rotateZ += min((PI / 60) * speed, PI / 3);
    }
    prevMouseX = mouseX;

    //rotation around x axis
    if (prevMouseY < mouseY && rotateX >= -PI / 3) {
      rotateX -= max((PI / 60) * speed, -PI / 3);
    } else if (prevMouseY > mouseY && rotateX <= PI / 3) {
      rotateX += min((PI / 60) * speed, PI / 3);
    }
    prevMouseY = mouseY;
  }

  //change speed (min: 0.2, max: 1.5)
  void changeSpeed(MouseEvent e) {
    float wheelValue = e.getCount();
    float x = (wheelValue < 0) ? speed * 1.1 : speed * 0.9;
    speed = clamp(x, 0.2, 1.5);
  }
}