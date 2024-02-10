package CSI_2120_Project_Part_1;

import java.util.ArrayList;
import java.util.List;

public class SimilaritySearch{

    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("Please Enter a valid input such as: java SimilaritySearch <queryImageFilename> <imageDatasetDirectory>");
            System.exit(1);
        }

        String queryImageFilename = args[0];
        String imageDatasetDirectory = args[1];


        ColorImage queryImage = new ColorImage(queryImageFilename);


        int colorDepth = 3; 

        queryImage.reduceColor(colorDepth);


        ColorHistogram queryHistogram = new ColorHistogram(colorDepth);
        queryHistogram.setImage(queryImage);


        

        List<ColorImage> similarImages = new ArrayList<>();
        

        
        for (ColorImage image : similarImages) {
            System.out.println(image.getFilename());
        }
    }


}








