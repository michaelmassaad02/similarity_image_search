/*
Student 1: Matin Mobini
Student 1 ID: 300 283 854

Student 2: Michael Massaad
Student 2 ID: 300 293 612
*/

import java.io.IOException;
import java.io.BufferedReader;
import java.io.FileReader;

public class ColorImage {

    private String filename;
    private int width;
    private int height;
    private int depth; // Number of bits per pixel
    private int[][][] pixels; // 3D array to store RGB values


    public ColorImage(String filename) { //Color Image constructor with the filename, used for the query image
        
        this.filename = filename;

            try {
                BufferedReader reader = new BufferedReader(new FileReader(filename));
                
                reader.readLine(); // skips the first line of the ppm file
                reader.readLine(); // skips the second line of the ppm file

                String[] dim = reader.readLine().split(" "); // retrieving the width and the height from the ppm file
                this.width = Integer.parseInt(dim[0]);
                this.height = Integer.parseInt(dim[1]);

                this.depth = Integer.parseInt(reader.readLine()); // retrieving the depth of the image from the ppm file

                pixels = new int[height][width][3];   //initalizing the array that will store pixels RGB values
                        
                String line;
                int index = 0; // the index of the pixel we are looking at in the ppm file

                while ((line = reader.readLine()) != null) {

                    String[] rgbValues = line.trim().split(" "); // Split the line into RGB values
                          
                    for (int i = 0; i < rgbValues.length; i += 3) { // since the ppm cycles through the RGB values for each line, we retrieve the values for one pixel
                        int red = Integer.parseInt(rgbValues[i]);
                        int green = Integer.parseInt(rgbValues[i + 1]);
                        int blue = Integer.parseInt(rgbValues[i + 2]);
                        int[] pix = {red, green, blue};
                        pixels[index/width][index % width] = pix; // we insert the pixel at its corresponding position in the image in the 3D array
                        // we divide the index by the width to find out which row of the image that pixel was located, and we find the remainder to determine 
                        // what column it is at.
                        index++;
                    }        
                }
                reader.close();

            } 
            catch (IOException e) {
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

    public void reduceColor(int d) { //enter the value you want to reduce the current number of bits per pixel to d
        for(int i = 0; i < height; i++){
            for( int j = 0; j < width; j++){
                for(int k = 0; k<3; k++){
                    pixels[i][j][k] = (pixels[i][j][k] >>= (8-d)); //shifting each pixel to the desired number
                }
            }
        }

    }
}



