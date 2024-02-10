package CSI_2120_Project_Part_1;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;


public class ColorImage {

    private String filename;
    private int width;
    private int height;
    private int depth; // Number of bits per pixel
    private int[][][] pixels; // 3D array to store RGB values
    private BufferedImage image;

    public static void main(String[] args) {
        System.out.println("Test");
    }

    public ColorImage(String filename) { //Color Image constructor
        
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

            pixels = new int[height][width][3];   //initalizing pixels variable
            for(int i = 0; i < height; i++){
                for( int j = 0; j < width; j++){
                    int rgb = image.getRGB(i, j);
                    int r = (rgb >> 16) & 0xFF;
                    int g = (rgb >> 8) & 0xFF;
                    int b = rgb & 0xFF;
                    pixels[i][j] = new int[] {r, g, b};
                }
            }
            reduceColor(8-depth);
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

    public void reduceColor(int d) { //enter the value you want to reduce the current Dimension to d
        for(int i = 0; i < height; i++){
            for( int j = 0; j < width; j++){
                for(int k = 0; k<3; k++){
                    pixels[i][j][k] = (pixels[i][j][k] >>= (8-d));
                }
            }
        }

    }
}


