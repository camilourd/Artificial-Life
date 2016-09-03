package k_neigbours.gui;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;

import javax.swing.JPanel;

public class GridPanel extends JPanel {

	private static final long serialVersionUID = -387052923302135468L;
	
	private GridCanvas canvas;
	protected BorderLayout borderLayoutMaze = new BorderLayout();
	
	public GridPanel(int width, int height, int size) {
		canvas = new GridCanvas(width, height, size);
		this.setLayout(borderLayoutMaze);
		this.add(canvas, BorderLayout.CENTER);
		this.setSize(new Dimension(width, height));
	}
	
	public void drawGrid(int[][] grid) {
		canvas.setGrid(grid);
		canvas.repaint();
	}
	
	public void add(Color color) {
		canvas.add(color);
	}

}
