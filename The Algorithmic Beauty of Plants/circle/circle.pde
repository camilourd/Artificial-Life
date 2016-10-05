int maxr = 30;
void setup() {
  size(700, 700);
  background(255);
  drawCircle(29);
}

void draw() {
  
}

void drawCircle(int r) {
  int lh = min(width, height) / (2 * (r + 1));
  fill(0);
  stroke(0);
  ArrayList<Point> points = new ArrayList<Point>();
  for(int i = 0; i * lh <= width; i++) {
    for(int j = 0; j * lh <= height; j++) {
      int rt = (i - r - 1) * (i - r - 1) + (j - r - 1) * (j - r - 1);
      int root = (int) sqrt(rt);
      if(root == r && root * root == rt) {
        ellipse(i * lh, j * lh, 5, 5);
        points.add(new Point(i - r - 1, j - r - 1));
      }
    }
  }
  line(0, (r + 1) * lh, 2 * (r + 1) * lh, (r + 1) * lh);
  line((r + 1) * lh, 0, (r + 1) * lh, 2 * (r + 1) * lh);
  noFill();
  stroke(255, 0, 0);
  ellipse((r + 1) * lh, (r + 1) * lh, 2 * r * lh, 2 * r * lh);
  stroke(0, 0, 255);
  int cnt = 0;
  for(int i = 0; i < points.size(); i++)
    for(int j = i + 1; j < points.size(); j++)
      for(int k = j + 1; k < points.size(); k++) {
        Point a = points.get(i);
        Point b = points.get(j);
        Point c = points.get(k);
        if(!a.equals(b) && !a.equals(c) && !b.equals(c)) {
          Triangle tr = new Triangle(a, b, c);
          if(tr.zero()) {
            triangle((a.x + r + 1) * lh, (a.y + r + 1) * lh, (b.x + r + 1) * lh, (b.y + r + 1) * lh, (c.x + r + 1) * lh, (c.y + r + 1) * lh);
            cnt++;
          }
        }
      }
  println(points.size() + " " + cnt);
}