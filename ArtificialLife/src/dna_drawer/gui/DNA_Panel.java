package dna_drawer.gui;

import java.awt.BorderLayout;
import java.awt.Dimension;

import javax.swing.JPanel;

import dna_drawer.types.Point;

public class DNA_Panel extends JPanel {

	private static final long serialVersionUID = 2231233090439766018L;
	
	private DNA_Canvas canvas;
	protected BorderLayout borderLayoutMaze = new BorderLayout();
	
	public DNA_Panel(int size) {
		canvas = new DNA_Canvas(size, size);
		this.setLayout(borderLayoutMaze);
		this.add(canvas, BorderLayout.CENTER);
		this.setSize(new Dimension(size, size));
	}
	
	public void drawPoint(Point p) {
		canvas.addPoint(p);
		canvas.repaint();
	}

}
