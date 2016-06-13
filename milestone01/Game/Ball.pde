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
    gravity.x = sin(board.rotateZ) * gravityConstant;
    gravity.y = 0;
    gravity.z = -sin(board.rotateX) * gravityConstant;

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
      
      /* EXTRA */
      /*
      playSound(abs(velocity.x));
      //*/
    } else if (position.x < -board.boardSizeX / 2) {
      position.x = -board.boardSizeX / 2;
      velocity.x = velocity.x * -1;

      /* EXTRA */
      /*
      playSound(abs(velocity.x));
      //*/
    }

    if (position.z > board.boardSizeZ / 2) {
      position.z = board.boardSizeZ / 2;
      velocity.z = velocity.z * -1;
  
      /* EXTRA */
      /*
      playSound(abs(velocity.z));
      //*/
    } else if (position.z < -board.boardSizeZ / 2) {
      position.z = -board.boardSizeZ / 2;
      velocity.z = velocity.z * -1;
      
      /* EXTRA */
      /*
      playSound(abs(velocity.z));
      //*/
    }
  }
  
  /* EXTRA */
  /*
  //if velocity to small don't pay sound
  void playSound(float condition) {
    float soundTreshold = 2;
    float dumpCoefficent = 10;
    if (condition > soundTreshold) {
      sound.play();
      sound.amp(clamp(abs(condition) / dumpCoefficent, 0, 1));
    }
  }
  //*/

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
    float mu = 0.15;
    float frictionMagnitude = normalForce * mu;
    PVector friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    return friction.mult(frictionMagnitude);
  }

  void checkCylinderCollision() {
    float collisionDistance = ballRadius + cylinder.radius;

    for (PVector cylPos : cylinderPositions) {
      if (PVector.dist(position, cylPos) <= collisionDistance) {
        //compute new velocity vector
        PVector n = new PVector(position.x - cylPos.x, 0, position.z - cylPos.z).normalize();
        velocity = PVector.sub(velocity, PVector.mult(n, PVector.dot(velocity, n) * 2));

        //place ball in exact impact position
        position = PVector.add(n.mult(collisionDistance), cylPos);
        
        /* EXTRA */
        /*
        playSound(abs(velocity.mag()));
        //*/
      }
    }     
  }
}