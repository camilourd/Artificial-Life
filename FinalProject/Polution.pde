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
  
}