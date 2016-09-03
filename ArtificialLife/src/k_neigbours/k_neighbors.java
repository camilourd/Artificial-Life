package k_neigbours;

import java.awt.Color;

import k_neigbours.environment.Neighborhood;
import k_neigbours.gui.GridFrame;

public class k_neighbors {

	public static void main(String[] args) {
		int width = 1200;
		int height = 740; 
		int size = 1; // square size in pixels
		int k = 3;
		
		Neighborhood neigborhood = new Neighborhood(width / size, height / size);
		
		GridFrame window = new GridFrame(width, height, size);
		window.add(Color.BLACK);
		window.add(Color.BLUE);
		window.add(Color.RED);
		window.add(Color.YELLOW);
		window.changeGrid(neigborhood.cells);
		window.setVisible(true);
		
		while(true) {
			int idx = (int) (Math.random() * neigborhood.occupied.size());
			int loc = neigborhood.occupied.get(idx);
			if(neigborhood.count(loc / neigborhood.width, loc % neigborhood.width) >= k)
				neigborhood.move(idx);
			window.changeGrid(neigborhood.cells);
		}
	}

}
