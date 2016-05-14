import java.util.Random;

PImage img;
HScrollbar thresholdBar;
HScrollbar thresholdBar2;

void settings() {
  size(800, 600);
}

void setup() {
  
  thresholdBar = new HScrollbar(0, height - 45, width, 20);
  thresholdBar2 = new HScrollbar(0, height - 20, width, 20);
  
  
  
  
  
  noLoop();
}

void draw() {
  
  
  //float thresholdColourLowerBound = 0;
  //float thresholdColourUpperBound = 0;
  //float thresholdBinaryBound = 0;
  
  //displayThresholdColour();
  //displayConvulsion();
  //displayThresholdBinary();
  //displaySobel();
  
  float threshold1 = map(thresholdBar.getPos(), 0, 1, 0, 255);
  float threshold2 = map(thresholdBar2.getPos(), 0, 1, 0, 255);
  println(threshold1 + "  " + threshold2 + "\n");
  
  PImage origImg = loadImage("board3.jpg");
  
  
    
  ////  thresholdColourLowerBound = 117;
  ////  thresholdColourUpperBound = 135;
  ////  thresholdBinaryBound = 105;
  //// 104.61 137.63
  
  
  PImage img = thresholdColour(origImg, 100, 136, true);
  image(img, 0, 0);
  img = gaussianBlur(img);
  thresholdBinary(img, img, 100, false);
  image(img, 0, 0);
  img = sobel(img, 0.29);
  //image(img, 0 ,0);
  ////displaySobel();
  ////img = displayHough(img);
  ////image(img, 0, 0);
  //image(origImg, 0, 0);
  ArrayList<PVector> lines = displayLines(img, 150, 6);
  //getIntersections(displayLines(img, 150, 7));
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

if(quadgraph.isConvex(c12, c23, c34, c41) && quadgraph.validArea(c12, c23, c34, c41, c12.mag()*c23.mag()+5, c12.mag()*c23.mag()) && quadgraph.nonFlatQuad(c12, c23, c34, c41)){
       // Choose a random, semi-transparent colour
       Random random = new Random();
       fill(color(min(255, random.nextInt(300)),
               min(255, random.nextInt(300)),
               min(255, random.nextInt(300)), 50));
       quad(c12.x,c12.y,c23.x,c23.y,c34.x,c34.y,c41.x,c41.y);
}
   }
    
    
    
  //thresholdBar.update();
  // thresholdBar.display();
  // thresholdBar2.update();
  // thresholdBar2.display();
   
}

void displaySobel() {
  PImage origImg = loadImage("board1.jpg");
  float treshold = 0.23;
  //try gaussian blur before
  PImage img = sobel(origImg, treshold);
  image(img, 0, 0);
}

void displayThresholdBinary() {
  PImage origImg = loadImage("board1.jpg");
  float threshold = map(thresholdBar.getPos(), 0, 1, 0, 255);
  PImage result = createImage(origImg.width, origImg.height, RGB);
  thresholdBinary(origImg, result, threshold, false);
  image(result, 0, 0);
  thresholdBar.update();
  thresholdBar.display();
}

void displayConvulsion() {
  PImage origImg = loadImage("board1.jpg");
  float[][] kernel = {{ 9, 12, 9 }, 
    { 12, 15, 12 }, 
    { 9, 12, 9 }};
  float weight = 99.f; // weight for gaussian blur is the sum of all elements
  img = convolute(origImg, kernel, weight);
  image(img, 0, 0);
}

void displayThresholdColour() {
  PImage origImg = loadImage("board.jpg");
  float threshold1 = map(thresholdBar.getPos(), 0, 1, 0, 255);
  float threshold2 = map(thresholdBar2.getPos(), 0, 1, 0, 255);
  img = thresholdColour(origImg, threshold1, threshold2, false);

  image(img, 0, 0);
  thresholdBar.update();
  thresholdBar.display();
  thresholdBar2.update();
  thresholdBar2.display();
}

void thresholdBinary(PImage img, PImage result, float threshold, boolean inverted) {
  int brightness = 255;
  if (inverted) {
    brightness = 0;
  }
  //PImage result = createImage(img.width, img.height, RGB);
  result.loadPixels();
  for (int i = 0; i < img.width * img.height; i++) {
    if (brightness(img.pixels[i]) > threshold) {
      result.pixels[i] = color(brightness);
    } else {
      result.pixels[i] = color(255 - brightness);
    }
  }
  result.updatePixels();
}

PImage thresholdColour(PImage img, float thresholdLowerBound, float thresholdUpperBound, boolean hueIt) {
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    if(brightness(img.pixels[i]) > 20 && brightness(img.pixels[i]) < 240 && saturation(img.pixels[i]) > 20){
    float hue = hue(img.pixels[i]);
    if ((thresholdLowerBound < hue) && (hue < thresholdUpperBound)) {
      color col = img.pixels[i];
      if (hueIt) {
        col = color(hue);
      }
      result.pixels[i] = col;
    } else {
      result.pixels[i] = color(0);
    }
  }else{
    result.pixels[i] = color(0);
  }
  }
  return result;
}

PImage gaussianBlur(PImage img) {
  float[][] kernel = {{ 9, 12, 9 }, 
    { 12, 15, 12 }, 
    { 9, 12, 9 }};
  float weight = 99.f; // weight for gaussian blur is the sum of all elements
  return convolute(img, kernel, weight);
}

PImage convolute(PImage img, float[][] kernel, float weight) {
  int kernelSize = kernel.length;
  // create a greyscale image (type: ALPHA) for output
  PImage result = createImage(img.width, img.height, ALPHA);
  for (int y = kernelSize / 2; y < img.height - kernelSize / 2; ++y) {
    for (int x = kernelSize / 2; x < img.width - kernelSize / 2; ++x) {        
      int sum = 0;
      for (int i = 0; i < kernelSize; ++i) {
        for (int j = 0; j < kernelSize; ++j) {
          sum += brightness(img.pixels[(y + i - kernelSize/2) * img.width + (x + j - kernelSize/2)]) * kernel[i][j];
        }
      }
      result.pixels[y * img.width + x] = color(sum / weight);
    }
  }
  return result;
}

/*
 * format: ALPHA, RGB, ...
 */
PImage copyImg(PImage orig, int format) {
  PImage ret = createImage(orig.width, orig.height, format);
  ret.pixels = orig.pixels;
  return ret;
}

boolean sameImage(PImage image1, PImage image2){
  
  if(image1.pixels.length != image2.pixels.length){
    
    return false;
  }
  
  for(int i = 0; i < image1.pixels.length; ++i){
    
    if(image1.pixels[i] != image2.pixels[i]){
      
      return false;
    } 
  }
  
  return true;
}


PVector intersection(PVector line1, PVector line2) {
  
        PVector intersection = new PVector();
        
                float d = cos(line2.y)*sin(line1.y) - cos(line1.y)*sin(line2.y);
                
                float x = (line2.x * sin(line1.y) - line1.x * sin(line2.y))/d;
                float y = (-1*line2.x * cos(line1.y) + line1.x * cos(line2.y))/d;
                
                // draw the intersection
                fill(255, 128, 0);
                ellipse(x, y, 10, 10);
                
                intersection.x = x;
                intersection.y = y;
         
                
        return intersection;
    }