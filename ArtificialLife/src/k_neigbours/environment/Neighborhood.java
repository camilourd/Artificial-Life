package k_neigbours.environment;

import unalcol.random.integer.IntUniform;
import unalcol.types.collection.vector.Vector;

public class Neighborhood {
	
	public int[][] cells;
	public Vector<Integer> available;
	public Vector<Integer> occupied;
	public int width, height;
	private IntUniform avgen; 
	
	public Neighborhood(int width, int height) {
		cells = new int[height][width];
		available = new Vector<Integer>();
		occupied = new Vector<Integer>();
		IntUniform gen = new IntUniform(3);
		for(int i = 0; i < height; i++)
			for(int j = 0; j < width; j++) {
				cells[i][j] = gen.generate();
				if(cells[i][j] == 0)
					available.add(i * width + j);
				else
					occupied.add(i * width + j);
			}
		this.width = width;
		this.height = height;
		avgen = new IntUniform(available.size());
		
	}
	
	public int count(int i, int j) {
		int cnt = 0;
		for(int f = i - 1; f < i + 2; f++)
			for(int c = j - 1; c < j + 2; c++) {
				int fil = (f < 0)? height - 1 : ((f >= height)? 0 : f);
				int col = (c < 0)? width - 1 : ((c >= width)? 0 : c);
				if(cells[fil][col] > 0 && cells[i][j] != cells[fil][col])
					cnt++;
			}
		return cnt;
	}
	
	public void move(int idx) {
		int r = avgen.generate();
		int f = available.get(r) / width;
		int c = available.get(r) % width;
		int i = occupied.get(idx) / width;
		int j = occupied.get(idx) % width;
		available.remove(r);
		available.add(i * width + j);
		occupied.remove(idx);
		occupied.add(f * width + c);
		cells[f][c] = cells[i][j];
		cells[i][j] = 0;
	}

}
