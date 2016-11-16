public class Resource {
  private float amount;
  private float[] increment;
  private int season;
  private float limit;
  
  public Resource(float amount, float[] increment, float limit) {
    this.amount = amount;
    this.increment = increment;
    this.limit = limit;
    this.season = 0;
  }
  
  public void changeSeason() {
    season = (season + 1) % increment.length;
  }
  
  public void increase() {
    amount = min(amount + increment[season], limit);
  }
  
  public float decrease(float size) {
    float dec = min(size, amount);
    amount -= dec;
    return dec;
  }
  
  public float getAmount() {
    return amount;
  }
  
}