public class Leopard extends Being {
  
  private AnimalCoat generator;
  
  public Leopard(Point loc, float[] characteristics) {
    super(loc, characteristics, new PImage((new AnimalCoat(AnimalCoat.ZEBRA, 23, 2.9, 2000)).toImage(32, 32, Color.BLACK, Color.YELLOW)));
  }
  
  @Override
  public Point move(Cell[][] cells, ArrayList<Being> zebras, ArrayList<Being> leopards) {
    ArrayList<Being> preys = getNeighbours(zebras);
    Point direction = new Point(0,0);
    if(preys.size() > 0) {
      Being prey = findClosest(preys);
      direction = (loc.substract(prey.getLoc())).normalize(VEL);
    }
    dir = (direction.size() < 0.0001)? levy() : direction;
    return dir;
  }
  
  @Override
  public Being generate(Point loc, float[] characteristics) {
    return new Leopard(loc, characteristics);
  }
  
  @Override
  public boolean isPossibleParent(Being being) {
    double dist = loc.dist(being.loc);
    return 0.1 <= dist && dist <= characteristics[VISION];
  }
  
  @Override
  public void eat(Cell[][] cells, ArrayList<Being> zebras, ArrayList<Being> leopards) {
    Being prey = findClosest(zebras);
    if(prey != null && prey.getLoc().dist(loc) < 1.5) {
      float amount = prey.energy;
      energy = min(characteristics[LIMIT], energy + amount);
      cells[(int) loc.x][(int) loc.y].polution.increase(characteristics[POLUTION]);
      zebras.remove(prey);
    }
  }
  
}