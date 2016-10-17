package eater_cells.environment;

import eater_cells.types.Point;

public class Being {
	
	public int range;
	public Point loc;
	// Lévy walk
	public Point dir;
	public double acc = 5.0;
	// muere y deja la riqueza, reparte la riqueza a los hijos cerca a mi, cerca de la muerte
	public int energy;
	public int min, max; // mínimo y máximo que consume
	public int metabolism; // cuanto consume
	public int limit; // máximo que puede cargar
	public int age_limit; // máximo que vive
	public int age;
	
	public Being(int range, int energy, int min, int max, int metabolism, int limit, int age_limit, Point loc) {
		this.range = range;
		this.energy = energy;
		this.min = Math.min(min, max);
		this.max = Math.max(min, max);
		this.metabolism = metabolism;
		this.loc = loc;
		this.limit = limit;
		this.age_limit = age_limit;
		this.age = 0;
	}
	
	public Point search(double[][] food, double[][] polution) {
		Point mp = new Point(loc.x, loc.y);
		double best = pull(food[loc.x][loc.y], polution[loc.x][loc.y]);
		energy -= metabolism;
		age++;
		for(int dx = -range; dx <= range; dx++)
			for(int dy = -range; dy <= range; dy++) {
				Point p = new Point(loc.x + dx, loc.y + dy);
				if(isValid(p, food) && p.dist(loc) <= range) {
					double gravity = pull(food[p.x][p.y], polution[p.x][p.y]);
					if(best < gravity) {
						mp = p;
						best = gravity;
					}
				}
			}
		if(food[mp.x][mp.y] > 0) {
			int nx = mp.x - loc.x;
			int ny = mp.y - loc.y;
			return new Point((nx > 0)? 1 : ((nx < 0)? -1 : 0), (ny > 0)? 1 : ((ny < 0)? -1 : 0));
		} else {
			acc += Math.random();
			if(acc > 1.0) {
				acc = 0.0;
				dir = new Point((Math.random() < 0.5)? - 1 : 1, (Math.random() < 0.5)? - 1 : 1);
			}
			return dir;
		}
	}
	
	public double pull(double food, double polution) {
		return food / (1.0 + polution);
	}
	
	public boolean isValid(Point p, double[][] food) {
		return (p.x >= 0 && p.x < food.length) && (p.y >= 0 && p.y < food[0].length);
	}
	
	public void eat(double[][] food, double[][] polution) {
		if(food[loc.x][loc.y] >= min) {
			int amount = min + (int) (Math.random() * (max - min + 1));
			energy += Math.min(amount, limit - energy);
			food[loc.x][loc.y] = Math.max(0, food[loc.x][loc.y] - amount);
			polution[loc.x][loc.y] += amount;
		}
	}

	public boolean isNaturalDeath() {
		return age >= age_limit;
	}
	
	public Being clone() {
		return new Being(range, energy, min, max, metabolism, limit, age_limit, new Point(loc.x, loc.y));
	}

	public void mutate() {
		switch((int) (Math.random() * 6)) {
		case 0: range = Math.max(1, (Math.random() < 0.5)? range - 1 : range + 1);
		case 1: min = Math.max(1, (Math.random() < 0.5)? min - 1 : min + 1);
		case 2: max = Math.max(1, (Math.random() < 0.5)? max - 1 : max + 1);
		case 3: metabolism = Math.max(1, (Math.random() < 0.5)? metabolism - 1 : metabolism + 1);
		case 4: limit = Math.max(1, (Math.random() < 0.5)? limit - (limit / 10) : limit + (limit / 10));
		case 5: age_limit = Math.max(1, (Math.random() < 0.5)? age_limit - (age_limit / 10) : age_limit + (age_limit / 10));
		}
		min = Math.min(min, max);
		max = Math.max(min, max);
	}
	
	public boolean isBaby() {
		return age < age_limit / 3;
	}
	
	public boolean isYoung() {
		return age < age_limit / 2;
	}
	
	public boolean isOld() {
		return age > 7 * (age_limit / 8);
	}

}
