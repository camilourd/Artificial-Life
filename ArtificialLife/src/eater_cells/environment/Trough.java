package eater_cells.environment;

import eater_cells.types.Point;
import k_neigbours.gui.GridFrame;
import unalcol.random.integer.IntUniform;
import unalcol.random.real.GaussianGenerator;
import unalcol.types.collection.vector.Vector;

public class Trough {
	
	public double[][] food;
	public double[][][] increment;
	public double[][] limit;
	public int width, height;
	
	public double[][] polution;
	public double[][] evaporation;
	
	protected Vector<Being> beings;
	protected boolean[][] mark;
	protected Point[] poles;
	protected double sigma;
	protected GaussianGenerator gen;
	
	protected double[] rates = new double[]{1.0, 0.125}; // pole regeneration
	protected int it = 0, icc = 0;
	protected int flip_season_period = 800;
	protected int min_energy = 50;
	
	public Trough(int width, int height, int alpha, double sigma) {
		this.width = width;
		this.height = height;
		this.sigma = sigma;
		this.gen = new GaussianGenerator(alpha / 6, alpha / 5);
		this.food = new double[height][width];
		this.limit = new double[height][width];
		this.poles = new Point[]{new Point(height - 20, 20), new Point(20, width - 20)};
		this.increment = new double[2][height][width];
		this.mark = new boolean[height][width];
		for(int i = 0; i < poles.length; i++)
			initField(i, alpha, sigma);
		this.polution = new double[height][width];
		this.evaporation = new double[height][width];
		for(int x = 0; x < height; x++)
			for(int y = 0; y < width; y++)
				this.evaporation[x][y] = Math.random();
	}

	private void initField(int pole, int alpha, double sigma) {
		Vector<Point> values = calculateValues(alpha, sigma);
		for(int x = 0; x < height; x++)
			for(int y = 0; y < width; y++) {
				int d = (int) poles[pole].dist(new Point(x, y));
				if(d < values.size()) {
					IntUniform gen = new IntUniform(values.get(d).y);
					food[x][y] += values.get(d).x + gen.generate();
					limit[x][y] += values.get(d).x + values.get(d).y - 1;
					increment[0][x][y] += rates[pole] / (d + 1.0);
					increment[1][x][y] += rates[(pole + 1) % 2] / (d + 1.0);
				}
			}
	}

	private Vector<Point> calculateValues(int alpha, double sigma) {
		Vector<Point> values = new Vector<Point>();
		int s = (int) (alpha * sigma);
		while(s > 0) {
			values.add(new Point(alpha - s, 2 * s + 1));
			alpha = (int) (alpha - (alpha / 10.0));
			s = (int) (alpha * sigma);
		}
		return values;
	}

	public boolean isValid(int x, int y) {
		return x >= 0 && x < height && y >= 0 && y < width;
	}
	
	public int[][] getDraw() {
		int[][] draw = new int[height][width];
		for(int i = 0; i < width; i++)
			for(int j = 0; j < height; j++)
				draw[j][i] = (food[j][i] >= 1)? ((food[j][i] > 15)? ((food[j][i] > 30)? ((food[j][i] > 45)? ((food[j][i] > 60)? 5 : 4) : 3) : 2) : 1) : 0;
		if(beings != null)
			for(Being being: beings)
				draw[being.loc.x][being.loc.y] = (being.isBaby())? 6 : ((being.isYoung())? 7 : ((being.isOld())? 9 : 8));
		return draw;
	}
	
	public void init(int beingsNumber, int alpha, int sigma) {
		beings = new Vector<Being>();
		
		IntUniform gens = new IntUniform(sigma * 2);
		IntUniform genx = new IntUniform(height);
		IntUniform geny = new IntUniform(width);
		int x, y;
		for(int i = 0; i < beingsNumber; i++) {
			do {
				x = genx.generate();
				y = geny.generate();
			} while(mark[x][y]);
			beings.add(new Being(
					alpha - sigma + gens.generate(), // vision
					min_energy + (int) (Math.random() * 51), // energy
					1 + (int) (Math.random() * 10), // min
					1 + (int) (Math.random() * 10), // max
					1 + (int) (Math.random() * 10), // metabolism
					100 + (int) (Math.random() * 400), // limit
					1 + (int) (Math.random() * 10 * flip_season_period),
					new Point(x, y)));
			mark[x][y] = true;
		}
	}

	public void step(GridFrame window) {
		for(int i = 0; i < beings.size(); i++) {
			Point p = beings.get(i).search(food, polution);
			Point act = beings.get(i).loc;
			Point next = new Point(act.x + p.x, act.y + p.y);
			if(isValid(next.x, next.y) && !mark[next.x][next.y]) {
				mark[act.x][act.y] = false;
				mark[next.x][next.y] = true;
				beings.get(i).loc = next;
			}
			window.changeGrid(getDraw(), 4);
			beings.get(i).eat(food, polution);
		}
		killBeings(window);
		increaseFood(window);
		evaporatePolution(window);
	}

	private void killBeings(GridFrame window) {
		Vector<Being> alife = new Vector<Being>();
		for(int i = 0; i < beings.size(); i++) {
			Being ind = beings.get(i);
			mark[ind.loc.x][ind.loc.y] = false;
			if(ind.energy > 0) {
			    if(ind.isNaturalDeath()) {
			    	Vector<Being> offspring = breed(ind, 1 + (int) (Math.random() * (ind.energy / min_energy))); 
					for(int j = 0; j < offspring.size(); j++)
						alife.add(offspring.get(j));
			    } else {
			    	alife.add(beings.get(i));
			    	mark[ind.loc.x][ind.loc.y] = true;
			    }
			} else {
				polution[ind.loc.x][ind.loc.y] += ind.limit / 10;
			}
		}
		beings = alife;
		window.changeGrid(getDraw(), 4);
	}
	
	private Vector<Being> breed(Being being, int total) {
		Vector<Being> offspring = new Vector<Being>();
		for(int i = 0; i < total; i++) {
			Being child = being.clone();
			child.energy = being.energy / total;
			child.loc = findAvailableLocation(being.loc);
			child.mutate();
			if(child.loc != null) offspring.add(child);
		}
		return offspring;
	}

	private Point findAvailableLocation(Point loc) {
		for(int d = 0; d < Math.max(height, width); d++)
			for(int x = loc.x - d; x <= loc.x + d; x++)
				for(int y = loc.y - d; y <= loc.y + d; y++)
					if(isValid(x, y) && !mark[x][y]) {
						mark[x][y] = true;
						return new Point(x, y);
					}
		return null; 
	}

	private void increaseFood(GridFrame window) {
		it = (it + 1) % flip_season_period;
		if(it == 0) icc = (icc + 1) % rates.length;
		for(int x = 0; x < height; x++)
			for(int y = 0; y < width; y++)
				food[x][y] = Math.min(limit[x][y], food[x][y] + increment[icc][x][y]);
	}
	
	private void evaporatePolution(GridFrame window) {
		for(int x = 0; x < height; x++)
			for(int y = 0; y < width; y++)
				polution[x][y] = Math.max(0.0, polution[x][y] - evaporation[x][y]);
	}

}
