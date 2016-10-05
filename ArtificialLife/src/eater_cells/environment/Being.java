package eater_cells.environment;

import sand_pile.IntPoint;

public class Being {
	
	public int range;
	public IntPoint loc;
	// Lévy walk
	public IntPoint dir;
	public double acc = 1.0;
	
	public int energy;
	public int min, max;
	public int delta;
	
	public Being(int range, int energy, int min, int max, int delta, IntPoint loc) {
		this.range = range;
		this.energy = energy;
		this.min = Math.min(min, max);
		this.max = Math.max(min, max);
		this.delta = delta;
		this.loc = loc;
	}
	
	public IntPoint search(int[][] food) {
		int mv = food[loc.x][loc.y], mx = loc.x, my = loc.y;
		energy -= delta;
		for(int i = Math.max(0, loc.x - range); i <= Math.min(loc.x + range, food.length - 1); i++)
			for(int j = Math.max(0, loc.y - range); j <= Math.min(loc.y + range, food[0].length - 1); j++)
				if(food[i][j] > mv) {
					mv = food[i][j];
					mx = i;
					my = j;
				}
		if(food[mx][my] > 0) {
			int nx = mx - loc.x;
			int ny = my - loc.y;
			return new IntPoint((nx > 0)? 1 : ((nx < 0)? -1 : 0), (ny > 0)? 1 : ((ny < 0)? -1 : 0));
		} else {
			acc += Math.random();
			if(acc > 1.0) {
				acc = 0.0;
				dir = new IntPoint((Math.random() < 0.5)? - 1 : 1, (Math.random() < 0.5)? - 1 : 1);
			}
			return dir;
		}
	}
	
	public void eat(int[][] food) {
		int amount = min + (int) (Math.random() * (max - min + 1));
		energy += Math.min(amount, food[loc.x][loc.y]);
		food[loc.x][loc.y] = Math.max(0, food[loc.x][loc.y] - amount);
	}

}
