package main

// Matin Mobini: 300283854
// Michael Massaad: 300293612

import (
	"fmt"
	"image"
	"path/filepath"
	"sort"
)

// createHistogram creates a reduced histogram, d is the desired depth value
func createHistogram(img image.Image, d int) []int {
	// empty histogram array
	histogram := make([]int, bins(d))

	// loop through each pixel in the image
	for i := img.Bounds().Min.X; i < img.Bounds().Max.X; i++ {
		for j := img.Bounds().Min.Y; j < img.Bounds().Max.Y; j++ {
			// read the rgb values at the current pixel
			r, g, b, _ := img.At(i, j).RGBA()

			// scale 32 bit values into 'd' bit values
			r >>= uint(16 - d)
			g >>= uint(16 - d)
			b >>= uint(16 - d)

			// index of histogram bin corresponding to RGB colour
			index := int((r << uint32(2*d)) + (g << uint32(d)) + b)
			histogram[index]++
		}
	}
	return histogram
}

func bins(d int) int {
	return 1 << uint(3*d)
}

// normalizeHistogram normalizes the histogram to prepare for comparison of histograms
func normalizeHistogram(histogram Histogram) []float64 {
	// read the image for inputted histogram
	imageH, err := readImage(histogram.Name)
	if err != nil {
		fmt.Println(err)
		return nil
	}

	// total number of pixels
	numofPixels := imageH.Bounds().Max.X * imageH.Bounds().Max.Y

	// create normalized histogram of same length
	normalizedHistogram := make([]float64, len(histogram.H))

	// loop each element in the old histogram
	for i := 0; i < len(histogram.H); i++ {
		normalizedHistogram[i] = (float64(histogram.H[i])) / float64(numofPixels) // divide each histogram value by num of pixels
		//normalizedHistogram[i] /= float64(numofPixels)
	}

	return normalizedHistogram //now it is normalized
}

// find the intersection between the normalized histograms
func intersec(normalQueryHist, normalDataSetHist []float64) float64 {
	intersection := 0.0
	// loop through each index of histogram
	for i := 0; i < len(normalQueryHist); i++ {
		intersection += min(normalQueryHist[i], normalDataSetHist[i]) // add the min of the two values
	}
	return intersection
}

// function to get the min of two floats
func min(x, y float64) float64 {
	if x > y {
		return y
	}
	return x
}

// given a query hist and the hist channel, make a map of all images their intersection values
func readHistogramData(queryhist Histogram, histChan chan Histogram) {
	normQuery := normalizeHistogram(queryhist) //normalize given query hist
	imageVals := make(map[string]float64)

	// looping through items in the hist channel
	for holder := range histChan {
		// normalize the dataset image
		normalData := normalizeHistogram(holder)

		imageVals[holder.Name] = intersec(normQuery, normalData) // placing intersection and filename in the map
	}

	// print the top five most similar images
	FiveHighest(imageVals)
}

// given a map print the 5 with the highest insertsection value
func FiveHighest(FiveHighest map[string]float64) {
	// Initialize a pairs struct
	var group []struct {
		FileName      string
		IntersecValue float64
	}

	// For each file and value in the map
	for file, val := range FiveHighest {
		// Add the FileName and IntersecValue as a group
		group = append(group, struct {
			FileName      string
			IntersecValue float64
		}{file, val})
	}

	// Sort the groups by descending order(index 0 being the highest IntersecValue)
	sort.SliceStable(group, func(i, j int) bool {
		return group[i].IntersecValue > group[j].IntersecValue
	})

	// Print the first 5 indexes in group
	for i := 0; i < 5; i++ {
		// Extract filename from the path
		filename := filepath.Base(group[i].FileName)
		fmt.Println((i + 1), "):", filename)
		fmt.Println(group[i].IntersecValue)
	}
}
