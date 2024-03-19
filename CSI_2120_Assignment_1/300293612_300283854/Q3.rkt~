#lang racket


(define (geometric-sequence-loop first-number ratio n)
  (define result '()) ; Define an empty list to store the sequence

  (do ((i 0 (+ i 1))) ; Start a loop from 0 to n-1
      ((= i n) result) ; Terminate the loop when i reaches n, and return the result
    (set! result (append result (list first-number))) ; Append the current number to the result list
    (set! first-number (* first-number ratio)) ; Calculate the next number in the sequence
    )
  )


; Example usage:
(display (geometric-sequence-loop 7 3 5)) ; Output: (7 21 63 189 567)
(display (geometric-sequence-loop 9 -1 7)) ; Output: (9 -9 9 -9 9 -9 9)
(display (geometric-sequence-loop 2 2 10)) ; Output: (9 -9 9 -9 9 -9 9)



