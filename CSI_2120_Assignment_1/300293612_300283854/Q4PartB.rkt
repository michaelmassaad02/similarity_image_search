#lang racket
;Matin Mobini 300283854
;Michael Massaad 300293612



(define (insertion-sort vec); Define a function called insertion-sort that takes a vector as input
  (define (insertion-sort-helper vec n)
    (if (>= n (vector-length vec))
        vec
        (begin
          (insertion-sort-helper (insertion-sort-one vec n) (+ n 1)))))
  
  (define (insertion-sort-one vec n); Define a helper function called insertion-sort-helper that takes a vector and a number n as input
    (let* ((mutable-vec (vector-copy vec))
           (key (vector-ref mutable-vec n)))
      (let loop ((j (- n 1))); Define an inner loop starting from index n-1 and decreasing
        (cond ((and (>= j 0) (> (vector-ref mutable-vec j) key))
               (vector-set! mutable-vec (+ j 1) (vector-ref mutable-vec j))
               (vector-set! mutable-vec j key)
               (loop (- j 1)))
              (else mutable-vec)))))
  
  (insertion-sort-helper vec 1))

;TEST CASES:
(insertion-sort '#(10 18 3 22 9 31 45 28))
;Expected Result:'#(3 9 10 18 22 28 31 45)
(insertion-sort '#(4 121 18 32 22 9 31 45 28 2 91 1))
;Expected Results:'#(1 2 4 9 18 22 28 31 32 45 91 121)
