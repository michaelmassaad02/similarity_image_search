package CSI_2120_Project_Part_1;

import java.util.ArrayList;
import java.util.List;
import javax.imageio.ImageIO;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;


public class ColorImage {

    private String filename;
    private int width;
    private int height;
    private int depth; // Number of bits per pixel
    private int[][][] pixels; // 3D array to store RGB values
    private BufferedImage image;

    public ColorImage(String filename) {
        
        this.filename = filename;

            try {
                File file = new File(filename);
                this.image = ImageIO.read(file);
                if (image == null) {
                    System.out.println("Failed to read the image.");
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            this.width = image.getWidth();
            this.height = image.getHeight();
            this.depth = image.getColorModel().getPixelSize();
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










