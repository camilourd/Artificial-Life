
HScrollbar depth;
Curve curve;
int maxDepth = 10;

void setup() {
  size(500, 400);
  depth = new HScrollbar(0, height - 16, width, 32, 16);
  Point a = new Point(10, 300);
  Point b = a.add((new Point(1, -1)).scale(200));
  Point c = new Point(210, 300);
  curve = new Curve(
    new Line(a, b),
    new Line(b, c),
    new Line(c, a),
    1
  );
}

void draw() {
  background(255);
  depth.update();
  //int dp = (int) (depth.getPos() / depth.swidth * maxDepth);
  curve.display(1);
  depth.display();
}