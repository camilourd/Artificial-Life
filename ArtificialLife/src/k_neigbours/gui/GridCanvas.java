package k_neigbours.gui;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;

import javax.swing.JPanel;

public class GridCanvas extends JPanel {

	private static final long serialVersionUID = 8683159043740280683L;
	
	protected GridDrawer drawer;
	
	public GridCanvas(int width, int height, int size) {
		drawer = new GridDrawer(width, height, size);
		this.setSize(new Dimension(width, height));
	}
	
	protected void paintComponent(Graphics g) {
		super.paintComponent(g);
	    if(drawer != null)
	        drawer.paint(g);
	}
	
	protected void setGrid(int[][] grid) {
		drawer.setGrid(grid);
	}
	
	public void add(Color color) {
		drawer.add(color);
	}
	
}
