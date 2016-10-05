class Point {
  float x, y;
  
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  float dist(Point p) {
    return sqrt((x - p.x) * (x - p.x) + (y - p.y) * (y - p.y));
  }
  
  Point add(Point p) {
    return new Point(x + p.x, y + p.y);
  }
  
  Point substract(Point p) {
    return new Point(x - p.x, y - p.y);
  }
  
  Point direction(Point p) {
    Point d = substract(p);
    d.x /= abs(d.x);
    d.y /= abs(d.y);
    return d;
  }
  
  Point rotate(float angle) {
    return new Point(
      x * cos(angle) - y * sin(angle),
      y * sin(angle) + y * cos(angle)
    );
  }
  
  Point scale(float size) {
    Point p = new Point(size, 0);
    float angle = atan(y / x);
    return p.rotate(angle);
  }
  
}