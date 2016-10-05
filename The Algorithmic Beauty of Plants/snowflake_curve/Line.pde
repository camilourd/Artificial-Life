class Line {
  Point a, b;
  
  Line(Point a, Point b) {
    this.a = a;
    this.b = b;
  }
  
  void display() {
    stroke(0, 0, 255);
    line(a.x, a.y, b.x, b.y);
  }
  
  float length() {
    return a.dist(b);
  }
  
}