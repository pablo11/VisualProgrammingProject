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
       
    pushMatrix();
    PVector mousePosition = getMousePosition();
    cylinder.display(mousePosition.x, mousePosition.z);
    popMatrix();
    
    for (PVector position : cylinderPositions) {
      pushMatrix();
      cylinder.display(position.x, position.z);
      popMatrix();
    }
    
  }
  
  void mouseDragged() {}
  
  void mouseWheel(MouseEvent event) {}

  void mouseClicked() {
    PVector mousePosition = getMousePosition();
    
    //check if cylinder ovelaps with others and position it only if not
    boolean overlap = false;
    for (PVector cylPos : cylinderPositions) {
      if (PVector.dist(cylPos, mousePosition) < 2 * cylinder.radius) {
        overlap = true;
      }
    }
    if (!overlap) {
      cylinderPositions.add(mousePosition);
    }
  }
  
  private PVector getMousePosition() {
    float x = clamp(mouseX - width / 2, -board.boardSizeX / 2 + cylinder.radius, board.boardSizeX / 2 - cylinder.radius);
    float z = clamp(mouseY - height / 2, -board.boardSizeZ / 2 + cylinder.radius, board.boardSizeZ / 2 - cylinder.radius);
    return new PVector(x, 0, z);
  }
}