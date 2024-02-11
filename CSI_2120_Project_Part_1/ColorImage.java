package CSI_2120_Project_Part_1;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.FileReader;

public class ColorImage {

    private String filename;
    private int width;
    private int height;
    private int depth; // Number of bits per pixel
    private int[][][] pixels; // 3D array to store RGB values
    private BufferedImage image; //not used


    public ColorImage(String filename) { //Color Image constructor
        
        this.filename = filename;

            try {
                BufferedReader reader = new BufferedReader(new FileReader(filename));
                
                reader.readLine();
                reader.readLine();
                        String[] dim = reader.readLine().split(" ");
                        this.width = Integer.parseInt(dim[0]); //image.getWidth();
                        this.height = Integer.parseInt(dim[1]);
                        this.depth = Integer.parseInt(reader.readLine());
                        

                        pixels = new int[height][width][3];   //initalizing pixels variable
                        
                        String line;
                        int index = 0;

                        while ((line = reader.readLine()) != null) {
                            
                            // Split the line into RGB values
                            String[] rgbValues = line.trim().split(" ");
                          
                            for (int i = 0; i < rgbValues.length; i += 3) {
                                int red = Integer.parseInt(rgbValues[i]);
                                int green = Integer.parseInt(rgbValues[i + 1]);
                                int blue = Integer.parseInt(rgbValues[i + 2]);
                                int[] pix = {red, green, blue};
                                pixels[index/width][index % width] = pix;
                            }

                            index++;
                        }

            } catch (IOException e) {
                e.printStackTrace();
            }
            
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



