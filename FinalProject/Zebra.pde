public class Zebra extends Being {
  
  public Zebra(Point loc, float[] characteristics) {
    super(loc, characteristics);
  }
  
  @Override
  public Point move(Cell[][] cells, ArrayList<Being> zebras) {
    Point destination = loc;
    float best = evaluate(cells[(int) loc.x][(int) loc.y]);
    float vision = characteristics[VISION];
    for(int i = (int) max(loc.x - vision, 0); i <= min(loc.x + vision, cells.length - 1); i++) {
      for(int j = (int) max(loc.y - vision, 0); j <= min(loc.y + vision, cells[i].length - 1); j++) {
        Point position = new Point(i, j);
        if(position.dist(loc) <= vision) {
          float quality = evaluate(cells[i][j]);
          if(quality > best) {
            best = quality;
            destination = position;
          }
        }
      }
    }
    if(cells[(int) destination.x][(int) destination.y].resource.getAmount() > 0.0) {
      ArrayList<Zebra> neighbours = getNeighbours(zebras);
      Point direction = new Point(0, 0);
      if(neighbours.size() > 1) {
        Point alignment = computeAlignment(neighbours);
        Point cohesion = computeCohesion(neighbours);
        Point separation = computeSeparation(neighbours);
        direction.sum(new Point(
          alignment.x + cohesion.x + separation.x,
          alignment.y + cohesion.y + separation.y
        ).normalize(1.0));
      }
      Point p = new Point(destination.x - loc.x, destination.y - loc.y).normalize(1.0);
      dir = new Point(p.x + direction.x, p.y + direction.y).normalize(1.0);
      return dir;
    }
    return levy();
  }
  
  public ArrayList<Zebra> getNeighbours(ArrayList<Being> zebras) {
    ArrayList<Zebra> neighbours = new ArrayList<Zebra>();
    for(Being zebra: zebras)
      if(loc.dist(zebra.getLoc()) <= characteristics[VISION])
        neighbours.add((Zebra) zebra);
    return neighbours;
  }
  
  public Point computeAlignment(ArrayList<Zebra> zebras) {
    float x = 0.0, y = 0.0;
    for(Zebra zebra: zebras) {
      x += zebra.getDir().x;
      y += zebra.getDir().y;
    }
    return new Point(x, y).normalize(1.0);
  }
  
  public Point computeCohesion(ArrayList<Zebra> zebras) {
    float x = 0.0, y = 0.0;
    for(Zebra zebra: zebras) {
        x += zebra.getLoc().x;
        y += zebra.getLoc().y;
    }
    x = (x / (zebras.size() - 1)) - loc.x;
    y = (y / (zebras.size() - 1)) - loc.y;
    return new Point(x, y).normalize(1.0);
  }
  
  public Point computeSeparation(ArrayList<Zebra> zebras) {
    float x = 0.0, y = 0.0;
    for(Zebra zebra: zebras) {
        x += zebra.getLoc().x - loc.x;
        y += zebra.getLoc().y - loc.y;
    }
    x /= -zebras.size() + 1;
    y /= -zebras.size() + 1;
    return new Point(x, y).normalize(1.0);
  }
  
  public float evaluate(Cell cell) {
    return cell.resource.getAmount() / (1.0 + cell.polution.getAmount());
  }
  
  public void eat(Cell cell) {
    if(cell.resource.getAmount() >= characteristics[MIN]) {
      float amount = max(random(characteristics[MAX]), min(characteristics[METABOLISM], characteristics[MAX]));
      energy = min(characteristics[LIMIT], energy + cell.resource.decrease(amount) * 500);
      cell.polution.increase(characteristics[POLUTION]);
    }
  }
  
  @Override
  public Being generate(Point loc, float[] characteristics) {
    return new Zebra(loc, characteristics);
  }
  
  @Override
  public boolean isPossibleParent(Being being) {
    return loc.dist(being.loc) <= characteristics[VISION];
  }
  
}