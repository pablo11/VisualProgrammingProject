class Ball {
  PVector position;
  PVector velocity;
  PVector gravity;
  float ballRadius;

  Ball() {
    ballRadius = 15;
    position = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 1, 0);
  }

  void update() {
    gravity.x = sin(rotateZ) * gravityConstant;
    gravity.y = 0;
    gravity.z = -sin(rotateX) * gravityConstant;

    velocity.add(gravity);
    velocity.add(friction());
    position.add(velocity);

    checkEdges();
    checkCylinderCollision();
  }

  void checkEdges() {      
    if (position.x > board.boardSizeX / 2) {
      position.x = board.boardSizeX / 2;
      velocity.x = velocity.x * -1;
      sound.play();
    } else if (position.x < -board.boardSizeX / 2) {
      position.x = -board.boardSizeX / 2;
      velocity.x = velocity.x * -1;
      sound.play();
    }

    if (position.z > board.boardSizeZ / 2) {
      position.z = board.boardSizeZ / 2;
      velocity.z = velocity.z * -1;
      sound.play();
    } else if (position.z < -board.boardSizeZ / 2) {
      position.z = -board.boardSizeZ / 2;
      velocity.z = velocity.z * -1;
      //if velocity to small don't pay sound
      sound.play();
    }
  }

  void display() {
    noStroke();
    fill(255, 255, 255);
    pushMatrix();
    translate(position.x, -(ballRadius + board.boardSizeY / 2), position.z);
    sphere(ballRadius);
    popMatrix();
    update();
  }

  PVector friction() {
    float normalForce = 1;
    float mu = 0.2;
    float frictionMagnitude = normalForce * mu;
    PVector friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    return friction.mult(frictionMagnitude);
  }

  void checkCylinderCollision() {
    float collisionTreshold = 10;
    float collision = ballRadius + cylinder.radius;
    for (PVector cylPos : cylinderPositions) {
      float distX = position.x - cylPos.x;
      if (abs(distX) - collision < collisionTreshold) {
        float distY = position.y - cylPos.y;
        if (abs(distY) - collision < collisionTreshold) {
          PVector n = new PVector(distX, distY);
          n.normalize();
          velocity = velocity.sub(n.mult((velocity.dot(n))).mult(2));
        }
      }
    }
  }
}