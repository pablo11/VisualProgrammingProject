abstract class Mode {
  Mode() {
  }

  void display() {
  }

  void mouseClicked() {
  }
  
  void mouseWheel(MouseEvent event) {
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
  
  void mouseWheel(MouseEvent event) {
    board.changeSpeed(event);
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
    
    //piazzamento cilindri spostato dovuto al fatto che mouseX è preso a y=0
    
    pushMatrix();
    float x = clamp(mouseX - width / 2, -board.boardSizeX / 2 + cylinder.radius, board.boardSizeX / 2 - cylinder.radius);
    float z = clamp(mouseY - height / 2, -board.boardSizeZ / 2 + cylinder.radius, board.boardSizeZ / 2 - cylinder.radius);
    cylinder.display(x, z);
    popMatrix();
    
    for (PVector position : cylinderPositions) {
      pushMatrix();
      cylinder.display(position.x, position.y);
      popMatrix();
    }
  }

  void mouseClicked() {
    pushMatrix();
    float x = clamp(mouseX - width / 2, -board.boardSizeX / 2 + cylinder.radius, board.boardSizeX / 2 - cylinder.radius);
    float z = clamp(mouseY - height / 2, -board.boardSizeZ / 2 + cylinder.radius, board.boardSizeZ / 2 - cylinder.radius);
    cylinderPositions.add(new PVector(x, z));
    popMatrix();
  }
  
  void mouseWheel(MouseEvent event) {
  }
}