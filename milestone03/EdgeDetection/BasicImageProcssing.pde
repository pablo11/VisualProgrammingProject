PImage thresholdBinary(PImage inImg, float thresholdLowerBound, float thresholdUpperBound) {
  PImage result = createImage(inImg.width, inImg.height, RGB);
  for (int i = 0; i < inImg.width * inImg.height; ++i) {
    if ((thresholdLowerBound <= brightness(inImg.pixels[i])) && (brightness(inImg.pixels[i]) <= thresholdUpperBound)) {
      result.pixels[i] = color(255);
    } else {
      result.pixels[i] = color(0);
    }
  }
  return result;
}

PImage thresholdHue(PImage inImg, float thresholdLowerBound, float thresholdUpperBound) {
  PImage result = createImage(inImg.width, inImg.height, RGB);
  for (int i = 0; i < inImg.width * inImg.height; ++i) {
    if ((thresholdLowerBound <= hue(inImg.pixels[i])) && (hue(inImg.pixels[i]) <= thresholdUpperBound)) {
      result.pixels[i] = inImg.pixels[i];
    } else {
      result.pixels[i] = color(0);
    }
  }
  return result;
}

PImage thresholdBrightness(PImage inImg, float thresholdLowerBound, float thresholdUpperBound) {
  PImage result = createImage(inImg.width, inImg.height, RGB);
  for (int i = 0; i < inImg.width * inImg.height; ++i) {
    if ((thresholdLowerBound <= brightness(inImg.pixels[i])) && (brightness(inImg.pixels[i]) <= thresholdUpperBound)) {
      result.pixels[i] = inImg.pixels[i];
    } else {
      result.pixels[i] = color(0);
    }
  }
  return result;
}

PImage thresholdSaturation(PImage inImg, float thresholdLowerBound, float thresholdUpperBound) {
  PImage result = createImage(inImg.width, inImg.height, RGB);
  for (int i = 0; i < inImg.width * inImg.height; ++i) {
    if ((thresholdLowerBound <= saturation(inImg.pixels[i])) && (saturation(inImg.pixels[i]) <= thresholdUpperBound)) {
      result.pixels[i] = inImg.pixels[i];
    } else {
      result.pixels[i] = color(0);
    }
  }
  return result;
}

PImage gaussianBlur(PImage img) {
  float[][] kernel = {
    { 9, 12, 9 }, 
    { 12, 15, 12 }, 
    { 9, 12, 9 }
  };
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

//counts number of white pixels on a binary thresholded image to estimate the area of the plate
void areaBounds(PImage thresholdedImg) {
  int boardPixels = 0;

  for (int i = 0; i < thresholdedImg.width * thresholdedImg.height; ++i) {
    if (thresholdedImg.pixels[i] == color(255)) {
      boardPixels += 1;
    }
  }
  
  float tollerance = 0.05;
  areaUpperBound = boardPixels * (1 + tollerance);
  areaLowerBound = boardPixels * (1 - tollerance);
}