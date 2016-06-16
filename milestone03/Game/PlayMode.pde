class PlayMode extends Mode {
  PlayMode() {
    board = new Board(400, 10, 400);
    ball = new Ball();
    score = new Score();
  }

  void display() {    
    // movements
    pushMatrix();
    translate(0, -200, 0);
    board.display(true);
    ball.display();
    
    //draw all cylinders
    for (PVector position : cylinderPositions) {
      pushMatrix();
      cylinder.display(position.x, position.z);
      popMatrix();
    }
    popMatrix();

    //display score
    score.display();
    score.recordPoints();
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