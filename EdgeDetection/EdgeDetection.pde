PImage img;
HScrollbar thresholdBar;
HScrollbar thresholdBar2;

void settings() {
  size(800, 600);
}

void setup() {
  thresholdBar = new HScrollbar(0, height - 45, width, 20);
  thresholdBar2 = new HScrollbar(0, height - 20, width, 20);
  //noLoop();
}

void draw() {
  //displayThresholdColour();
  //displayConvulsion();
  //displayThresholdBinary();
  displaySobel();
}

void displaySobel() {
  PImage origImg = loadImage("board1.jpg");
  /*
  float threshold1 = map(thresholdBar.getPos(), 0, 1, 0, 255);
  float threshold2 = map(thresholdBar2.getPos(), 0, 1, 0, 255);
  PImage threshold = thresholdColour(origImg, threshold1, threshold2, true);
  //*/
  /*
  float[][] kernel = {{ 9, 12, 9 }, 
                      { 12, 15, 12 }, 
                      { 9, 12, 9 }};
  float weight = 99.f; // weight for gaussian blur is the sum of all elements
  PImage gaussianImg = convolute(threshold, kernel, weight);
  //*/
  /*
  PImage img = sobel(threshold);
  image(img, 0, 0);
  thresholdBar.update();
  thresholdBar.display();
  thresholdBar2.update();
  thresholdBar2.display();
  //*/
  //use treshold = 0.23;
  //try gaussian blur before
  PImage img = sobel(origImg, thresholdBar.getPos());
  println(thresholdBar.getPos());
  image(img, 0, 0);
  thresholdBar.update();
  thresholdBar.display();
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
  PImage origImg = loadImage("test.png");
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
  }
  return result;
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

boolean isBorder(int i, int borderSize, int w, int h) {
  boolean isBorder = false;
  //upper border
  if (i < borderSize * w) {
    isBorder = true;
  }
  //lower border
  if (i > (h - borderSize) * w) {
    isBorder = true;
  }
  //left border
  if (i % w <= borderSize) {
    isBorder = true;
  }
  //right border
  if (i % w >= (h - borderSize)) {
    isBorder = true;
  }
  return isBorder;
}