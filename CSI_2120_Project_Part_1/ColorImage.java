package CSI_2120_Project_Part_1;

import java.util.ArrayList;
import java.util.List;



public class ColorImage {

    private String filename;
    private int width;
    private int height;
    private int depth; // Number of bits per pixel
    private int[][][] pixels; // 3D array to store RGB values

    public ColorImage(String filename) {
        
    }

    public int getWidth() {
        return width;
    }

    public int getHeight() {
        return height;
    }

    public int getDepth() {
        return depth;
    }

    public String getFilename() {
        return filename;
    }

    public int[] getPixel(int i, int j) {
        return pixels[i][j];
    }

    public void reduceColor(int d) {
        // Reduce color space to d-bit representation
    }


}










