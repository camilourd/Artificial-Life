public class Zebra extends Being {
  
  public Zebra(Point loc, float[] characteristics) {
    super(loc, characteristics, new PImage((new AnimalCoat(AnimalCoat.ZEBRA, 23, 2.9, 2000)).toImage(32, 32, Color.BLACK, Color.WHITE)));
  }
  
  @Override
  public Point move(Cell[][] cells, ArrayList<Being> zebras, ArrayList<Being> leopards) {
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
    Point direction = new Point(0,0);
    ArrayList<Being> neighbours = getNeighbours(zebras);
    if(neighbours.size() > 1) {
      Point alignment = computeAlignment(neighbours);
      Point cohesion = computeCohesion(neighbours);
      Point separation = computeSeparation(neighbours);
      direction = direction.sum(new Point(
        alignment.x + cohesion.x + separation.x,
        alignment.y + cohesion.y + separation.y
      ).normalize(VEL));
    }
    
    if(cells[(int) destination.x][(int) destination.y].resource.getAmount() > 0.0)
      direction = direction.sum(loc.substract(destination).normalize(VEL));
    neighbours = getNeighbours(leopards);
    if(neighbours.size() > 0) {
      Point total = new Point(0,0);
      for(Being being: neighbours)
        total = total.sum(being.getLoc().substract(loc));
      direction = direction.sum(total.normalize(VEL));
    }
    dir = (direction.size() < 0.0001)? levy() : direction.normalize(VEL);
    return dir;
  }
  
  public Point computeAlignment(ArrayList<Being> zebras) {
    float x = 0.0, y = 0.0;
    for(Being zebra: zebras) {
      x += zebra.getDir().x;
      y += zebra.getDir().y;
    }
    x /= zebras.size();
    y /= zebras.size();
    return new Point(x, y).normalize(VEL);
  }
  
  public Point computeCohesion(ArrayList<Being> zebras) {
    float x = 0.0, y = 0.0;
    for(Being zebra: zebras) {
        x += zebra.getLoc().x;
        y += zebra.getLoc().y;
    }
    x = (x / zebras.size()) - loc.x;
    y = (y / zebras.size()) - loc.y;
    return new Point(x, y).normalize(VEL);
  }
  
  public Point computeSeparation(ArrayList<Being> zebras) {
    float x = 0.0, y = 0.0;
    for(Being zebra: zebras) {
        x += loc.x - zebra.getLoc().x;
        y += loc.y - zebra.getLoc().y;
    }
    x /= zebras.size();
    y /= zebras.size();
    return new Point(x, y).normalize(VEL);
  }
  
  public float evaluate(Cell cell) {
    return cell.resource.getAmount() / (1.0 + cell.polution.getAmount());
  }
  
  @Override
  public void eat(Cell[][] cells, ArrayList<Being> zebras, ArrayList<Being> leopards) {
    int x = (int) loc.x, y = (int) loc.y;
    if(cells[x][y].resource.getAmount() >= characteristics[MIN]) {
      float amount = characteristics[MIN] + random(characteristics[MAX] - characteristics[MIN]);
      energy += min(amount, characteristics[LIMIT] - energy);
      cells[x][y].resource.decrease(amount);
      cells[x][y].polution.increase(characteristics[POLUTION]);
    }
  }
  
  @Override
  public Being generate(Point loc, float[] characteristics) {
    return new Zebra(loc, characteristics);
  }
  
  @Override
  public boolean isPossibleParent(Being being) {
    double dist = loc.dist(being.loc);
    return 0.1 <= dist && dist <= characteristics[VISION];
  }
  
}