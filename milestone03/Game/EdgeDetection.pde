import processing.video.*;

float areaUpperBound;
float areaLowerBound;

float[] tabSin;
float[] tabCos;

class EdgeDetection extends PApplet {
  private Capture cam;

  PVector rotation;
  private PImage img;
  private QuadGraph quadgraph;
  private TwoDThreeD projecter;

  EdgeDetection() {
  }

  void settings() {
    size(800, 600);
  }

  void setup() {
    rotation = new PVector(0, 0, 0);
    
    String[] cameras = Capture.list();
    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      cam = new Capture(this, cameras[0]);
      cam.start();
    }
    img = cam.get();

    quadgraph = new QuadGraph();
    projecter = new TwoDThreeD(img.width, img.height);
    fillSinCos();
  }

  void draw() {
    if (cam.available() == true) {
      cam.read();
    }
    img = cam.get();
    image(img, 0, 0);
    //compute sobel and hough
    PImage sobel = computeSobel(img);
    int[] hough = hough(sobel);
    PImage accumulator = displayAccumulator(sobel, hough, 600);
    ArrayList<PVector> lines = displayLines(sobel, hough, 180, 8);

    //quad
    quadgraph.build(lines, img.width, img.height);
    List<int[]> quads = filterQuads(quadgraph.findCycles(), lines);
    //if we have more than one quad just take the first
    //with those images we always have only one quad except for the third image
    if (quads.size() > 0) {
      rotation = drawQuad(quads.get(0), lines);
    }
    
    //image(accumulator, 800, 0);
    //image(sobel, 1400, 0);
  }

  PImage computeSobel(PImage origImg) {
    PImage tmpImg = thresholdHue(origImg, 50, 140);
    tmpImg = thresholdBrightness(tmpImg, 30, 200);
    tmpImg = thresholdSaturation(tmpImg, 90, 255);
    tmpImg = gaussianBlur(tmpImg);
    tmpImg = thresholdBinary(tmpImg, 30, 200);

    //set area bounds, used to select quad
    areaBounds(tmpImg);

    return sobel(tmpImg, 0.23);
  }

  List<int[]> filterQuads(List<int[]> quads, ArrayList<PVector> lines) {
    List<int[]> filteredQuads = new ArrayList<int[]>();

    for (int[] quad : quads) {
      PVector l1 = lines.get(quad[0]);
      PVector l2 = lines.get(quad[1]);
      PVector l3 = lines.get(quad[2]);
      PVector l4 = lines.get(quad[3]);

      PVector c12 = intersection(l1, l2);
      PVector c23 = intersection(l2, l3);
      PVector c34 = intersection(l3, l4);
      PVector c41 = intersection(l4, l1);

      if (   quadgraph.isConvex(c12, c23, c34, c41) 
        && quadgraph.validArea(c12, c23, c34, c41, areaUpperBound, areaLowerBound)
        && quadgraph.nonFlatQuad(c12, c23, c34, c41)) {
        filteredQuads.add(quad);
      }
    }
    return filteredQuads;
  }

  PVector drawQuad(int[] quad, ArrayList<PVector> lines) {
    ArrayList<PVector> bestLines = new ArrayList<PVector>();
    for (int i = 0; i < 4; ++i) {
      bestLines.add(lines.get(quad[i]));
    }
    drawLines(bestLines, img);

    List<PVector> intersections = new ArrayList<PVector>();
    for (int i = 0; i < 4; ++i) {
      intersections.add(intersection(lines.get(quad[i]), lines.get(quad[(i + 1) % 4])));
    }

    // Draw intersections
    fill(255, 128, 0);
    for (PVector inter : intersections) {
      ellipse(inter.x, inter.y, 10, 10);
    }

    // Compute rotation angles  
    PVector rot = projecter.get3DRotations(quadgraph.sortCorners(intersections));
    /*
    print("rot x: " + degrees(rot.x));
    print("rot y: " + degrees(rot.y));
    print("rot z: " + degrees(rot.z) + "\n");
    */
    return rot;
  }

  void drawLines(ArrayList<PVector> lines, PImage edgeImg) {
    for (PVector l : lines) {
      float r = l.x;
      float phi = l.y;

      int x0 = 0;
      int y0 = (int) (r / sin(phi));
      int x1 = (int) (r / cos(phi));
      int y1 = 0;
      int x2 = edgeImg.width;
      int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
      int y3 = edgeImg.width;
      int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));

      // Finally, plot the lines
      stroke(204, 102, 0);
      if (y0 > 0) {
        if (x1 > 0) line(x0, y0, x1, y1);
        else if (y2 > 0) line(x0, y0, x2, y2);
        else line(x0, y0, x3, y3);
      } else {
        if (x1 > 0) {
          if (y2 > 0) line(x1, y1, x2, y2);
          else line(x1, y1, x3, y3);
        } else line(x2, y2, x3, y3);
      }
    }
  }

  PVector intersection(PVector line1, PVector line2) {
    float d = cos(line2.y) * sin(line1.y) - cos(line1.y) * sin(line2.y);
    float x = (line2.x * sin(line1.y) - line1.x * sin(line2.y)) / d;
    float y = (-line2.x * cos(line1.y) + line1.x * cos(line2.y)) / d;

    return new PVector(x, y);
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
}