public class Savannah {
  
  private int rows;
  private int cols;
  private float size;
  private Point top;
  private Cell[][] cells;
  private ArrayList<Being> zebras;
  private ArrayList<Being> leopards;
  
  protected int flip_season_period = 800;
  private int period = 0;
  private TreeGenerator gen = new TreeGenerator();
  
  public boolean trees = true;
  public boolean floor = true;
  public boolean polution = true;
  public boolean vision = false;
  
  public Savannah(int rows, int cols, int alpha, float sigma, float size) {
    this.rows = rows;
    this.cols = cols;
    this.size = size;
    this.top = new Point(-rows / 2.0 * size, -cols / 2.0 * size);
    Point[] poles = new Point[]{new Point(rows - 20, 20), new Point(20, cols - 20)};
    cells = new Cell[rows][cols];
    ArrayList<Point> values = calculate(alpha, sigma);
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        Point p = new Point(i, j);
        float[] d = new float[]{poles[0].dist(p), poles[1].dist(p)};
        int mind = min((int) d[0], (int) d[1]);
        float amount = (mind < values.size())? rand(values.get(mind)) : 0.0;
        float[] increment = new float[2];
        increment[0] += getRate(d[0], d[1], values.size());
        increment[1] += getRate(d[1], d[0], values.size());
        float limit = (mind < values.size())? values.get(mind).x + values.get(mind).y : 0.0;
        Resource resource = new Resource(amount, increment, limit);
        Polution polution = new Polution(0, (float) Math.random());
        p = new Point(top.x + (i * size) + (size / 2.0), top.y + (j * size) + (size / 2.0));
        cells[i][j] = new Cell(resource, polution, p, gen.generate((int) random(3), p, size));
      }
    }
    this.zebras = new ArrayList<Being>();
    this.leopards = new ArrayList<Being>();
  }
  
  public float getRate(float dp1, float dp2, float limit) {
    if(dp1 < limit || dp2 < limit)
      return dp1 < dp2 ? 1.0 / dp1 : 0.125 / dp2;
    return 0.0;
  }
  
  public ArrayList<Point> calculate(int alpha, double sigma) {
    ArrayList<Point> values = new ArrayList<Point>();
    int s = (int) (alpha * sigma);
    while(s > 0) {
      values.add(new Point(alpha - s, 2 * s + 1));
      alpha = (int) (alpha - (alpha / 10.0));
      s = (int) (alpha * sigma);
    }
    return values;
  }
  
  public float rand(Point p) {
    return p.x + random(p.y);
  }
  
  private float alpha, sigma;
  
  public void init(int zebraNumber, int leopardNumber, float alpha, float sigma) {
    this.alpha = alpha;
    this.sigma = sigma;
    for(int i = 0; i < zebraNumber; i++) {
      float x = random(rows), y = random(cols);
      zebras.add(new Zebra(new Point(x, y), generate(alpha, sigma)));
    }
    for(int i = 0; i < leopardNumber; i++) {
      float x = random(rows), y = random(cols);
      Leopard leopard = new Leopard(new Point(x, y), generate(alpha, sigma));
      leopard.characteristics[Being.VISION] *= 1.2;
      leopards.add(leopard);
    }
  }
  
  public float[] generate(float alpha, float sigma) {
    float limit = 500 + random(1500);
    return new float[]{
      alpha - sigma + random(sigma * 2), // vision
      1 + random(10), // min
      1 + random(10), // max
      1 + random(10), // metabolism
      limit, // limit
      1 + random(10 * flip_season_period), // age
      1 + random(10), // polution
      100 + random(limit - 500), // reproduce stage
      1 + random(flip_season_period / 4), // reproduction period
      random(1) // minimum speed
    };
  }
  
  public void update() {
    while(leopards.size() < 4) init(0, 4 - leopards.size(), alpha, sigma);
    while(zebras.size() < 20) init(10 - zebras.size(), 0, alpha, sigma);
    updateBeings(leopards);
    updateBeings(zebras);
    period = (period + 1) % flip_season_period;
    for(int i = 0; i < rows; i++)
      for(int j = 0; j < cols; j++) {
        if(period == 0)
          cells[i][j].resource.changeSeason();
        cells[i][j].resource.increase();
        cells[i][j].polution.decrease();
      }
  }
  
  public void updateBeings(ArrayList<Being> beings) {
    for(int i = 0; i < beings.size(); i++) {
      Being being = beings.get(i);
      if(being.isAlive()) {
        updateBeing(being, beings);
      } else {
        beings.remove(i--);
      }
    }
  }
  
  public void updateBeing(Being being, ArrayList<Being> beings) {
    being.eat(cells, zebras, leopards);
    Point movement = being.move(cells, zebras, leopards);
    if(being.isPeriod()) {
      Being parent = being.findClosest(being.findParents(zebras));
      movement = movement.sum(being.moveToParent(parent)).normalize(being.VEL);
      //movement = being.moveToParent(parent);
      if(parent != null && parent.getLoc().dist(being.getLoc()) < 2) {
        print(beings.size() + " -> ");
        for(Being child: reproduce(being, parent)) {
          locate(child, being.getLoc());
          beings.add(child);
        }
        println(beings.size());
      }
    }
    moveBeing(being, movement);
    being.metabolise();
  }
  
  public void locate(Being being, Point center) {
    float nx = min(max(center.x + random(10) - 5.0, 0), cells.length - 1);
    float ny = min(max(center.y + random(10) - 5.0, 0), cells[0].length - 1);
    being.setLoc(new Point(nx, ny));
  }
  
  public void moveBeing(Being being, Point movement) {
    Point act = being.getLoc();
    Point next = act.sum(movement);
    if(!isCloseToBeing(next)) {
      float nx = min(max(next.x, 0), cells.length - 1);
      float ny = min(max(next.y, 0), cells[0].length - 1);
      being.setLoc(new Point(nx, ny));
    }
  }
  
  public boolean isCloseToBeing(Point loc) {
    int cnt = 0;
    for(Being being: zebras)
      if(loc.dist(being.getLoc()) < 0.5)
        cnt++;
    for(Being being: leopards)
      if(loc.dist(being.getLoc()) < 0.5)
        cnt++;
    return cnt > 1;
  }
  
  public Being[] reproduce(Being mother, Being parent) {
    if(parent != null)
      return mother.reproduce(parent);
    return new Being[0];
  }
  
  public boolean isInside(int x, int y) {
    return x > 0 && x < cells.length && y > 0 && y < cells[0].length;
  }
  
  public void draw(PGraphics pg) {
    drawFloor(pg);
    for(int i = 0; i < rows; i++)
      for(int j = 0; j < cols; j++)
        cells[i][j].draw(pg, size, trees, floor, polution);
    for(Being zebra: zebras)
      drawZebra(pg, (Zebra) zebra, size);
    for(Being leopard: leopards)
      drawLeopard(pg, (Leopard) leopard, size);
  }
  
  private void drawFloor(PGraphics pg) {
    pg.stroke(0);
    pg.fill(244, 215, 113);
    pg.rect(top.x, top.y, rows * size, cols * size);
  }
  
  private void drawZebra(PGraphics pg, Zebra zebra, float size) {
    Point loc = zebra.getLoc();
    pg.stroke(255, 255, 255);
    pg.fill(255, 255, 255);
    pg.pushMatrix();
    pg.translate(top.x + (loc.x * size) + (size / 2.0), top.y + (loc.y * size) + (size / 2.0), size / 2.0);
    drawBox(pg, size, zebra.coat);
    if(vision) {
      pg.stroke(255, 255, 255);
      pg.noFill();
      pg.ellipse(0, 0, 2.0 * zebra.getVision() * size, 2.0 * zebra.getVision() * size);
    }
    pg.popMatrix();
  }
  
  private void drawLeopard(PGraphics pg, Leopard leopard, float size) {
    Point loc = leopard.getLoc();
    pg.stroke(255, 127, 39);
    pg.fill(255, 127, 39);
    pg.pushMatrix();
    pg.translate(top.x + (loc.x * size) + (size / 2.0), top.y + (loc.y * size) + (size / 2.0), size / 2.0);
    drawBox(pg, size, leopard.coat);
    if(vision) {
      pg.stroke(255, 127, 39);
      pg.noFill();
      pg.ellipse(0, 0, 2.0 * leopard.getVision() * size, 2.0 * leopard.getVision() * size);
    }
    pg.popMatrix();
  }
  
  private void drawBox(PGraphics pg, float sz, PImage tex) {
    
    pg.beginShape(QUADS);
    pg.texture(tex);

  // Given one texture and six faces, we can easily set up the uv coordinates
  // such that four of the faces tile "perfectly" along either u or v, but the other
  // two faces cannot be so aligned.  This code tiles "along" u, "around" the X/Z faces
  // and fudges the Y faces - the Y faces are arbitrarily aligned such that a
  // rotation along the X axis will put the "top" of either texture at the "top"
  // of the screen, but is not otherwised aligned with the X/Z faces. (This
  // just affects what type of symmetry is required if you need seamless
  // tiling all the way around the cube)
  float p = sz/2.0f;
  
  // +Z "front" face
    pg.vertex(-p, -p,  p, 0, 0);
    pg.vertex( p, -p,  p, 32, 0);
    pg.vertex( p,  p,  p, 32, 32);
    pg.vertex(-p,  p,  p, 0, 32);

    // -Z "back" face
    pg.vertex( p, -p, -p, 0, 0);
    pg.vertex(-p, -p, -p, 32, 0);
    pg.vertex(-p,  p, -p, 32, 32);
    pg.vertex( p,  p, -p, 0, 32);

    // +Y "bottom" face
    pg.vertex(-p,  p,  p, 0, 0);
    pg.vertex( p,  p,  p, 32, 0);
    pg.vertex( p,  p, -p, 32, 32);
    pg.vertex(-p,  p, -p, 0, 32);

    // -Y "top" face
    pg.vertex(-p, -p, -p, 0, 0);
    pg.vertex( p, -p, -p, 32, 0);
    pg.vertex( p, -p,  p, 32, 32);
    pg.vertex(-p, -p,  p, 0, 32);

    // +X "right" face
    pg.vertex( p, -p,  p, 0, 0);
    pg.vertex( p, -p, -p, 32, 0);
    pg.vertex( p,  p, -p, 32, 32);
    pg.vertex( p,  p,  p, 0, 32);

    // -X "left" face
    pg.vertex(-p, -p, -p, 0, 0);
    pg.vertex(-p, -p,  p, 32, 0);
    pg.vertex(-p,  p,  p, 32, 32);
    pg.vertex(-p,  p, -p, 0, 32);

    pg.endShape();
  }
  
}