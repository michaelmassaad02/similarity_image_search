#lang racket
; Student 1: Matin Mobini
; Student 1 ID: 300 283 854
; Student 2: Michael Massaad
; Student 2 ID: 300 293 612

; This function receives the filenames of the histogram for the query as well as the name of the directory
; that contains all of the dataset histogram files. This function then converts the parameters into suitable
; format and returns the 5 most similar images to the query image.
; This is an example as to what an input could look like for this function: (similaritySearch "q00.ppm.txt" "imageDataset2_15_20")
(define (similaritySearch queryHistFilename imageDatasetDir)
  (if (or (null? queryHistFilename)(null? imageDatasetDir))
      '("There has been an error with your input, please ensure your inputs are valid")
      (let* ((qName queryHistFilename)
             (colorNum (cdr (read-file-as-list qName)))
             (qHist (getHist colorNum (numofpixels colorNum)))
             (imgfiles (map path->string (directory-list imageDatasetDir)))
             (histfiles(delete-every-other imgfiles));gets rid of non txt files
             (dataHistpath (string-append (path->string (current-directory)) "/imageDataset2_15_20/"))
             )
        
        (display "The 5 Most Similar Images to the Desired Query Image are: \n")
        (printfilepair (top-5-pairs (group-pairs (result qHist histfiles dataHistpath (numofpixels colorNum)))))
        
        )      
      ) 
  )

; This function receives as parameters the list that represents the histogram of the query image, a list of filenames that
; are part of the dataset that will be then compared to the query image, the path to the directory that contains
; the dataset and the total number of pixels that are in each image. This function returns a list that alternates
; between the result of comparing an image from the dataset with the query image, and its corresponding image.
; ex: '(1 "q00.ppm.txt" 0.6 "q45.ppm.txt"), this is not the exact output, just an example that shows
; that it is a list that alternates between a "number" and a "string"
(define (result qHist dataHist dpath numofpixels)
  (if(null? dataHist)
     '()
     (cons (compare qHist (getHist (cdr (read-file-as-list (string-append dpath (car dataHist)))) numofpixels)) (cons (car dataHist) (result qHist (cdr dataHist) dpath numofpixels)))
     )
  )


; This function receives as input the filename of which we want to receive the histogram of the
; corresponding image. This function returns a list of 513 elements, the first
; being the number of bins/colors in the image (512 in this project), and the rest being the
; count of each color type(histogram). This function was taken from the lecture notes. 
(define (read-file-as-list filename)
  (let ((p (open-input-file filename)))
    (let f ((x (read p)))
      (if (eof-object? x)
          (begin
            (close-input-port p)
            '())
          (cons x (f (read p)))
          )
      )
    )
  )

; This function receives as parameters a list that represents the histogram of
; a certain image (hist), and also the total number of pixels in the image (numpix).
; This function returns a new list which represents the normalized histogram
; corresponding to the image.
(define (getHist hist numpix)
  (if (null? hist)
      '()
      (cons (/ (car hist) numpix) (getHist (cdr hist) numpix)) ; dividing the value of the bin by the total number of pixels, and recursively calling the function with the rest of the bins
      )
  )

; This function receives as parameter a list that represents the histogram of an image (hist), and
; returns the total number of pixels that are in the corresponding image.
(define (numofpixels hist)
  (if (null? hist)
      0
      (+ (car hist) (numofpixels (cdr hist)))
      )
  )


; This function receives as parameters 2 lists, both corresponding to the normalized histograms of
; 2 images of which we will compare their similarity with their histogram intersection. This function
; will return a value from 0.0 to 1.0, which represents how similar the  2 images are to eachother.
(define (compare normalizedHist1 normalizedHist2)  ; using the given forumla compares the two already normalized histograms
  (if (or (null? normalizedHist1) (null? normalizedHist2))
      0
      (+ (min (car normalizedHist1) (car normalizedHist2)) (compare (cdr normalizedHist1) (cdr normalizedHist2)))
      )
  )


; This function receives as parameter the list that contains the name of the files that are contained
; in the dataset directory. Since the directory contains .jpg files (which are the images themselves),
; .txt files (which contains the histogram informations for their corresponding images), and also a .py
; (which is not used by us students), this function will only extract the .txt files and will return
; them as a new list that contains their corresponding filenames
(define (delete-every-other lst)
  (if (or (null? lst) ; If the list is empty or has only one element, return empty list
          (null? (cdr lst)))
      '()
      (cons (cadr lst) ; Keep the second element
            (delete-every-other (cddr lst)); Skip the first two elements and recursively process the rest
            )
      )
  ) 

; This function receives as parameter a list of elements (in this project, a list that alternates between
; the result of the comparison of the dataset images with the query and their filename) and returns a new
; list of pairs, each of which in our project will contain the result of the comparison of the dataset image with
; the query as the first element, and the corresponding filename as the second element of the pair
 (define (group-pairs lst)
  (if (null? lst)
      '()  ; Return an empty list if the input list is empty
      (cons (list (car lst) (cadr lst))  ; Create a pair from the first two elements
            (group-pairs (cddr lst)); Recursive call on the rest of the list, skipping two elements at a time
            )
      )
   )  

; This function receives as parameter a list of pairs (which contains the results of the comparison of images and the
; corresponding filename) and sorts the list of pairs based off of the results of the comparisons (so that we have
; the most similar image to the query is the first element, i.e the result is closest to 1, and the least similar is the last
; element in the list) and will return only the first 5 pairs from the list in order to return the first 5
; similar images. The following was used as reference for sorting the list:
; https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Fprivate%2Flist..rkt%29._sort%29%29
(define (top-5-pairs pairs-list)
  (define sorted-pairs (sort pairs-list > #:key car)) ; Sort the list of pairs by the first element in descending order
  (take sorted-pairs 5); Take the first 5 pairs from the sorted list
  )  

; This function receives as parameter a list of pairs which contain the result of the comparison and the
; filename of the corresponding image and returns as output a new list that contains only the filenames of the
; images. We take the substring of the filename so that it does not include the ".txt" in the output for
; a better format to represent the image itself.
(define (printfilepair lstofpairs)
  (if (null? lstofpairs)
      '()
       (cons (substring (car (cdr (car lstofpairs))) 0 (- (string-length (car (cdr (car lstofpairs)))) 4)) (printfilepair (cdr lstofpairs)))
       )
  )

