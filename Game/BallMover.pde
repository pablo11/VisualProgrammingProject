class BallMover {
  PVector location;
  PVector velocity;
  PVector gravity;
  int ballRadius;
  float gravityConstant = 1.1;

  BallMover() {
    ballRadius = 15;
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 1, 0);
  }

  void update() {
    gravity.x = sin(rotateZ) * gravityConstant;
    gravity.z = -sin(rotateX) * gravityConstant;
  
  velocity.add(gravity);
    velocity.add(friction());
    checkEdges();
    location.add(velocity);
  }
  
  void checkEdges() {
    /*if ((location.x >= board.boardSizeX / 2) || (location.x <= -board.boardSizeX / 2)) {
      velocity.x = velocity.x * -1;
      sound.play();
      */
      if (location.x > board.boardSizeX / 2) {
        location.x = board.boardSizeX / 2;
        velocity.x = velocity.x * -1;
      } else if (location.x < -board.boardSizeX / 2) {
        location.x = -board.boardSizeX / 2;
        velocity.x = velocity.x * -1;
      }
    /*  
    }
    if ((location.z >= board.boardSizeZ / 2) || (location.z <= -board.boardSizeZ / 2)) {
      velocity.z = velocity.z * -1;
      sound.play();
      */
      if (location.z > board.boardSizeZ / 2) {
        location.z = board.boardSizeZ / 2;
        velocity.z = velocity.z * -1;
      } else if (location.z < -board.boardSizeZ / 2) {
        location.z = -board.boardSizeZ / 2;
        velocity.z = velocity.z * -1;
      }
      
    //}
  }

  void display() {
    fill(255, 255, 255);
    pushMatrix();
    translate(location.x, -(ballRadius + board.boardSizeY / 2), location.z);
    sphere(ballRadius);
    popMatrix();
    update();
  }

  PVector friction() {
    float normalForce = 1;
    float mu = 1;
    float frictionMagnitude = normalForce * mu;
    PVector friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    return friction.mult(frictionMagnitude);
  }
}