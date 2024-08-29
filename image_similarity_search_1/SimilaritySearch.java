/*
Student 1: Matin Mobini
Student 1 ID: 300 283 854

Student 2: Michael Massaad
Student 2 ID: 300 293 612
*/

import java.io.File;
import java.util.Arrays;

public class SimilaritySearch{
    
    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("Please Enter a valid input such as: java SimilaritySearch <queryImageFilename> <imageDatasetDirectory>");
            System.exit(1);
        }

        String queryImageFilename = args[0];
        String imageDatasetDirectory = args[1];

        
        ColorImage queryImage = new ColorImage(queryImageFilename);


        int colorDepth = 3; // Instructions give us depth of 3

        queryImage.reduceColor(colorDepth); // reducing to colorDepth-bit values for the RGB combinations (total number of colors possible is reduced)
        ColorHistogram queryHistogram = new ColorHistogram(colorDepth); // initializing the histogram with default frequency 0
        queryHistogram.setImage(queryImage); //attaching query image to the histogram and modifying the histogram accordingly
        queryHistogram.save(queryImageFilename + ".txt"); //saving the image's histogram into a file
        //Normalize the Query histogram before comparing

        File data_set_Dir = new File(imageDatasetDirectory); // Retrieving dataset of image files to find similar images to query
        File[] imgfiles = data_set_Dir.listFiles(); // putting all files from directory to an array that contains jpg and ppm.txt files
        
        double[] similarImages = new double[imgfiles.length]; // initializing an array that will contain the results of comparing each image with the query image
        Arrays.sort(imgfiles);

        for(int i = 1; i < imgfiles.length; i += 2){ // traversing the array of files to only read the ppm.txt files
            if(imgfiles[i].isFile()){
                // String filename = imgfiles[i].getName();

                ColorHistogram data_set_hist = new ColorHistogram(imgfiles[i].getPath());
                
                double similar_result = queryHistogram.compare(data_set_hist); // comparing the histogram to the query image's
                similarImages[i] = similar_result; // storing the corresponding result in index for the similar images

            }

        }

        System.out.println("The 5 most similar images to the query image " + queryImageFilename + " are:");
        double[] final_answ_files = new double[5]; // array that containts the 5 images that are most similar to the query
        int max_val = 0; // index of the most similar image in the current state of the similar images array -> highest result after comparing the histograms

        for(int i = 0; i < 5; i++){ // looping 5 times to print the 5 most similar images

            for(int j = 0; j < similarImages.length;j++){ // looping through all the results from comparing the files and retrieve the most similar image in the current array
                if(final_answ_files[i] < similarImages[j] && similarImages[j] >= 0){ // if we find an image for which the result of the comparison with query if larger, than we swap it
                    max_val = j; // we store the index of the current most similar image
                    final_answ_files[i] = similarImages[j]; // we store the result of the comparison in the final array to compare with the other images' results
                }
            
            }
            System.out.println(imgfiles[max_val-1].getName() + " has similarity: " + similarImages[max_val]); // after finding the most similar image in the current state of the array, we then print it as one of the 5
            similarImages[max_val] = -1; // we set the result of the corresponding image to -1, which is not a possible value for the comparison and therefore indicates that the image was already shown
        }   
        
    }

}