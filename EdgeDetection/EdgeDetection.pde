import java.util.Random;

PImage img;

float[] tabSin;
float[] tabCos;

//HScrollbar scroll1;
//HScrollbar scroll2;

void settings() {
  size(1600, 600);
}

void setup() {
  //scroll1 = new HScrollbar(0, height - 45, width, 20);
  //scroll2 = new HScrollbar(0, height - 20, width, 20);

  fillSinCos();
  //noLoop only for static images
  //noLoop();
}

void draw() {
  //==========================================================================================================
  //compute sobel and hough
  PImage origImg = loadImage("board1.jpg");
  PImage sobel = computeSobel(origImg);
  image(sobel, 800, 0);
  img = displayAccumulator(sobel);
  image(origImg, 0, 0);
  ArrayList<PVector> lines = displayLines(sobel, 200, 6);
  getIntersections(lines, origImg);

  /*
  scroll1.update();
   scroll1.display();
   scroll2.update();
   scroll2.display();
   */

  //==========================================================================================================
  //quad

  QuadGraph quadgraph = new QuadGraph();
  quadgraph.build(lines, origImg.width, origImg.height);
  List<int[]> quads = quadgraph.findCycles();

  for (int[] quad : quads) {
    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);
    // (intersection() is a simplified version of the
    // intersections() method you wrote last week, that simply
    // return the coordinates of the intersection between 2 lines) 
    PVector c12 = intersection(l1, l2);
    PVector c23 = intersection(l2, l3);
    PVector c34 = intersection(l3, l4);
    PVector c41 = intersection(l4, l1);
    float min_area = (origImg.width * origImg.height) / 5;
    float max_area = origImg.height * origImg.height * 1.5;
    if (   quadgraph.isConvex(c12, c23, c34, c41) 
        && quadgraph.validArea(c12, c23, c34, c41, max_area, min_area)
        && quadgraph.nonFlatQuad(c12, c23, c34, c41)) {
    // Choose a random, semi-transparent colour
    Random random = new Random();
    fill(color(min(255, random.nextInt(300)), 
      min(255, random.nextInt(300)), 
      min(255, random.nextInt(300)), 50));
    quad(c12.x, c12.y, c23.x, c23.y, c34.x, c34.y, c41.x, c41.y);
    }
  }
}

PImage computeSobel(PImage origImg) {
  PImage tmpImg = thresholdHue(origImg, 50, 140); //50, 140
  tmpImg = thresholdSaturation(tmpImg, 47, 255); //47, 255
  tmpImg = thresholdBrightness(tmpImg, 30, 220); //30, 220

  //gaussian blur
  tmpImg = gaussianBlur(tmpImg);

  //binary treshold
  /*
  float t1 = map(scroll1.getPos(), 0, 1, 0, 255);
   float t2 = map(scroll2.getPos(), 0, 1, 0, 255);
   println(t1 + "  " + t2);
   */

  tmpImg = thresholdBinary(tmpImg, 36, 64);

  return sobel(tmpImg, 0.23);
}

PVector intersection(PVector line1, PVector line2) {

  PVector intersection = new PVector();

  float d = cos(line2.y) * sin(line1.y) - cos(line1.y) * sin(line2.y);

  float x = (line2.x * sin(line1.y) - line1.x * sin(line2.y)) / d;
  float y = (-1*line2.x * cos(line1.y) + line1.x * cos(line2.y)) / d;

  // draw the intersection
  fill(255, 128, 0);
  ellipse(x, y, 10, 10);

  intersection.x = x;
  intersection.y = y;

  return intersection;
}


void fillSinCos() {
  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;
  int phiDim = (int) (Math.PI / discretizationStepsPhi);

  tabSin = new float[phiDim];
  tabCos = new float[phiDim];

  float ang = 0;
  float inverseR = 1.f / discretizationStepsR;
  for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, ++accPhi) {
    tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
    tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
  }
}