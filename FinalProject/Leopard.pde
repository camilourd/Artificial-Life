public class Leopard extends Being {
  
  private int delay;
  
  public Leopard(Point loc, float[] characteristics) {
    super(loc, characteristics, new PImage((new AnimalCoat(AnimalCoat.LEOPARD, 23, 2.9, 2000)).toImage(32, 32, Color.BLACK, Color.YELLOW)));
    //this.characteristics[REPRO_PERIOD] *= 1.2;
    this.delay = 0;
    //this.characteristics[MIN_SPEED] = max(0.6, characteristics[MIN_SPEED]);
    //this.characteristics[VISION] *= 1.2;
  }
  
  public boolean isWaiting() {
    if(delay > 0)
      return true;
    return false;
  }
  
  @Override
  public Point move(Cell[][] cells, ArrayList<Being> zebras, ArrayList<Being> leopards) {
    ArrayList<Being> preys = getNeighbours(zebras);
    Point direction = new Point(0,0);
    if(isWaiting())
      return direction;
    if(preys.size() > 0) {
      Being prey = findClosest(preys);
      Being slowest = findSlowest(preys);
      direction = (loc.substract(prey.getLoc())).normalize(VEL);
      direction = direction.sum((loc.substract(slowest.getLoc())).normalize(VEL)).normalize(VEL);
    }
    dir = (direction.size() < 0.0001)? levy() : direction;
    return dir;
  }
  
  public Being findSlowest(ArrayList<Being> beings) {
    if(beings.size() > 0) {
      Being slowest = beings.get(0);
      for(Being being: beings)
        if(slowest.speed() < being.speed())
          slowest = being;
      return slowest;
    }
    return null;
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
    delay--;
    if(prey != null && prey.getLoc().dist(loc) < 1.0 && !isWaiting()) {
      float amount = prey.energy;
      energy = min(characteristics[LIMIT], energy + amount);
      cells[(int) loc.x][(int) loc.y].polution.increase(characteristics[POLUTION]);
      zebras.remove(prey);
      delay = (int) random(energy / (10.0 * characteristics[METABOLISM]));
    } else if(isWaiting()) {
      cells[(int) loc.x][(int) loc.y].polution.increase(characteristics[POLUTION]);
    }
  }
  
}