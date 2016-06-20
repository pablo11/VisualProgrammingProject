abstract class Mode {
  abstract void display();
  void mouseDragged() {}
  void mouseWheel(MouseEvent event) {}
  void mouseClicked() {}
}

//======== PlayMode ===========================================================

class PlayMode extends Mode {
  PlayMode() {
    board = new Board(400, 10, 400);
    ball = new Ball();
    score = new Score();
  }

  void display() {    
    // movements
    pushMatrix();
    board.display(true);
    ball.display();
    
    //draw all cylinders
    for (PVector position : cylinderPositions) {
      pushMatrix();
      cylinder.display(position.x, position.z);
      popMatrix();
    }
    popMatrix();
    
    //PVector rotation = edgeDetection.rotation;
    
    //board.moveWithWebcam(rotation);

    score.recordPoints();
  }

  void mouseDragged() {
    /*
    if (mouseY < height - score.background.height) {
      board.move();
    }
    */
  }

  void mouseWheel(MouseEvent event) {
    board.changeSpeed(event);
  }

  void mouseClicked() {
  }
}

//======== EditMode ===========================================================

class EditMode extends Mode {
  EditMode() {
    cylinder = new Cylinder(20, 50, 40);
    cylinderPositions = new ArrayList<PVector>();
  }

  void display() {
    pushMatrix();
    rotateX(-PI/2);
    
    board.display(false);
    
    PVector mousePosition = getMousePosition();
    if (checkOverlap(mousePosition)) {
      cylinder.colour = color(255, 0, 0);
    } else {
      cylinder.colour = color(180);
    }
    cylinder.display(mousePosition.x, mousePosition.z);
    
    for (PVector position : cylinderPositions) {
      cylinder.colour = color(180);
      cylinder.display(position.x, position.z);
    }
    
    popMatrix();
  }
  
  boolean checkOverlap(PVector position) {
    for (PVector cylPos : cylinderPositions) {
      if (PVector.dist(cylPos, position) < 2 * cylinder.radius) {
        return true;
      }
    }
    return false;
  }
  
  void mouseDragged() {}
  
  void mouseWheel(MouseEvent event) {}

  void mouseClicked() {
    PVector mousePosition = getMousePosition();
        
    if (!cylinderOverlaps(mousePosition)) {
      cylinderPositions.add(mousePosition);
    }
  }
  
  private PVector getMousePosition() {
    float x = clamp(mouseX - width / 2, -board.sizeX / 2 + cylinder.radius, board.sizeX / 2 - cylinder.radius);
    float z = clamp(mouseY - height / 2, -board.sizeZ / 2 + cylinder.radius, board.sizeZ / 2 - cylinder.radius);
    return new PVector(x, 0, z);
  }
  
  //check if cylinder ovelaps with others and position it only if not
  private Boolean cylinderOverlaps(PVector center) {
    boolean overlap = false;
    for (PVector cylPos : cylinderPositions) {
      if (PVector.dist(cylPos, center) < 2 * cylinder.radius) {
        overlap = true;
      }
    }
    return overlap;
  }
}