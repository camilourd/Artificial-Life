package spatial_game;

import java.awt.Color;

import k_neigbours.gui.GridFrame;
import spatial_game.environment.Stadium;

public class Game {

	public static void main(String[] args) {
		int width = 640;
		int height = 640; 
		int size = 8; // square size in pixels
		int print = 50;
		
		Stadium stadium = new Stadium(width / size, height / size, 100);
		GridFrame window = new GridFrame(width, height, size);
		int tot = (height / size) * (width / size);
		for(int i = 0; i < tot; i++) {
			int R = (int) (Math.random() * 256);
			int G = (int) (Math.random() * 256);
			int B = (int) (Math.random() * 256);
			window.add(new Color(R, G, B));
		}
		window.changeGrid(stadium.draw, 0);
		window.setVisible(true);
		int it = 0;
		while(true) {
			int[][] wins = stadium.play();
			stadium.replace(wins);
			window.changeGrid(stadium.draw, 5);
			int x = (int) (Math.random() * stadium.width);
			int y = (int) (Math.random() * stadium.height);
			if(it == 0)
				System.out.println(stadium.players[x][y].toString());
			it = (it + 1) % print;
		}
	}

}
