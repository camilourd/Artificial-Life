package k_neigbours;

import java.awt.Color;

import k_neigbours.environment.Neighborhood;
import k_neigbours.gui.GridFrame;

public class k_neighbors {

	public static void main(String[] args) {
		int width = 700;
		int height = 700; 
		int size = 5; // square size in pixels
		int k = 3;
		
		Neighborhood neigborhood = new Neighborhood(width / size, height / size);
		
		GridFrame window = new GridFrame(width, height, size);
		window.add(Color.BLACK);
		window.add(Color.GREEN);
		window.add(Color.RED);
		window.add(Color.ORANGE);
		window.add(Color.YELLOW);
		window.changeGrid(neigborhood.cells, 0);
		window.setVisible(true);
		
		while(true) {
			int idx = (int) (Math.random() * neigborhood.occupied.size());
			int loc = neigborhood.occupied.get(idx);
			if(neigborhood.count(loc / neigborhood.width, loc % neigborhood.width) >= k)
				neigborhood.move(idx);
			window.changeGrid(neigborhood.cells, 0);
		}
	}

}
