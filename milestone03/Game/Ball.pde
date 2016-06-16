class Ball {
  PVector position;
  PVector velocity;
  PVector gravity;
  float radius;
  color colour;

  Ball() {
    radius = 15;
    position = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 1, 0);
    colour = color(160);
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
    boolean collision = false;
    if (position.x > board.sizeX / 2) {
      position.x = board.sizeX / 2;
      velocity.x = velocity.x * -1;
      collision = true;
    } else if (position.x < -board.sizeX / 2) {
      position.x = -board.sizeX / 2;
      velocity.x = velocity.x * -1;
      collision = true;
    }

    if (position.z > board.sizeZ / 2) {
      position.z = board.sizeZ / 2;
      velocity.z = velocity.z * -1;
      collision = true;
    } else if (position.z < -board.sizeZ / 2) {
      position.z = -board.sizeZ / 2;
      velocity.z = velocity.z * -1;
      collision = true;
    }
    
    if (collision) {
      score.losePoints();
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
    pushMatrix();
    translate(position.x, -(radius + board.sizeY / 2), position.z);
    fill(colour);
    sphere(radius);
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
    float collisionDistance = radius + cylinder.radius;

    for (PVector cylPos : cylinderPositions) {
      if (PVector.dist(position, cylPos) <= collisionDistance) {
        //compute new velocity vector
        PVector n = new PVector(position.x - cylPos.x, 0, position.z - cylPos.z).normalize();
        velocity = PVector.sub(velocity, PVector.mult(n, PVector.dot(velocity, n) * 2));

        //place ball in exact impact position
        position = PVector.add(n.mult(collisionDistance), cylPos);
        
        score.gainPoints();
        /* EXTRA */
        /*
        playSound(abs(velocity.mag()));
        //*/
      }
    }     
  }
  
  /*
  void checkCylinderCollision() {
    float collisionDistance = ballRadius + cylinder.radius;

    //not needed in the working part
    boolean collision = false;
    ArrayList<PVector> collisionVelocities = new ArrayList<PVector>();
    PVector collided = new PVector(0, 0, 0);

    ArrayList<PVector> coll = new ArrayList<PVector>();

    for (PVector cylPos : cylinderPositions) {
      if (PVector.dist(position, cylPos) < collisionDistance) {
        //compute new velocity vector
         PVector n = new PVector(position.x - cylPos.x, 0, position.z - cylPos.z).normalize();
         collisionVelocities.add(PVector.sub(velocity, PVector.mult(n, PVector.dot(velocity, n)*2)));
         coll.add(cylPos);
         
         //compute exact ball impact position    
         collided = cylPos;                
         collision = true;
         
      }
    }
    
    float a = pow(velocity.mag(), 2);
    float b = (PVector.dot(velocity, PVector.sub(collided, position))) * 2;
    float c = pow(PVector.dist(collided, position), 2) - pow(collisionDistance, 2);
    
    float k = (-b - sqrt(pow(b, 2) - 4 * a * c)) / (2 * a);
    
    
    if (collision) {
     //compute and set final velocity
     velocity = new PVector(0, 0, 0);
     for(PVector v : collisionVelocities) {
       println("vel par : " + v.x + "  " + v.z);
       velocity.add(v);
     }
     println("vel : " + velocity.x + "  " + velocity.z);

     position = PVector.sub(position, PVector.mult(velocity, -k));
    println("pos : " + position.x + "  " + position.z);

     }
     
  }
  */
  
  
}