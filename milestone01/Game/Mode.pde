abstract class Mode {
  Mode() {
  }

  void display() {
  }

  void mouseClicked() {
  }
}

class PlayMode extends Mode {
  PlayMode() {
    board = new Board(400, 10, 400);
    ball = new Ball();
  }

  void display() {
    // movements
    board.display(true);
    ball.display();

    //draw all cylinders
    for (PVector position : cylinderPositions) {
      pushMatrix();
      cylinder.display(position.x, position.y);
      popMatrix();
    }
  }

  void mouseClicked() {
  }
}

class PositionCylindersMode extends Mode {
  float lastX;
  float lastY;

  PositionCylindersMode() {
    cylinder = new Cylinder(20, 50, 40);
    cylinderPositions = new ArrayList<PVector>();

    lastX = 0;
    lastY = 0;
  }

  void display() {
    board.display(false);
        
    for (PVector position : cylinderPositions) {
      pushMatrix();
      cylinder.display(position.x, position.y);
      popMatrix();
    }
  }

  void mouseClicked() {
    pushMatrix();
    float x = mouseX - width/2;
    float z = mouseY - height/2;
    cylinderPositions.add(new PVector(x, z));
    popMatrix();
  }
}