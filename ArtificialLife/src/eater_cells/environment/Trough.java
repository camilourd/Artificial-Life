package eater_cells.environment;

import k_neigbours.gui.GridFrame;
import sand_pile.IntPoint;
import unalcol.random.integer.IntUniform;
import unalcol.types.collection.vector.Vector;

public class Trough {
	
	public int[][] food;
	public int width, height;
	
	protected Vector<Being> beings;
	
	public Trough(int width, int height, int alpha, double sigma) {
		this.food = new int[height][width];
		int x1 = height - 16;
		int y1 = width - 16;
		int x2 = 16;
		int y2 = 16;
		this.width = width;
		this.height = height;
				
		int d = 0, x, y;
		int s = (int) (alpha * sigma);
		while(s > 0) {
			IntUniform gen = new IntUniform(2 * s);
			
			for(y = y1 - d; y <= y1 + d; y++) {
				if(isValid(x2 - d, y))
					food[x2 - d][y] = alpha - s + gen.generate();
				if(isValid(x2 + d, y))
					food[x2 + d][y] = alpha - s + gen.generate();
			}
			
			for(y = y2 - d; y <= y2 + d; y++) {
				if(isValid(x1 - d, y))
					food[x1 - d][y] = alpha - s + gen.generate();
				if(isValid(x1 + d, y))
					food[x1 + d][y] = alpha - s + gen.generate();
			}
			
			for(x = x1 - d + 1; x < x1 + d; x++) {
				if(isValid(x, y2 - d))
					food[x][y2 - d] = alpha - s + gen.generate();
				if(isValid(x, y2 + d))
					food[x][y2 + d] = alpha - s + gen.generate();
			}
			
			for(x = x2 - d + 1; x < x2 + d; x++) {
				if(isValid(x, y1 - d))
					food[x][y1 - d] = alpha - s + gen.generate();
				if(isValid(x, y1 + d))
					food[x][y1 + d] = alpha - s + gen.generate();
			}
			d++;
			alpha = (int) (alpha - (alpha / 10.0));
			s = (int) (alpha * sigma);
		}
	}

	public boolean isValid(int x, int y) {
		return x >= 0 && x < height && y >= 0 && y < width;
	}
	
	public int[][] getDraw() {
		int[][] draw = new int[height][width];
		for(int i = 0; i < width; i++)
			for(int j = 0; j < height; j++)
				draw[j][i] = (food[j][i] > 0)? ((food[j][i] > 10)? ((food[j][i] > 20)? 3 : 2) : 1) : 0;
		if(beings != null)
			for(Being being: beings) {
				draw[being.loc.x][being.loc.y] = 4;
			}
		return draw;
	}
	
	public void init(int beingsNumber, int alpha, int sigma) {
		beings = new Vector<Being>();
		
		IntUniform gens = new IntUniform(sigma * 2);
		IntUniform genx = new IntUniform(height);
		IntUniform geny = new IntUniform(width);
		
		for(int i = 0; i < beingsNumber; i++) {
			boolean ok = true;
			int x, y;
			do {
				ok = true;
				x = genx.generate();
				y = geny.generate();
				for(int j = 0; j < i; j++)
					if(beings.get(j).loc.x == x && beings.get(j).loc.y == y)
						ok = false;
			} while(!ok);
			beings.add(new Being(
					alpha - sigma + gens.generate(),
					50 + (int) (Math.random() * 51), // energy
					1 + (int) (Math.random() * 10), // min
					1 + (int) (Math.random() * 10), // max
					1 + (int) (Math.random() * 10), // delta
					new IntPoint(x, y)));
		}
	}

	public void step(GridFrame window) {
		for(int i = 0; i < beings.size(); i++) {
			IntPoint p = beings.get(i).search(food);
			IntPoint next = new IntPoint(beings.get(i).loc.x + p.x, beings.get(i).loc.y + p.y);
			if(isValid(next.x, next.y)) {
				boolean ok = true;
				for(int j = 0; j < beings.size(); j++)
					if(i != j && next.x == beings.get(j).loc.x && next.y == beings.get(j).loc.y)
						ok = false;
				if(ok)
					beings.get(i).loc = next;
			}
			window.changeGrid(getDraw(), 5);
			beings.get(i).eat(food);
			window.changeGrid(getDraw(), 5);
		}
		clear(window);
		increase(window);
	}

	private void clear(GridFrame window) {
		Vector<Being> alife = new Vector<Being>();
		for(int i = 0; i < beings.size(); i++) {
			if(beings.get(i).energy > 0) {
				alife.add(beings.get(i));
			}
		}
		beings = alife;
		window.changeGrid(getDraw(), 5);
	}
	
	private void increase(GridFrame window) {
		
	}

}
