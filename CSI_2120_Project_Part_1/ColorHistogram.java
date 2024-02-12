
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;

public class ColorHistogram {

    private int[] histogram;
    private int numBin;
    private ColorImage image;
    private int dim;
    private int numPix;
    private int counter;

    public ColorHistogram(int d) { //constructor of ColorHistogram class where there is only a int d input which is dimesion
        this.dim = d;
        this.numBin = (int) Math.pow(2, d * 3);
        this.histogram = new int[numBin];

        //for (int i=0; i<numBin; i++){ //initalizing the values to 0
            //histogram[i] = 0;
        //}
    }

    public ColorHistogram(String filename) {  //constructor of ColorHistogram class where there is only an String filename inputed 
        try {
            BufferedReader reader = new BufferedReader(new FileReader(filename));
            this.numBin = Integer.parseInt((reader.readLine()).trim());
            //System.out.println(numBin);
            histogram = new int[numBin];



            String line = reader.readLine();
            String[] vals = (line.split(" "));
            //System.out.println(Arrays.toString(vals));

            for (int i = 0; i < vals.length; i++){
                histogram[i] = Integer.parseInt(vals[i]);
                counter += Integer.parseInt(vals[i]);
                //System.out.println(Integer.parseInt(vals[i]));
            }
            //System.out.println(counter + "filename" + filename);
            // initlize image
        }
        catch(IOException e){
            System.err.println("Error with loading histogram from file");
            e.printStackTrace();
        }
    }

    public void setImage(ColorImage image) { //setter method for the classes Image varible
        this.image = image;
        //use the formula on page three  to find the index 
        for(int k = 0; k < image.getHeight(); k++){

            for(int p = 0; p < image.getWidth(); p++){

                
                int[] hold = image.getPixel(k, p);
                int r = hold[0];
                int g = hold[1];
                int b = hold[2];
                histogram[(r << (2* dim)) + (g << dim) + b]++;
                

            }

        }
    }

    public double[] getHistogram() {
        double[] normHistogram = new double[histogram.length];
        if(this.image != null){
            numPix = image.getWidth() * image.getHeight();
            //System.out.println(numPix);
        }
        else{
            this.numPix = counter;
            //System.out.println(counter);
        }

        for (int i = 0; i < histogram.length; i++){
            
            normHistogram[i] = (double) histogram[i] / numPix; //divding after adding them all together to normalize
            //System.out.println((double) histogram[i] / numPix);
        }
        
        return normHistogram;
    }

    public double compare(ColorHistogram hist) {
        double answ = 0.0;

        double[] hold = this.getHistogram();
        double[] hold2 = hist.getHistogram();
        for (int i = 0; i < histogram.length; i++){

            answ += Math.min(hold[i], hold2[i]); //finding the intersection and storing it into answ variable
        }

        //int numpix = image.getHeight() * image.getWidth();
        //answ /= numpix;  
        //System.out.println(answ);

        return answ; 
    }

    public void save(String filename) {  //write into a file using items in histogram 

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filename))){
            bw.write(numBin);
            bw.newLine();

            for (int i = 0; i < numBin; i++){
                bw.write(Integer.toString(histogram[i]));
            }

        }
        catch(IOException e){
            System.err.println("Error with loading histogram into file");
            e.printStackTrace();
        }
    }

}