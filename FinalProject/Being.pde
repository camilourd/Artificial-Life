public abstract class Being {
  protected Point loc;
  protected float[] characteristics;
  protected double acc = 5.0;
  protected float energy;
  protected int age;
  protected PImage coat;
  
  protected Point dir, ldir;
  
  public final static int VISION = 0;
  public final static int MIN = 1;
  public final static int MAX = 2;
  public final static int METABOLISM = 3;
  public final static int LIMIT = 4;
  public final static int LIFE = 5;
  public final static int POLUTION = 6;
  public final static int REPRO_LIMIT = 7;
  public final static int REPRO_PERIOD = 8;
  
  public float VEL = 1.0;
  private boolean rep_per;
  public float li = 0.6;
  
  public Being(Point loc, float[] characteristics, PImage coat) {
    this.loc = loc;
    this.characteristics = characteristics;
    this.energy = 200.0;
    this.age = 0;
    this.dir = randDir();
    float min = characteristics[MIN];
    float max = characteristics[MAX];
    characteristics[MIN] = min(min, max);
    characteristics[MAX] = max(min, max);
    this.coat = coat;
    this.rep_per = false;
  }
  
  public abstract Point move(Cell[][] cells, ArrayList<Being> zebras, ArrayList<Being> leopards);
  
  public Point levy() {
    acc += Math.random();
    if(acc > 1.0) {
      acc = 0.0;
      ldir = randDir();
    }
    dir = ldir;
    return ldir;
  }
  
  public Point randDir() {
    return (new Point(random(100) - 50, random(100) - 50)).normalize(VEL);
  }
  
  public Point getLoc() {
    return loc;
  }
  
  public void setLoc(Point loc) {
    this.loc = loc;
  }
  
  public boolean isAlive() {
    return age < characteristics[LIFE] && energy > 0.0;
  }
  
  public Point getDir() {
    return dir;
  }
  
  public boolean isPeriod() {
    return energy >= characteristics[REPRO_LIMIT] && age > characteristics[LIFE] / 3.0 && isReproductivePeriod();
  }
  
  int cnt = 0;
  public boolean isReproductivePeriod() {
    if(age % (int) characteristics[REPRO_PERIOD] == 0) {
      cnt = (cnt + 1) % 4;
      if(cnt == 0)
        rep_per = !rep_per;
    }
    return rep_per;
  }
  
  public Being[] reproduce(Being parent) {
    Being[] childs = xover(parent);
    energy /= 2.0;
    parent.energy /= 2.0;
    childs[0].energy = max(100, energy);
    childs[1].energy = max(100, parent.energy);
    return childs;
  }
  
  public Being mutate(Being being) {
    float size = (float) Math.random();
    int index = (int) random(being.characteristics.length);
    float diff = (size * being.characteristics[index]) / 10.0;
    being.characteristics[index] += (Math.random() < 0.5)? diff : -diff;
    if(being.characteristics[index] < 1.0) being.characteristics[index] = 1.0;
    return generate(being.getLoc(), being.characteristics);
  }
  
  public Being[] xover(Being parent) {
    float[][] childs_characs = new float[2][characteristics.length];
    int xoverpoint = (int) random(characteristics.length);
    for(int i = 0; i < characteristics.length; i++)
      if(i < xoverpoint) {
        childs_characs[0][i] = characteristics[i];
        childs_characs[1][i] = parent.characteristics[i];
      } else {
        childs_characs[0][i] = parent.characteristics[i];
        childs_characs[1][i] = characteristics[i];
      }
    Being child1 = generate(loc, childs_characs[0]);
    Being child2 = generate(parent.loc, childs_characs[1]);
    return new Being[]{mutate(child1), mutate(child2)};
  }
  
  public float speed() {
    return fspeed(age / characteristics[LIFE]);
  }
  
  public float fspeed(float x) {
    return (-1.5 * x - 0.4) * (x - 1) + li;
  }
  
  public abstract Being generate(Point loc, float[] characteristics);
  
  public Being findClosest(ArrayList<Being> beings) {
    Being parent = null;
    float best = characteristics[VISION] * 2;
    for(Being being: beings) {
      float d = loc.dist(being.getLoc());
      if(d < best) {
        best = d;
        parent = being;
      }
    }
    return parent;
  }
  
  public void metabolise() {
    energy -= characteristics[METABOLISM];
    age++;
    VEL = speed();
  }
  
  public Point moveToParent(Being parent) {
    dir = (parent != null)? (loc.substract(parent.getLoc())).normalize(VEL) : levy();
    return dir;
  }
  
  public ArrayList<Being> findParents(ArrayList<Being> beings) {
    ArrayList<Being> parents = new ArrayList<Being>();
    for(Being being: beings)
      if(being.isPeriod() && isPossibleParent(being))
        parents.add(being);
    return parents;
  }
  
  public abstract boolean isPossibleParent(Being being);
  public abstract void eat(Cell[][] cells, ArrayList<Being> zebras, ArrayList<Being> leopards);
  
  public ArrayList<Being> getNeighbours(ArrayList<Being> beings) {
    ArrayList<Being> neighbours = new ArrayList<Being>();
    for(Being being: beings)
      if(loc.dist(being.getLoc()) <= characteristics[VISION])
        neighbours.add(being);
    return neighbours;
  }
  
}