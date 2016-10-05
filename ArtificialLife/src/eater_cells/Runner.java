package eater_cells;

import java.awt.Color;

import eater_cells.environment.Trough;
import k_neigbours.gui.GridFrame;

public class Runner {

	public static void main(String[] args) {
		int width = 640;
		int height = 640; 
		int size = 8; // square size in pixels
		
		Trough trough = new Trough(width / size, height / size, 50, 0.2);
		trough.init(100, 10, 6);
		
		GridFrame window = new GridFrame(width, height, size);
		window.add(Color.BLACK);
		window.add(Color.BLUE);
		window.add(Color.CYAN);
		window.add(Color.GREEN);
		window.add(Color.RED);
		window.add(Color.YELLOW);
		window.changeGrid(trough.getDraw(), 0);
		window.setVisible(true);
		
		while(true) {
			trough.step(window);
		}
	}

}
