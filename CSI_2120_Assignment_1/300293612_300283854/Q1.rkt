#lang racket
(define (solve-quadratic a b c)
  (if (< (- (* b b) (* 4 (* a c))) 0)
      '()
      (if (equal? (- (* b b) (* 4 (* a c))) 0)
          (list (/ (+ (* b -1) (sqrt (- (* b b) (* 4 (* a c))))) (* 2 a)))

          (list (/ (+ (* b -1) (sqrt (- (* b b) (* 4 (* a c))))) (* 2 a)) (/ (- (* b -1) (sqrt (- (* b b) (* 4 (* a c))))) (* 2 a)))
          )
      )
  )