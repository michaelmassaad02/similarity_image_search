#lang racket

;GIVEN LAB 5 solutions:


(define (vector-add vec x)
  (list->vector (append (vector->list vec) (list x)))
  )

(define (vector-remove vec)
  (let* ((lst (vector->list vec)) (revlst (reverse lst)))
        (list->vector (cons (car revlst) (reverse (cdr (reverse (cdr lst)))))) 
        )
  )

(define (parent index)
  (if (equal? (modulo index 2) 0)
      (quotient (- index 2) 2)
      (quotient (- index 1) 2)
      )
  )

(define (adjust! vec index)
  (if (equal? index 0)
      vec
      (let* ((pind (parent index)) (x (vector-ref vec index)) (p (vector-ref vec pind)))
        (if (< x p)
            (begin
              (vector-set! vec pind x)
              (vector-set! vec index p)
              (adjust! vec pind)
              )
            (adjust! vec pind)
            )
        )
      )
  )

(define (min-child vec index)
  (let ((n (vector-length vec))
        (p (vector-ref vec index))
        (lch-index (+ (* 2 index) 1))
        (rch-index (+ (* 2 index) 2)))
    (cond
      ((>= lch-index n) index)
      ((>= rch-index n) (if (< p (vector-ref vec lch-index)) index lch-index))
      (else
       (let  ((lch (vector-ref vec lch-index))
              (rch (vector-ref vec rch-index)))
         (cond
           ((and (< p lch) (< p rch)) index)
           ((and (< lch p) (< lch rch)) lch-index)
           (else rch-index)
           )
       )
      )
    )
  )
 )

(define (delete! vec index)
  (if (>= index (vector-length vec))
      vec
      (let ((ind (min-child vec index)))
        (if (equal? ind index)
            vec
            (let ((ch (vector-ref vec ind)) (p (vector-ref vec index)))
             (begin
               (vector-set! vec ind p)
               (vector-set! vec index ch)
               (delete! vec ind)
               )
             )
            )
          )
        )
      )

(define (insert heap value)
  (let* ((new-heap (vector-add heap value))
         (n (vector-length new-heap)))
    (adjust! new-heap (- n 1))
    )
  )

(define (remove heap)
  (let ((new-heap (vector-remove heap)))
    (delete! new-heap 0)
    )
  )


(define (heap-sort vec)
  ;; Insert all elements of the vector into the min-heap
  (define (build-heap vec)
    (do ((i (quotient (vector-length vec) 2) (sub1 i)))
        ((< i 0) vec)
      (adjust! vec i)))
  
  (define (extract-min heap size)
    (let ((min (vector-ref heap 0)))
      (vector-set! heap 0 (vector-ref heap (sub1 size)))
      (delete! heap 0)
      min))

  (define (sort-heap vec)
    (define size (vector-length vec))
    (do ((i (sub1 size) (sub1 i)))
        ((< i 0) vec)
      (vector-set! vec i (extract-min vec (+ i 1)))))

  ;; Create a copy of the input vector
  (let ((heap (vector-copy vec)))
    (build-heap heap)
    (sort-heap heap))
  )


;; Test the heap-sort function
(heap-sort '#(10 18 3 22 9 31 45 28));The solution follows the rules of Min-heap, although we would have to make a new method to sort it to make it
                                     ;excactly how the sample output is, although im not sure if we are supposed to do that becuase then the heap-sort was just useless

