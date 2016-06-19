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