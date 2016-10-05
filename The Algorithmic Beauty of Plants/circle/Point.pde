class Point {
  int x, y;
  
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  int turn(Point a, Point b, Point c){
    int z = (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
    return z;
  }
  
  boolean equals(Point p) {
    return this.x == p.x && this.y == p.y;
  }
  
}