/*
Student 1: Matin Mobini
Student 1 ID: 300 283 854

Student 2: Michael Massaad
Student 2 ID: 300 293 612
*/

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.FileReader;
import java.io.IOException;

public class ColorHistogram {

    private int[] histogram;
    private int numBin;
    private ColorImage image;
    private int dim;
    private int numPix;
    private int counter;

    public ColorHistogram(int d) { //constructor of ColorHistogram class using the bit size
        this.dim = d;
        this.numBin = (int) Math.pow(2, d * 3); // using the formula given in the instructions, we determine the number of bins/colors using the depth
        this.histogram = new int[numBin]; // initial values of the frequencies are 0 for each bin

    }

    public ColorHistogram(String filename) {  //constructor of ColorHistogram class using the filename of a text file that already contains the histogram
        try {
            BufferedReader reader = new BufferedReader(new FileReader(filename));
            this.numBin = Integer.parseInt(reader.readLine()); // retrieving the number of bins (i.e. the number of possible colors) from the first line to initialize the array containing the histogram
            histogram = new int[numBin];

            String line = reader.readLine(); // reading the next line which contains the frequencies of each bin
            String[] vals = (line.split(" "));

            for (int i = 0; i < vals.length; i++){ // inserting the frequency to its corresponding bin in the array
                histogram[i] = Integer.parseInt(vals[i]); 
                counter += Integer.parseInt(vals[i]); // keeps track of how many pixels in total are there
            }

            reader.close();
        }
        catch(IOException e){
            System.err.println("Error with loading histogram from file");
            e.printStackTrace();
        }
    }

    public void setImage(ColorImage image) { //links the image to the histogram, so we now update the histogram frequencies to represent the image
        this.image = image;

        for(int k = 0; k < image.getHeight(); k++){
            for(int p = 0; p < image.getWidth(); p++){
                int[] hold = image.getPixel(k, p);
                int r = hold[0];
                int g = hold[1];
                int b = hold[2];
                histogram[(r << (2* dim)) + (g << dim) + b]++;  // using the formula given from the instructions to find the index of the histogram bin corresponding to the pixel
                // we increment the frequency in the bin by 1 indicating that we have found another pixel with the corresponding RGB values
            }

        }
    }

    public double[] getHistogram() {

        double[] normHistogram = new double[histogram.length]; // initializes the histogram as an array of doubles for the normalized frequencies
        
        if(this.image != null){ // if image is null, then we are getting the histogram of a dataset image
            numPix = image.getWidth() * image.getHeight();
        }
        else{
            this.numPix = counter; // if the histogram we want is for a dataset image, we use the counter calculated to indicate the number of pixels
        }

        for (int i = 0; i < histogram.length; i++){
            
            normHistogram[i] = (double) histogram[i] / numPix; //dividing the frequency of each bin by the total amount of pixels to normalize
        }
        
        return normHistogram;
    }

    public double compare(ColorHistogram hist) {
        double answ = 0.0; // initialize the result of the comparison

        double[] hold = this.getHistogram();
        double[] hold2 = hist.getHistogram();
        for (int i = 0; i < histogram.length; i++){ // looping through the histograms we want to compare

            answ += Math.min(hold[i], hold2[i]); // using the formula given in the instructions (Histogram Comparison), we obtain the histogram intersection
        }

        return answ; 
    }

    public void save(String filename) {  //write into a file using items in histogram 

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filename))){
            bw.write(Integer.toString(numBin));
            bw.newLine();

            for (int i = 0; i < numBin; i++){
                bw.write(Integer.toString(histogram[i]));
                bw.write(" ");
            }

        }
        catch(IOException e){
            System.err.println("Error with loading histogram into file");
            e.printStackTrace();
        }
    }

}