package dna_drawer;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

import dna_drawer.gui.DNA_Frame;
import dna_drawer.types.Point;

public class Runner {

	public static void main(String[] args) throws InterruptedException, IOException {
		char[] car = {'a', 't', 'c', 'g'};
		double[] probs = {0.2, 0.3, 0.15, 0.35};
		double percentage = 0.6;
		
		int[] dir = new int[300];
		for(int i = 0; i < car.length; i++)
			dir[car[i]] = i;
		
		Point[] borders = {
			new Point(0, 0),
			new Point(1, 0),
			new Point(0, 1),
			new Point(1, 1)
		};
		
		String genome = generate(car, probs, 10000);
		genome = readGenome("./data/dna_drawer/Hepatitis_C_virus_Genotype_3_genome");
		
		DNA_Frame window = new DNA_Frame();
		
		Point p = new Point(0.5, 0.5);
		window.addPoint(p);
		window.setVisible(true);
		for(int i = 0; i < genome.length(); i++) {
			char c = genome.charAt(i);
			if(isNucleotide(c)) {
				p = p.move(borders[dir[c]], percentage);
				window.addPoint(p);
			}
		}
	}

	@SuppressWarnings("resource")
	public static String readGenome(String file) throws IOException {
		BufferedReader  in = new BufferedReader (new InputStreamReader (new FileInputStream (file)));
		
		String genome = "";
		for(String line = ""; (line = in.readLine()) != null;)
			genome += line;
		return genome;
	}

	public static boolean isNucleotide(char c) {
		return (c == 'a') || (c == 't') || (c == 'c') || (c == 'g');
	}

	public static String generate(char[] car, double[] probs, int lenght) {
		String genome = "";
		double[] sum = new double[probs.length];
		
		for(int i = 0; i < probs.length; i++)
			sum[i] = (i > 0)? sum[i - 1] + probs[i] : probs[i];
		
		for(int i = 0; i < lenght; i++) {
			int li = 0, lo = sum.length - 1;
			double r = Math.random();
			while(li < lo) {
				int mid = (li + lo) / 2;
				if(sum[mid] < r)
					li = mid + 1;
				else
					lo = mid;
			}
			genome += car[li];
		}
		return genome;
	}

}
