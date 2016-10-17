package eater_cells;

import java.awt.Color;

import eater_cells.environment.Trough;
import k_neigbours.gui.GridFrame;

public class Runner {

	public static void main(String[] args) {
		int width = 640;
		int height = 640; 
		int size = 8; // square size in pixels
		// cada casilla tiene una capacidad de limpieza propia
		Trough trough = new Trough(width / size, height / size, 160, 0.2);
		trough.init(100, 10, 6);
		
		GridFrame window = new GridFrame(width, height, size);
		window.add(Color.BLACK);
		window.add(Color.BLUE);
		window.add(Color.CYAN);
		window.add(new Color(34, 177, 76));
		window.add(Color.GREEN);
		window.add(Color.YELLOW);
		window.add(Color.WHITE);
		window.add(Color.RED);
		window.add(new Color(255, 127, 39));
		window.add(new Color(128, 0, 128));
		window.changeGrid(trough.getDraw(), 5);
		window.setVisible(true);
		
		while(true) {
			trough.step(window);
		}
	}

}
