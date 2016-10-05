class Point {
  float x, y;
  
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  Point move(float d, float angle) {
    return new Point(x + d * cos(angle), y + d * sin(angle));
  }
  
}