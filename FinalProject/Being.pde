public abstract class Being {
  protected Point loc;
  protected float[] characteristics;
  protected double acc = 5.0;
  protected float energy;
  protected int age;
  
  protected Point dir, ldir;
  
  public final static int VISION = 0;
  public final static int MIN = 1;
  public final static int MAX = 2;
  public final static int METABOLISM = 3;
  public final static int LIMIT = 4;
  public final static int LIFE = 5;
  public final static int POLUTION = 6;
  public final static int REPRO_LIMIT = 7;
  
  public Being(Point loc, float[] characteristics) {
    this.loc = loc;
    this.characteristics = characteristics;
    this.energy = 50.0;
    this.age = 0;
    this.dir = randDir();
  }
  
  public abstract Point move(Cell[][] cells, ArrayList<Being> zebras);
  
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
    return (new Point(random(100) - 50, random(100) - 50)).normalize(1.0);
  }
  
  public Point getLoc() {
    return loc;
  }
  
  public void setLoc(Point loc) {
    this.loc = loc;
  }
  
  public boolean isAlive() {
    //return age < characteristics[LIFE] && energy > 0.0;
    return energy > 0.0;
  }
  
  public Point getDir() {
    return dir;
  }
  
  public boolean isPeriod() {
    return energy >= characteristics[REPRO_LIMIT] && age > characteristics[LIFE] / 3.0;
  }
  
  public Being[] reproduce(Being parent) {
    Being[] childs = xover(parent);
    for(Being child: childs)
      mutate(child);
    return childs;
  }
  
  public void mutate(Being being) {
    float size = (float) Math.random();
    int index = (int) random(being.characteristics.length);
    float diff = size * being.characteristics[index];
    being.characteristics[index] += (Math.random() < 0.5)? diff : -diff;
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
    child1.energy = energy / 2;
    energy -= child1.energy;
    Being child2 = generate(parent.loc, childs_characs[1]);
    child2.energy = parent.energy / 2;
    parent.energy -= child2.energy;
    return new Being[]{child1, child2};
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
  }
  
  public Point moveToParent(Being parent) {
    if(parent != null)
      return (parent.getLoc().substract(loc)).normalize(1.0);
    return levy();
  }
  
  public ArrayList<Being> findParents(ArrayList<Being> beings) {
    ArrayList<Being> parents = new ArrayList<Being>();
    for(Being being: beings)
      if(being.isPeriod() && isPossibleParent(being))
        parents.add(being);
    return parents;
  }
  
  public abstract boolean isPossibleParent(Being being);
  public abstract void eat(Cell cell);
  
}