public class Savannah {
  
  private int rows;
  private int cols;
  private float size;
  private Point top;
  private Cell[][] cells;
  private ArrayList<Being> zebras;
  private boolean[][] mark;
  
  protected int flip_season_period = 800;
  private int period = 0;
  
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
        cells[i][j] = new Cell(resource, polution, p);
      }
    }
    this.zebras = new ArrayList<Being>();
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
  
  public void init(int beingsNumber, int alpha, int sigma) {
    this.mark = new boolean[rows][cols];
    int x, y;
    for(int i = 0; i < beingsNumber; i++) {
      do {
        x = (int) random(rows);
        y = (int) random(cols);
      } while(mark[x][y]);
      zebras.add(new Zebra(new Point(x, y), generate(alpha, sigma)));
      mark[x][y] = true;
    }
  }
  
  public float[] generate(int alpha, int sigma) {
    float limit = 500 + random(1500);
    return new float[]{
      alpha - sigma + random(sigma * 2), // vision
      1 + random(10), // min
      1 + random(10), // max
      1 + random(10), // metabolism
      limit, // limit
      1 + random(10 * flip_season_period), // age
      1 + random(10), // polution
      1000 + random(limit - 500) // reproduce stage
    };
  }
  
  public void update() {
    updateZebras();
    period = (period + 1) % flip_season_period;
    for(int i = 0; i < rows; i++)
      for(int j = 0; j < cols; j++) {
        if(period == 0)
          cells[i][j].resource.changeSeason();
        cells[i][j].resource.increase();
        cells[i][j].polution.decrease();
      }
  }
  
  public void updateZebras() {
    for(int i = 0; i < zebras.size(); i++) {
      Zebra zebra = (Zebra) zebras.get(i);
      if(zebra.isAlive()) {
        /*if(zebra.isPeriod()) {
          Being parent = zebra.findClosest(zebra.findParents(zebras));
          for(Being being :reproduce(zebra, parent)) {
            if(locate(being, zebra.getLoc()))
              zebras.add(being);
          }
        } else {*/
          updateBeing(zebra);
        //}
      } else {
        mark[(int) zebra.getLoc().x][(int) zebra.getLoc().y] = false;
        zebras.remove(i--);
      }
    }
  }
  
  public boolean locate(Being being, Point center) {
    int cx = (int) center.x, cy = (int) center.y;
    for(int d = 1; d < cells.length; d++) {
      for(int i = max(cx - d, 0); i <= min(cx + d, cells.length - 1); i++)
        for(int j = max(cy - d, 0); j <= min(cy + d, cells[i].length - 1); j++)
          if(!mark[i][j]) {
            being.setLoc(new Point(i, j));
            mark[i][j] = true;
            return true;
          }
    }
    return false;
  }
  
  public void updateBeing(Being being) {
    moveBeing(being, being.move(cells, zebras));
    being.eat(cells[(int) being.getLoc().x][(int) being.getLoc().y]);
    being.metabolise();
  }
  
  public void moveBeing(Being being, Point movement) {
    Point act = being.getLoc();
    Point next = act.sum(movement);
    int ax = (int) act.x, ay = (int) act.y;
    int nx = (int) next.x, ny = (int) next.y;
    if((ax == nx && ay == ny) || (isInside(nx, ny) && !mark[nx][ny])) {
      mark[nx][ny] = true;
      mark[ax][ay] = false;
      being.setLoc(next);
    }
    act = being.getLoc();
  }
  
  public Being[] reproduce(Being mother, Being parent) {
    if(parent != null) {
      if(mother.getLoc().dist(parent.getLoc()) < 2.0)
        return mother.reproduce(parent);
      moveBeing(mother, mother.moveToParent(parent));
    } else {
      moveBeing(mother, mother.levy());
      mother.metabolise();
    }
    return new Being[0];
  }
  
  public boolean isInside(int x, int y) {
    return x > 0 && x < cells.length && y > 0 && y < cells[0].length;
  }
  
  public void draw(PGraphics pg) {
    drawFloor(pg);
    for(int i = 0; i < rows; i++)
      for(int j = 0; j < cols; j++)
        cells[i][j].draw(pg, size);
    for(Being zebra: zebras)
      drawZebra(pg, (Zebra) zebra, size);
  }
  
  private void drawFloor(PGraphics pg) {
    pg.stroke(0);
    pg.fill(200, 138, 35);
    pg.rect(top.x, top.y, rows * size, cols * size);
  }
  
  private void drawZebra(PGraphics pg, Zebra zebra, float size) {
    Point loc = zebra.getLoc();
    pg.stroke(255, 255, 255);
    pg.fill(255, 255, 255);
    pg.pushMatrix();
    pg.translate(top.x + (loc.x * size) + (size / 2.0), top.y + (loc.y * size) + (size / 2.0), size / 2.0);
    pg.box(size);
    pg.popMatrix();
  }
  
}