//speed and rotation
float rotateX = 0;
float rotateZ = 0;
float speed = 1;
//previous mouse position
float prevMouseX = mouseX;
float prevMouseY = mouseY;

class Board {
  int boardSizeX;
  int boardSizeY;
  int boardSizeZ;
  color boardColor;

  Board(int sizeX, int sizeY, int sizeZ) {
    boardSizeX = sizeX;
    boardSizeY = sizeY;
    boardSizeZ = sizeZ;
    boardColor = color(0, 255, 0);
  }

  void display() {
    translate(width / 2, height / 2, 0);
    rotateX(rotateX);
    rotateZ(rotateZ);
    fill(boardColor);
    box(boardSizeX, boardSizeY, boardSizeZ);
  }

  //board movements
  void move() {
    //rotation around x axis
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

  //change speed (min: 0.2, max: 1.5
  void changeSpeed(MouseEvent e) {
    float wheelValue = e.getCount();
    float x = (wheelValue < 0) ? speed * 1.1 : speed * 0.9;
    speed = clamp(x, 0.2, 1.5);
  }
}