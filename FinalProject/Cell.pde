public class Cell {
  
  public Resource resource;
  public Polution polution;
  public Point center;
  
  public Cell(Resource resource, Polution polution, Point center) {
    this.resource = resource;
    this.polution = polution;
    this.center = center;
  }
  
  public void draw(PGraphics pg, float size) {
    if(resource.getAmount() >= 1.0) {
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
  }
  
}