PImage sobel(PImage img, float treshold) {
  float[][] hKernel = {
    { 0, 1, 0 }, 
    {0, 0, 0}, 
    { 0, -1, 0 }
  };

  float[][] vKernel = {
    { 0, 0, 0 }, 
    {1, 0, -1}, 
    {0, 0, 0 }
  };

  float weight = 1.f;

  int kernelSize = 3;

  PImage result = createImage(img.width, img.height, ALPHA);

  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }

  float max = 0;
  float[] buffer = new float[img.width * img.height];

  for (int y = kernelSize / 2; y < img.height - kernelSize / 2; ++y) {
    for (int x = kernelSize / 2; x < img.width - kernelSize / 2; ++x) {        
      int sum_h = 0;
      int sum_v = 0;
      for (int i = 0; i < kernelSize; ++i) {
        for (int j = 0; j < kernelSize; ++j) {
          float image_pixel = brightness(img.pixels[(y + i - kernelSize/2) * img.width + (x + j - kernelSize/2)]);
          sum_h += image_pixel * hKernel[i][j];
          sum_v += image_pixel * vKernel[i][j];
        }
      }
      float sum = sqrt(pow(sum_h, 2) + pow(sum_v, 2));
      if (sum > max) {
        max = sum;
      }
      buffer[y * img.width + x] = sum / weight;
    }
  }

  for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
    for (int x = 2; x < img.width - 2; x++) { // Skip left and right
      if (buffer[y * img.width + x] > (int)(max * treshold)) { // 30% of the max
        result.pixels[y * img.width + x] = color(255);
      } else {
        result.pixels[y * img.width + x] = color(0);
      }
    }
  }
  return result;
}