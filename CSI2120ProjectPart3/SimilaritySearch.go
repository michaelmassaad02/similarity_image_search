package main

// Matin Mobini: 300283854
// Michael Massaad: 300293612

import (
	"fmt"
	"image"
	"image/jpeg"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"
)

// info about a histogram. Stores name and the histogram itself
type Histogram struct {
	Name string
	H    []int
}

var waitG sync.WaitGroup

func main() {

	if len(os.Args) < 3 { // if the arguments inputted < 3 report an error to user
		fmt.Println(os.Args)
		fmt.Printf("Expected 2 Arguments, Got %d", len(os.Args)-1)
		os.Exit(1)
	}

	// the number subarrays
	k_val := 1

	// read from input for query file
	queryImage := "QueryImages/" + os.Args[1]
	datasetlist := os.Args[2]

	// make a channel for sending and receiving histogram info
	histChannel := make(chan Histogram)

	// get images in the dataset folder
	dataList, err := getDataImageList(datasetlist)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	isdonechan := make(chan bool, 1) // Create channel to control completion of main

	go func() {
		defer close(histChannel) // close the channel when the goroutine is done

		// loops through all the files in each subarray returned by splitting the list
		for _, dataList := range splitListIntoK(dataList, k_val) {
			// add one to waitgroup
			waitG.Add(1)
			// calculate the histograms for files in the subarray
			go calculateHistograms(dataList, 3, histChannel)
		}

		waitG.Wait() // wait until threads are done

		close(isdonechan) // Close channel indicating we are done.
	}()

	// get the histogram of the query image
	queryHist, err := calculateHistogram(queryImage, 3)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	now := time.Now()
	// normalize query hist and each dataset image and compare their intersection values
	readHistogramData(queryHist, histChannel)
	fmt.Printf("Completed within: %v\n", time.Since(now))

	<-isdonechan // Wait for calculating histograms to finish
}

// compute the histograms given an array of file names
func calculateHistograms(imagePath []string, depth int, hChan chan<- Histogram) {
	// decrement the wait group when the loop is done
	defer waitG.Done()

	// loop through each image
	for _, image := range imagePath {
		// creates a histogram for each image
		hist, err := calculateHistogram(image, depth)
		if err != nil {
			fmt.Println(err)
			return
		}
		// send the hist through the channel
		hChan <- hist
	}
}

// compute the histogram given a single
func calculateHistogram(imagePath string, depth int) (Histogram, error) {
	// read the image given the path
	img, err := readImage(imagePath)
	if err != nil {
		return Histogram{}, err
	}

	// make a histogram given the reduced image
	reducedHist := createHistogram(img, depth)

	// histogram to be sent into the histogram channel
	return Histogram{imagePath, reducedHist}, nil
}

// getImageList gets the list of images present in the dataset
func getDataImageList(datasetlist string) ([]string, error) {
	imageList := []string{}

	// collection of all the files within dataset folder
	files, err := os.ReadDir(datasetlist)
	if err != nil {
		return []string{}, err
	}

	// loop through each file
	for _, file := range files {
		// get the path of the current file
		filepath := filepath.Join(datasetlist, file.Name())

		// disregard any txt, py and ppm files, we only use jpg files
		if strings.HasSuffix(filepath, ".txt") || strings.HasSuffix(filepath, ".py") ||
			strings.HasSuffix(filepath, ".ppm") {
			continue
		}

		// add the jpg image to the list of images
		imageList = append(imageList, datasetlist+"/"+file.Name())
	}

	return imageList, nil
}

// splitList splits the list of images into k_value sublist
func splitListIntoK(imageList []string, k_val int) [][]string {
	length := len(imageList) // length of the image list

	subArraySize := length / k_val // size of each subarray

	remainder := length % k_val // remaining elements

	subArrays := make([][]string, k_val)

	// loop through each k_val
	for i := 0; i < k_val; i++ {

		startIndex := i * subArraySize // starting index of the slice

		endIndex := (i + 1) * subArraySize // end index of the slice

		if i < remainder {
			endIndex++ // increase the end index
		}

		if endIndex > length {
			endIndex = length // end index is the image length
		}

		// every subarray is now a slice from start to the end index
		subArrays[i] = imageList[startIndex:endIndex]
	}

	return subArrays //return the Subarrays
}

// readImage reads the image given a file path
func readImage(filePath string) (image.Image, error) {
	file, err := os.Open(filePath) // open the file given the path
	if err != nil {
		return nil, err
	}

	defer file.Close() //  when the function ends close the file

	// decode the jpeg image opened
	img, err := jpeg.Decode(file)
	if err != nil {
		return nil, err
	}

	return img, nil
}
