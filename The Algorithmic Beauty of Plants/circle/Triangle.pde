class Triangle {
  ArrayList<Point> points;
  
  Triangle(Point a, Point b, Point c) {
    points = new ArrayList<Point>();
    points.add(a);
    points.add(b);
    points.add(c);
  }
  
  boolean zero() {
    Point zero = new Point(0,0);
    int lo = 0, hi = 2, mid;
    double z = zero.turn(points.get(0), points.get(1), zero), mul = 1.0;
    
    if(z * zero.turn(points.get(2), points.get(0), zero) < 0) return false;
    if(z < 0.0) mul = -1.0;
    
    while(hi - lo > 1){
        mid = (lo + hi) / 2;
        
        if(zero.turn(points.get(0), points.get(mid), zero) * mul > 0) lo = mid;
        else hi = mid;
    }
    return zero.turn(points.get(lo), points.get(hi), zero) * mul >= 0;
  }
  
}