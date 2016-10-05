package sand_pile;

import java.awt.Color;

import k_neigbours.gui.GridFrame;
import unalcol.types.collection.list.Queue;
import unalcol.types.collection.vector.Vector;

public class SandPile {

	public static void main(String[] args) throws InterruptedException {
		int width = 740;
		int height = 740;
		int size = 10; // square size in pixels
		int maxval = 4;
		
		GridFrame window = new GridFrame(width, height, size);
		window.add(Color.BLACK);
		window.add(Color.BLUE);
		window.add(Color.CYAN);
		window.add(Color.YELLOW);
		window.add(Color.RED);
		window.add(Color.GREEN);
		window.add(Color.GRAY);
		Arena arena = new Arena(width / size, height / size, window);
		
		Queue<IntPoint> q = new Queue<IntPoint>();
		//Vector<IntPoint> points = new Vector<IntPoint>();
		//for(int i = 0; i < 10; i++)
			//points.add(arena.pick());
		while(true) {
			IntPoint p = arena.pick();
			//IntPoint p = new IntPoint(height / (2 * size), width / (2 * size));
			//for(IntPoint p: arena.shuffle(points)) {
				arena.increase(p);
				q.add(p);
				while(!q.isEmpty()) {
					p = q.get();
					q.del();
					if(arena.get(p) >= maxval) {
						while(arena.get(p) >= maxval)
							arena.distribute(p);
						for(IntPoint point: arena.shuffle(arena.next(p)))
							if(arena.get(point) >= maxval)
								q.add(point);
					}
				}
				window.changeGrid(arena.getCells(), 5);
			//}
		}
	}

}
