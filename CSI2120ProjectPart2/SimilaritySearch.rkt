#lang racket

(define (similaritySearch queryHistFilename imageDatasetDir)
  (if (or (null? queryHistFilename)(null? imageDatasetDir))
      '("There has been an error with your input, please ensure your inputs are valid")
      (let* ((qName queryHistFilename)
             (colorNum (cdr (read-file-as-list qName)))
             (qHist (getHist colorNum (numofpixels colorNum)))
             (imgfiles (map path->string (directory-list imageDatasetDir)))
             (similarimages (make-vector (length imgfiles)))
             (finalansw '())
             )
        " "
            
      )
             
      )
  ;read file, returns list with 513 items, define num of Bins with car of the 513 items. So only 512 left assign the list of 512 to a varible called Histogram
  ;calculate numpix, define as a local varible
  ;when calling GetHist,enter 512 item histogram with the previously found numofpixels
  ;new list with size 5 for finalansw vector
  ;read the dataset, code to go into specifc folder then just call premade  (read-file-as-list filename) function to make it into a histogram to use later. 

  )


(define (read-file-as-list filename);returns a list of 513 elements, the first being the num of bins = 512, rest being the count of each color type(histogram), taken from lecture notes
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


(define (getHist hist numpix);normalize the vals
  
  (if (null? hist)
      '()
      (cons (/ (car hist) numpix) (getHist (cdr hist) numpix))
      )
  )

(define (numofpixels hist);This returns the number of pixels
  (if (null? hist)
      0
      (+ (car hist) (numofpixels (cdr hist)))
      )
  )

(define (compare normalizedHist1 normalizedHist2 numbins)  ; using the given forumla compares the two aldready normalized histograms
  (if (or (null? normalizedHist1) (null? normalizedHist2));can do with either 1 or 2, no difference same size
      0
      (+ (min (car normalizedHist1) (car normalizedHist2)) (compare (cdr normalizedHist1) (cdr normalizedHist2) numbins))
      )
  )


