#lang racket

;Matin Mobini 300283854
;Michael Massaad 300293612

;Question 3: We defined a function "geometric-sequence-loop" to multiply the first number by a ratio, n times.

(define (geometric-sequence-loop first-number ratio n)
  (define result '()) ; Define an empty list to store the sequence

  (do ((i 0 (+ i 1))) ; Start a loop from 0 to n-1
      ((= i n) result) ; Terminate the loop when i reaches n, and return the result
    (set! result (append result (list first-number))) ; Append the current number to the result list
    (set! first-number (* first-number ratio)) ; Calculate the next number in the sequence
    )
  )


;TEST CASES:
(geometric-sequence-loop 7 3 5)
;Expected Result: '(7 21 63 189 567)
(geometric-sequence-loop 9 -1 7) 
;Expected Result: '(9 -9 9 -9 9 -9 9)
(geometric-sequence-loop 2 2 10) 
;Expected Result: '(2 4 8 16 32 64 128 256 512 1024)


