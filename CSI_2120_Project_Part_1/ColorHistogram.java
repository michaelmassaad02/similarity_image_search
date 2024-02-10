package CSI_2120_Project_Part_1;


import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;


@SuppressWarnings("unused")
public class ColorHistogram {

    private int[] histogram;
    private int numBin;
    private ColorImage image;

    public ColorHistogram(int d) { //constructor of ColorHistogram class where there is only a int d input which is dimesion

        this.numBin = (int) Math.pow(2, d * 3);
        this.histogram = new int[numBin];

        for (int i=0; i<numBin; i++){
            histogram[i] = 0;
        }
    }

    public ColorHistogram(String filename) {  //constructor of ColorHistogram class where there is only an String filename inputed 
        try (BufferedReader reader = new BufferedReader(new FileReader(filename))){
            String line;
            int indx= 0;

            while ((line = reader.readLine()) != null && indx < numBin){

                histogram[indx++] = Integer.parseInt(line.trim());
            }

        }
        catch(IOException e){
            System.err.println("Error with loading histogram from file");
            e.printStackTrace();
        }
    }

    public void setImage(ColorImage image) { //setter method for the classes Image varible
        this.image = image;
    }

    public double[] getHistogram() {
        double[] normHistogram = new double[numBin];
        int numPix = image.getWidth() * image.getHeight();

        for (int i = 0; i < numBin; i++){

            normHistogram[i] = histogram[i] / numPix; //divding after adding them all together to normalize
        }
        return normHistogram;
    }

    public double compare(ColorHistogram hist) {
        double answ = 0.0;

        for (int i = 0; i < numBin; i++){

            answ += Math.min(this.histogram[i], hist.histogram[i]); //finding the intersection and storing it into answ variable
        }

        answ = (image.getWidth() * image.getHeight()) / answ;  

        return answ; 
    }

    public void save(String filename) {  //write into a file using items in histogram 

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filename))){
            for (int i = 0; i < numBin; i++){

                bw.write(Integer.toString(histogram[i]));
                bw.newLine();                               //***idk if we need to do new line or not? ***
            }

        }
        catch(IOException e){
            System.err.println("Error with loading histogram into file");
            e.printStackTrace();
        }
    }

}




