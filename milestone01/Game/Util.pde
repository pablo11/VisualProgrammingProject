//clamp constraints value to a minimum and maximum value
float clamp(float value, float min, float max) {
  if (value > max) return max;
  else if (value < min) return min;
  else return value;
}

float distanceBtwPoints(PVector p1, PVector p2) {
  return sqrt(pow((p1.x - p2.x),2) + pow((p1.y - p2.y), 2) + pow((p1.z - p2.z), 2));
}