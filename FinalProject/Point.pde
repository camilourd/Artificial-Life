class Point {
  public float x, y;
  
  public Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public float dist(Point p) {
    return sqrt((x - p.x) * (x - p.x) + (y - p.y) * (y - p.y));
  }
  
  public Point sum(Point p) {
    return new Point(p.x + x, p.y + y);
  }
  
  public Point substract(Point p) {
    return new Point(p.x - x, p.y - y);
  }
  
  public Point normalize(float size) {
    float d = (size() > 0)? size() / size : 1.0;
    return new Point(x / d, y / d);
  }
  
  public float size() {
    return sqrt(x * x + y * y);
  }
  
}