class Cylinder {
  float radius;
  color colour;
  private PShape cyl;

  Cylinder(float r, float h, int resolution) {
    noStroke();
    cyl = createShape(GROUP);
    radius = r;
    colour = color(200);
    PShape border = createShape();
    PShape top = createShape();
    PShape bottom = createShape();
    
    float angle;
    float[] x = new float[resolution + 1];
    float[] z = new float[resolution + 1];
    
    //get the x and y position on a circle for all the sides
    for (int i = 0; i < x.length; ++i) {
      angle = (TWO_PI / resolution) * i;
      x[i] = sin(angle) * r;
      z[i] = cos(angle) * r;
    }

    border.beginShape(QUAD_STRIP); 
    top.beginShape();
    bottom.beginShape();

    //draw the border, top and bottom of the cylinder
    for (int i = 0; i < x.length; ++i) {
      border.vertex(x[i], 0, z[i]);
      border.vertex(x[i], -h, z[i]);
            
      top.vertex(x[i], -h, z[i]);
      
      bottom.vertex(x[i], 0, z[i]);
    }

    border.endShape();
    top.endShape();
    bottom.endShape();

    cyl.addChild(border);
    cyl.addChild(top);
    cyl.addChild(bottom);
  }
  
  void display(float x, float z) {
    pushMatrix();
    translate(x, -board.sizeY / 2, z);
    cyl.setFill(colour);
    shape(cyl);
    popMatrix();
  }
}