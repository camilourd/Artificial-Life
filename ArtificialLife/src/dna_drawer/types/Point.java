package dna_drawer.types;

public class Point {
	
	public double x, y;
	
	public Point(double x, double y) {
		this.x = x;
		this.y = y;
	}
	
	public Point move(Point p, double percentage) {
		double xn = (p.x - x) * percentage;
		double yn = (p.y - y) * percentage;
		return new Point(x + xn, y + yn);
	}

}
