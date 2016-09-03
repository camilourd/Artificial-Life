package k_neigbours.gui;

import java.awt.Color;
import java.awt.Graphics;

import unalcol.agents.simulate.gui.Drawer;
import unalcol.types.collection.vector.Vector;

public class GridDrawer extends Drawer {
	
	private Vector<Color> colors;
	int width, height, size;
	int[][] grid;
	
	public GridDrawer(int width, int height, int size) {
		this.width = width;
		this.height = height;
		this.size = size;
		this.colors = new Vector<Color>();
		this.grid = new int[width][height];
	}
	
	public void add(Color color) {
		colors.add(color);
	}
	
	public void setGrid(int[][] grid) {
		this.grid = grid;
	}

	@Override
	public void paint(Graphics g) {
		g.setColor(Color.BLACK);
		g.fillRect(0, 0, width, height);
		paintGrid(g, grid);
	}
	
	private void paintGrid(Graphics g, int[][] grid) {
		int fils = Math.min(grid.length, height / size);
		int cols = Math.min(grid[0].length, width / size);
		for(int i = 0; i < fils; i++)
			for(int j = 0; j < cols; j++)
				if(grid[i][j] >= 0 && grid[i][j] < colors.size()) {
					g.setColor(colors.get(grid[i][j]));
					g.fillRect(j * size, i * size, size, size);
				}
	}

	@Override
	public void setDimension(int width, int height) {
		this.width = width;
		this.height = height;
	}
	
}
