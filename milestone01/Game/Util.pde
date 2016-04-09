//clamp constraints value to a minimum and maximum value
float clamp(float value, float min, float max) {
  if (value > max) return max;
  else if (value < min) return min;
  else return value;
}