package k_neigbours.gui;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import javax.swing.JFrame;

public class GridFrame extends JFrame {

	private static final long serialVersionUID = -8750264880420693970L;
	
	protected GridPanel panel;
	protected int size = 500;
	
	public GridFrame(int width, int height, int size) {
		this.setSize(width, height);
		panel = new GridPanel(width, height, size);
		this.addWindowListener( new WindowAdapter(){
			public void windowClosing( WindowEvent e ){
				performExitAction();
			}
	    });
		this.getContentPane().add(panel,  BorderLayout.CENTER);
	}
	
	public void performExitAction() {
		System.exit(0);
	}
	
	public void changeGrid(int[][] grid, int time) {
		panel.drawGrid(grid);
		this.repaint();
		try {
			Thread.sleep(time);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
	
	public void add(Color color) {
		panel.add(color);
	}

}
