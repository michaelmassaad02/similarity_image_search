#lang racket

;Michael Massaad 300293612
;Matin Mobini 300283854

;Question 1: defined a function "solve-quadratic" to find the roots of a quadratic equation. Test case: (solve-quadratic a b c)

(define (solve-quadratic a b c)
  (if (< (- (* b b) (* 4 (* a c))) 0); checks if the determinant under the square root is negative, we know that if it is, then there are no roots/we return an empty list
      '()
      (if (equal? (- (* b b) (* 4 (* a c))) 0); if it is equal to 0 then we know it only has one root, so we return the solution
          (list (/ (+ (* b -1) (sqrt (- (* b b) (* 4 (* a c))))) (* 2 a)))

          (list (/ (+ (* b -1) (sqrt (- (* b b) (* 4 (* a c))))) (* 2 a)) (/ (- (* b -1) (sqrt (- (* b b) (* 4 (* a c))))) (* 2 a)));else we return both values for the roots
          )
      )
  )


;TEST CASES
(solve-quadratic 4 5 -10)
;Expected results:
;'(1.0751838135919305 -2.3251838135919307)
(solve-quadratic 1 -2 1)
;Expected results:
;'(1)
(solve-quadratic 3 2 1)
;Expected results:
;'()
