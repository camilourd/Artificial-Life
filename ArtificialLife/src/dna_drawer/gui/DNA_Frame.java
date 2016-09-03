package dna_drawer.gui;

import java.awt.BorderLayout;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import javax.swing.JFrame;

import dna_drawer.types.Point;

public class DNA_Frame extends JFrame {

	private static final long serialVersionUID = -5798552937453986110L;
	
	protected DNA_Panel panel;
	protected int size = 500;
	
	public DNA_Frame() {
		this.setSize(550, 550);
		panel = new DNA_Panel(size);
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
	
	public void addPoint(Point p) {
		panel.drawPoint(p);
		this.repaint();
	}

}
