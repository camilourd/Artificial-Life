package sand_pile;

import k_neigbours.gui.GridFrame;
import unalcol.random.integer.IntUniform;
import unalcol.random.raw.RawGenerator;
import unalcol.types.collection.vector.Vector;

public class Arena {
	private int[][] cells;
	private IntUniform genX, genY;
	public int width, height;
	public int[] dx = {-1,  0, 1, 0};
	public int[] dy = { 0, -1, 0, 1};
	private GridFrame window;
	
	public Arena(int width, int height, GridFrame window) {
		cells = new int[height][width];
		genX = new IntUniform(height);
		genY = new IntUniform(width);
		this.width = width;
		this.height = height;
		this.window = window;
		window.changeGrid(cells, 0);
		window.setVisible(true);
	}
	
	public int[][] getCells() {
		return cells;
	}
	
	public IntPoint pick() {
		return new IntPoint(genX.next(), genY.next());
	}
	
	public int get(IntPoint p) {
		return cells[p.x][p.y];
	}
	
	public void increase(IntPoint p) {
		cells[p.x][p.y]++;
	}
	
	boolean isValid(IntPoint p) {
		return p.x >= 0 && p.x < height && p.y >=0 && p.y < width;
	}
	
	public void distribute(IntPoint p) {
		for(IntPoint point: shuffle(next(p)))
			if(cells[p.x][p.y] > 0) {
				cells[p.x][p.y]--;
				increase(point);
			}
		window.changeGrid(cells, 1);
	}
	
	public Vector<IntPoint> shuffle(Vector<IntPoint> points) {
		int m = 0;
        int j, k;
        IntPoint temp;
        int n = points.size();
        RawGenerator g = RawGenerator.get(this);
        IntUniform ig = new IntUniform(n);
        RawGenerator.set(ig, g);
        int[] indices = ig.generate(2 * n);
        for (int i = 0; i < n; i++) {
            j = indices[m];
            m++;
            k = indices[m];
            m++;
            temp = points.get(j);
            points.set(j, points.get(k));
            points.set(k, temp);
        }
		return points;
	}

	public Vector<IntPoint> next(IntPoint p) {
		Vector<IntPoint> points = new Vector<IntPoint>();
		for(int i = 0; i < 4; i++) {
			IntPoint point = new IntPoint(p.x + dx[i], p.y + dy[i]);
			if(isValid(point))
				points.add(point);
		}
		return points;
	}
	
	public int diff(IntPoint p) {
		int sum = 0;
		for(IntPoint point: next(p))
			sum += Math.abs(get(p) - get(point));
		return sum;
	}

}
