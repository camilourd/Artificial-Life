public class Tree {
  
  private Point root;
  private float[] characteristics;
  private String sequence;
  
  public final static int SIZE = 0;
  public final static int WEIGHT = 1;
  public final static int DELTA = 2;
  public final static int GAMMA = 3;
  public final static int DW = 4;
  public final static int DD = 5;
  
  public Tree(String sequence, Point root, float[] characteristics) {
    this.root = root;
    this.characteristics = characteristics;
    this.sequence = sequence;
  }
  
  public void setRoot(Point root) {
    this.root = root;
  }
  
  public void draw(PGraphics pg) {
    float s = characteristics[WEIGHT], l = characteristics[SIZE];
    pg.pushMatrix();
    pg.stroke(0, 128, 0);
    pg.translate(root.x, root.y, 0);
    pg.rotateY(radians(-90));
    for(int i = 0; i < sequence.length(); i++) {
      char c = sequence.charAt(i);
      if(c == 'F') {
        pg.strokeWeight(s);
        pg.line(0, 0, l, 0);
        pg.translate(l, 0, 0);
      } else if(c == '+') {
        pg.rotateY(radians(-characteristics[DELTA]));
      } else if(c == '-') {
        pg.rotateY(radians(characteristics[DELTA]));
      } else if(c == '[') {
        pg.pushMatrix();
        s *= (1 - characteristics[DW]);
        l *= (1 - characteristics[DD]);
      } else if(c == ']') {
        pg.popMatrix();
        s /= (1 - characteristics[DW]);
        l /= (1 - characteristics[DD]);
      } else if(c == '.') {
        pg.rotateX(radians(-characteristics[GAMMA]));
      } else if(c == '^') {
        pg.rotateX(radians(characteristics[GAMMA]));
      }
    }
    pg.popMatrix();
  }
  
}