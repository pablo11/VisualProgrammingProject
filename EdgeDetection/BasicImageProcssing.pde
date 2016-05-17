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

PImage thresholdHue(PImage img, float thresholdLowerBound, float thresholdUpperBound) {
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    if ((thresholdLowerBound <= hue(img.pixels[i])) && (hue(img.pixels[i]) <= thresholdUpperBound)) {
      result.pixels[i] = img.pixels[i];
    } else {
      result.pixels[i] = color(0);
    }
  }
  return result;
}

PImage thresholdBrightness(PImage img, float thresholdLowerBound, float thresholdUpperBound) {
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    if ((thresholdLowerBound <= brightness(img.pixels[i])) && (brightness(img.pixels[i]) <= thresholdUpperBound)) {
      result.pixels[i] = img.pixels[i];
    } else {
      result.pixels[i] = color(0);
    }
  }
  return result;
}

PImage thresholdSaturation(PImage img, float thresholdLowerBound, float thresholdUpperBound) {
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    if ((thresholdLowerBound <= saturation(img.pixels[i])) && (saturation(img.pixels[i]) <= thresholdUpperBound)) {
      result.pixels[i] = img.pixels[i];
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

boolean sameImage(PImage image1, PImage image2) {
  if (image1.pixels.length != image2.pixels.length) {
    return false;
  }

  for (int i = 0; i < image1.pixels.length; ++i) {
    if (image1.pixels[i] != image2.pixels[i]) {
      return false;
    }
  }

  return true;
}