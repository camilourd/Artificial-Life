package dna_drawer.gui;

import java.awt.Dimension;
import java.awt.Graphics;

import javax.swing.JPanel;

import dna_drawer.types.Point;

public class DNA_Canvas extends JPanel {

	private static final long serialVersionUID = -2931410853338019127L;
	
	protected DNA_Drawer drawer;
	
	public DNA_Canvas(int width, int height) {
		drawer = new DNA_Drawer(width, height);
		this.setSize(new Dimension(width, height));
	}
	
	protected void paintComponent(Graphics g) {
		super.paintComponent(g);
	    if(drawer != null)
	        drawer.paint(g);
	}
	
	public void addPoint(Point p) {
		drawer.addPoint(p);
		repaint();
	}

}
