public class Polution {
  private float amount;
  private float evaporation;
  
  public Polution(float amount, float evaporation) {
    this.amount = amount;
    this.evaporation = evaporation;
  }
  
  public void increase(float increment) {
    amount += increment;
  }
  
  public void decrease() {
    amount = max(0, amount - evaporation);
  }
  
  public float getAmount() {
    return amount;
  }
  
  public void draw(PGraphics pg, Point center, float size) {
    pg.pushMatrix();
    pg.noStroke();
    pg.fill(185, 122, 87);
    //pg.translate(center.x, center.y);
    //pg.sphere(size / 4);
    pg.ellipse(center.x, center.y, size / 2.0, size / 2.0);
    pg.popMatrix();
  }
  
}