public class TreeGenerator {
  
  public String[] sequences;
  
  public TreeGenerator() {
    OLSystem system1 = new OLSystem();
    system1.addRule("F", "FF-[-^F+.F+.F]+[+.F-^F-^F]");
    OLSystem system2 = new OLSystem();
    system2.addRule("F", "F[+.F]F[-^F][F]");
    OLSystem system3 = new OLSystem();
    system3.addRule("X", "F-^[[X]+.X]+.F[+.FX]-^X");
    system3.addRule("F", "FF");
    sequences = new String[] {system1.replace("F", 2), system2.replace("F", 3), system1.replace("X", 3)};
  }
  
  public Tree generate(int gen, Point root, float size) {
    return (gen == 0)? generate1(root, size) : ((gen == 1)? generate2(root, size) : generate3(root, size));
  }
  
  public Tree generate1(Point root, float size) {
    return new Tree(sequences[0],
      root,
      new float[]{ size / 4.0, 3, 22.5, 70, 0.5, 0.2 }
    );
  }
  
  public Tree generate2(Point root, float size) {
    return new Tree(sequences[1],
      root,
      new float[]{ size / 4.0, 3, 20, 90, 0.3, 0 }
    );
  }
  
  public Tree generate3(Point root, float size) {
    return new Tree(sequences[2],
      root,
      new float[]{ size / 4.0, 3, 22.5, 70, 0.5, 0.3 }
    );
  }
  
}