//clamp constraints value to a minimum and maximum value
float clamp(float value, float min, float max) {
  if (value > max) return max;
  else if (value < min) return min;
  else return value;
}

void inverseCameraRotation(float angle) {
  float a = atan((float) (width/2) / (width/2 + 100));
  rotateX(a - angle);
  rotateZ(0);
}

//this class represents a vector whose components are unsigned int
class PVectorUInt {
  int x;
  int y;
  int z;
  
  PVectorUInt(int setx, int sety) {
    x = setx;
    y = sety;
    z = -1;
  }
  
  PVectorUInt(int setx, int sety, int setz) {
    x = setx;
    y = sety;
    z = setz;
  }
}