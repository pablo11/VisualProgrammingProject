class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  void render() {
    stroke(0, 255, 0);
    lineBtwTwoPoints(s[4], s[5]);
    lineBtwTwoPoints(s[5], s[6]);
    lineBtwTwoPoints(s[6], s[7]);
    lineBtwTwoPoints(s[7], s[4]);
    stroke(0, 0, 255);
    lineBtwTwoPoints(s[0], s[4]);
    lineBtwTwoPoints(s[1], s[5]);
    lineBtwTwoPoints(s[2], s[6]);
    lineBtwTwoPoints(s[3], s[7]);
    stroke(255, 0, 0);
    lineBtwTwoPoints(s[0], s[1]);
    lineBtwTwoPoints(s[1], s[2]);
    lineBtwTwoPoints(s[2], s[3]);
    lineBtwTwoPoints(s[3], s[0]);
  }
  void lineBtwTwoPoints(My2DPoint p1, My2DPoint p2) {
    line(p1.x, p1.y, p2.x, p2.y);
  }
}