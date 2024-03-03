#lang racket

(define (similaritySearch queryHistFilename imageDatasetDir)
  (if (or (null? queryHistFilename)(null? imageDatasetDir))
      ;Store filename as varible
      '("There has been an error with your input, please ensure your inputs are valid")

      )
  ;read file, returns list with 513 items, define num of Bins with car of the 513 items. So only 512 left assign the list of 512 to a varible called Histogram
  ;calculate numpix, define as a local varible
  ;when calling GetHist,enter 512 item histogram with the previously found numofpixels
  ;new list with size 5 for finalansw list
  ;read the dataset, code to go into specifc folder then just call premade  (read-file-as-list filename) function to make it into a histogram to use later. 

  )

(define (read-file-as-list filename);returns a list of 513 elements, the first being the num of bins = 512, rest being the count of each color type(histogram)
  (with-input-from-file filename
    (lambda ()
      (let loop ((lines '())
                 (line (read-line)))
        (if (eof-object? line)
            (let ((data (string-split (car (reverse lines)) " ")))
              (cons (string->number (car data))
                    (map string->number (cdr data))))
            (loop (cons line lines) (read-line))
            )
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

(define (numofpixels hist);THIS returns the number of pixels
  (if (null? hist)
      0
      (+ (car hist) (numofpixels (cdr hist)))
      )
  )

(define (compare normalizedHist1 normalizedHist2 numbins)  ; using the given forumla compares the two aldready normalized histograms
  (if (null? normalizedHist1);can do with either 1 or 2, no difference same size
      0
      (+ (min (car normalizedHist1) (car normalizedHist2)) (compare (cdr normalizedHist1) (cdr normalizedHist2) numbins))
      )
  )



;ANOTHER WAY TO read, returns a pair tho
;(define (make-color-histogram filename)
  ;(let ((lines (file->lines filename))) ; Read all lines from the file
    ;(let ((num-bins (string->number (car lines)))) ; Extract the number of bins from the first line
      ;(let ((histogram (map string->number (string-split (cadr lines) " ")))) ; Extract the histogram data from the second line
        ;(cons num-bins histogram)); Return a pair containing the number of bins and the histogram data
      ;)
    ;)
  ;) 

;PROFS WAY OF READING A FILE INTO A LIST
;(let ((p (open-input-file "short.scm")))
  ;(let f ((x (read p))) ; reading from file
    ;(if (eof-object? x) ; check for eof
        ;(begin
          ;(close-input-port p)
          ;'())
        ;(cons x (f (read p))))))
