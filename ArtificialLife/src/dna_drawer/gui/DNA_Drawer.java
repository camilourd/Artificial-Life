package dna_drawer.gui;

import java.awt.Graphics;

import dna_drawer.types.Point;
import unalcol.agents.simulate.gui.Drawer;
import unalcol.types.collection.vector.Vector;

public class DNA_Drawer extends Drawer {
	
	protected int width, height;
	protected Vector<Point> points;

	public DNA_Drawer(int width, int height) {
		setDimension(width, height);
		this.width = width;
		this.height = height;
		points = new Vector<Point>();
	}

	@Override
	public void paint(Graphics g) {
		for(Point p: points)
			g.drawOval((int) (p.x * width), (int) (p.y * height), 1, 1);//(int) (p.x * width + 1), (int) (p.y * height + 1));
	}

	@Override
	public void setDimension(int width, int height) {
		this.width = width;
		this.height = height;
	}
	
	public void addPoint(Point p) {
		points.add(p);
	}

}
