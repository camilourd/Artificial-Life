public class Cell {
  
  public Resource resource;
  public Polution polution;
  public Point center;
  public Tree tree;
  
  public Cell(Resource resource, Polution polution, Point center, Tree tree) {
    this.resource = resource;
    this.polution = polution;
    this.center = center;
    this.tree = tree;
  }
  
  public void draw(PGraphics pg, float size, boolean trees, boolean floor) {
    if(resource.getAmount() >= 1.0) {
      if(floor) {
        pg.stroke(0);
        if(resource.getAmount() <= 40)
          pg.fill(0, 0, 255);
        else if(resource.getAmount() <= 100)
          pg.fill(0, 255, 0);
        else
          pg.fill(255, 0, 0);
        float d = size / 2;
        pg.rect(center.x - d, center.y - d, size, size);
      }
      if(resource.getAmount() > 40 && trees)
        tree.draw(pg);
    }
  }
  
}