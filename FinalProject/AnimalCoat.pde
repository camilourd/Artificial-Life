/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.awt.Color;
import java.awt.Image;
import java.util.Random;

/**
 *
 * @author eduarc
 */
public class AnimalCoat {

    public static final int ZEBRA = 0;
    public static final int LEOPARD = 1;

    private final int animal;
    private final double diff;
    private final double react;
    private final int iterations;

    private double[][] Ao, Bo, An, Bn;
    private int width, height;
    private final Random rand = new Random();

    AnimalCoat(int animal, double diff, double react, int iterations) {

        this.animal = animal;
        this.diff = diff;
        this.react = react;
        this.iterations = iterations;
    }

    public int getAnimal() {
        return animal;
    }

    public double getDiff() {
        return diff;
    }

    public double getReact() {
        return react;
    }

    public int getIterations() {
        return iterations;
    }

    public double similarity(AnimalCoat other) {

        double animalD = animal - other.animal;
        double diffD = diff - other.diff;
        double reactD = react - other.react;
        double iterationsD = iterations - other.iterations;
        return Math.sqrt(animalD * animalD + diffD * diffD + reactD * reactD + iterationsD * iterationsD);
    }

    private void reactionDiffusion(int width, int height) {

        int n, i, j, iplus1, iminus1, jplus1, jminus1;
        double DiA, ReA, DiB, ReB;

        this.width = width;
        this.height = height;
        
        Ao = new double[width][height];
        Bo = new double[width][height];
        An = new double[width][height];
        Bn = new double[width][height];

        randomInitalState();
        
        // uses Euler's method to solve the diff eqns
        for (n = 0; n < iterations; ++n) {
            for (i = 0; i < height; ++i) {
                // treat the surface as a torus by wrapping at the edges
                iplus1 = i + 1;
                iminus1 = i - 1;
                
                if (i == 0) {
                    iminus1 = height - 1;
                }
                if (i == height - 1) {
                    iplus1 = 0;
                }

                for (j = 0; j < width; ++j) {
                    jplus1 = j + 1;
                    jminus1 = j - 1;
                    
                    if (j == 0) {
                        jminus1 = width - 1;
                    }
                    if (j == width - 1) {
                        jplus1 = 0;
                    }

                    // Component A
                    DiA = react * (Ao[iplus1][j] - 2.0 * Ao[i][j] + Ao[iminus1][j]
                        + Ao[i][jplus1] - 2.0 * Ao[i][j] + Ao[i][jminus1]);
                    ReA = Ao[i][j] * Bo[i][j] - Ao[i][j] - 12.0;
                    An[i][j] = Ao[i][j] + 0.01 * (ReA + DiA);
                    
                    if (An[i][j] < 0.0) {
                        An[i][j] = 0.0;
                    }

                    // Component B
                    DiB = diff * (Bo[iplus1][j] - 2.0 * Bo[i][j] + Bo[iminus1][j]
                        + Bo[i][jplus1] - 2.0 * Bo[i][j] + Bo[i][jminus1]);
                    ReB = 16.0 - Ao[i][j] * Bo[i][j];
                    Bn[i][j] = Bo[i][j] + 0.01 * (ReB + DiB);
                    
                    if (Bn[i][j] < 0.0) {
                        Bn[i][j] = 0.0;
                    }
                }
            }
            double[][] temp = Ao;
            Ao = An;
            An = temp;
            temp = Bo;
            Bo = Bn;
            Bn = temp;
        }
    }

    public void randomInitalState() {

        if (animal == AnimalCoat.ZEBRA) {
            for (int i = 0; i < height; ++i) {
                double v = rand.nextDouble() * 12.0 + rand.nextGaussian() * 2.0;
                for (int j = 0; j < width; ++j) {
                    Ao[i][j] = v;
                    Bo[i][j] = rand.nextDouble() * 12.0 + rand.nextGaussian() * 2.0;
                }
            }
        } else {
            for (int i = 0; i < height; ++i) {
                for (int j = 0; j < width; ++j) {
                    Ao[i][j] = rand.nextDouble() * 12.0 + rand.nextGaussian() * 2.0;
                    Bo[i][j] = rand.nextDouble() * 12.0 + rand.nextGaussian() * 2.0;
                }
            }
        }
    }

    public Image toImage(int width, int height, Color c1, Color c2) {
        reactionDiffusion(width, height);
        AnimalCoatImage image = new AnimalCoatImage();
        return image.toImage(width, height, c1, c2, Ao);
    }
}