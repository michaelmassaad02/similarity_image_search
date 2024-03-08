#lang racket
;(similaritySearch "q00.ppm.txt" "imageDataset2_15_20")

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
        
        (display "The 5 Most similar Images to the selected Query Image are: \n")
        (printfilepair (top-5-pairs (group-pairs (result qHist histfiles dataHistpath (numofpixels colorNum)))))
        
        )      
      ) 
  )


(define (result qHist dataHist dpath numofpixels)
  (if(null? dataHist)
     '()
     (cons (compare qHist (getHist (cdr (read-file-as-list (string-append dpath (car dataHist)))) numofpixels)) (cons (car dataHist) (result qHist (cdr dataHist) dpath numofpixels)))
     )
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


(define (compare normalizedHist1 normalizedHist2)  ; using the given forumla compares the two aldready normalized histograms
  (if (or (null? normalizedHist1) (null? normalizedHist2));can do with either 1 or 2, no difference same size
      0
      (+ (min (car normalizedHist1) (car normalizedHist2)) (compare (cdr normalizedHist1) (cdr normalizedHist2)))
      )
  )


(define (delete-every-other lst)
  (if (or (null? lst) ; If the list is empty or has only one element, return empty list
          (null? (cdr lst)))
      '()
      (cons (cadr lst) ; Keep the second element
            (delete-every-other (cddr lst)); Skip the first two elements and recursively process the rest
            )
      )
  ) 

 (define (group-pairs lst)
  (if (null? lst)
      '()  ; Return an empty list if the input list is empty
      (cons (list (car lst) (cadr lst))  ; Create a pair from the first two elements
            (group-pairs (cddr lst)); Recur on the rest of the list, skipping two elements at a time
            )
      )
   )  

(define (top-5-pairs pairs-list)
  (define sorted-pairs (sort pairs-list > #:key car)) ; Sort the list of pairs by the first element in descending order
  (take sorted-pairs 5); Take the first 5 pairs from the sorted list
  )  


(define (printfilepair lstofpairs)
  (if (null? lstofpairs)
      '()
       (cons (substring (car (cdr (car lstofpairs))) 0 (- (string-length (car (cdr (car lstofpairs)))) 4)) (printfilepair (cdr lstofpairs)))
       )
  )

