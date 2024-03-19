#lang racket

(define (insertion-sort vec)
  (define (insertion-sort-helper vec n)
    (if (>= n (vector-length vec))
        vec
        (begin
          (insertion-sort-helper (insertion-sort-one vec n) (+ n 1)))))
  
  (define (insertion-sort-one vec n)
    (let* ((mutable-vec (vector-copy vec))
           (key (vector-ref mutable-vec n)))
      (let loop ((j (- n 1)))
        (cond ((and (>= j 0) (> (vector-ref mutable-vec j) key))
               (vector-set! mutable-vec (+ j 1) (vector-ref mutable-vec j))
               (vector-set! mutable-vec j key)
               (loop (- j 1)))
              (else mutable-vec)))))
  
  (insertion-sort-helper vec 1))

;(display (insertion-sort '#(10 18 3 22 9 31 45 28))) ; Test case
;(display (insertion-sort '#(4 121 18 32 22 9 31 45 28 2 91 1))) ; Test case
