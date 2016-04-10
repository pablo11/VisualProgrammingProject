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

    //not needed in the working part
    boolean collision = false;
    ArrayList<PVector> collisionVelocities = new ArrayList<PVector>();
    PVector finPos = new PVector(0, 0, 0);

    ArrayList<PVector> coll = new ArrayList<PVector>();

    for (PVector cylPos : cylinderPositions) {
      if (PVector.dist(position, cylPos) < collisionDistance) {

        /******************************************************************
         *Here follows the working code
         *WARNING: here we modify position immediatelly after we see a collision, if we have a double
         *         simoultaneous collision we do not compute correctly the position and velocity.
         */
        /*
        //compute new velocity vector
        PVector n = new PVector(position.x - cylPos.x, 0, position.z - cylPos.z).normalize();
        velocity = PVector.sub(velocity, PVector.mult(n, PVector.dot(velocity, n)*2));

        //place ball in exact impact position
        position = (n.mult(collisionDistance)).add(cylPos);
        /* EXTRA */
        /*
        playSound(abs(velocity.mag()));
        //*/
        //*/
        /******************************************************************/
        
        //compute new velocity vector
         PVector n = new PVector(position.x - cylPos.x, 0, position.z - cylPos.z).normalize();
         collisionVelocities.add(PVector.sub(velocity, PVector.mult(n, PVector.dot(velocity, n)*2)));
         
         //compute exact ball impact position    
         coll.add(cylPos);
         finPos = PVector.add(PVector.mult(n, collisionDistance), cylPos);
         //collPos.add(r);        
         
         collision = true;
         
      }
    }
    //not needed in the working part
    
    if (collision) {
     //compute and set final velocity
     velocity = new PVector(0, 0, 0);
     for(PVector v : collisionVelocities) {
     velocity.add(v);
     }
     
     //set impact position to current position
     
     //WARNING: here the finPos is calculated wrongly (it must be at same distance from all colliding cylinder)
     position = finPos;
     
     println(collisionDistance + "\n");
     for(PVector x : cylinderPositions) {
     println(PVector.dist(x, position));
     }
     println();
     
     /* EXTRA */
     /*
     playSound(abs(velocity.mag()));
     //*/
     }
     
  }
}