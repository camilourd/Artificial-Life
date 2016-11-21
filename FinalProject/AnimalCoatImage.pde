/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.awt.Color;
import java.awt.Image;
import java.awt.image.BufferedImage;

/**
 *
 * @author eduarc
 */
class AnimalCoatImage {

    public Image toImage(int width, int height, Color c1, Color c2, double data[][]) {
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        int[][] scaledData = scaleData(data, width, height);
        int[] colours = setColours(c1, c2);
        
        for (int y = 0; y < height; ++y) {
            for (int x = 0; x < width; ++x) {
                image.setRGB(x, y, colours[scaledData[x][y]]);
            }
        }
        return image;
    }

    private int scale(int i, int lo, int hi) {
        return lo + (hi - lo) * i / 255;
    }

    private int[] setColours(Color c1, Color c2) {
        int Rlo = c1.getRed();
        int Glo = c1.getGreen();
        int Blo = c1.getBlue();
        int Rhi = c2.getRed();
        int Ghi = c2.getGreen();
        int Bhi = c2.getBlue();

        int[] colours = new int[256];
        for (int i = 0; i < 256; ++i) {
            colours[i] = scale(i, Rlo, Rhi) << 16 | scale(i, Glo, Ghi) << 8 | scale(i, Blo, Bhi);
        }
        return colours;
    }

    private int[][] scaleData(double data[][], int width, int height) {
        int i, j;
        int[][] scaledData = new int[width][height];

        double high = Double.NEGATIVE_INFINITY;
        double low = Double.POSITIVE_INFINITY;

        for (i = 0; i < height; ++i) {
            for (j = 0; j < width; ++j) {
                double val = data[i][j];
                if (val > high) {
                    high = val;
                } else if (val < low) {
                    low = val;
                }
            }
        }
        for (i = 0; i < height; ++i) {
            for (j = 0; j < width; ++j) {
                int scaled = (int) ((data[i][j] - low) * 255. / (high - low));
                scaled = Math.max(0, Math.min(255, scaled));
                scaledData[i][j] = scaled;
            }
        }
        return scaledData;
    }
}