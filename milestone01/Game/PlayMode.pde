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
      cylinder.display(position.x, position.z);
      popMatrix();
    }
  }
  
  void mouseDragged() {
    board.move();
  }
  
  void mouseWheel(MouseEvent event) {
    board.changeSpeed(event);
  }

  void mouseClicked() {
  }
}