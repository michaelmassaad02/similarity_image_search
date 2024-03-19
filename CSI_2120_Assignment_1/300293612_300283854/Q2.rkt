#lang racket
;Matin Mobini 300283854
;Michael Massaad 300293612


;Question 2: we defined a function "hidden-words" to check a large string for given set of strings, each given string that can be found within the large string is added to the result

(define (hidden-words str word-list)
  (define (hidden-in-word? word str)
    (let loop ((word word) (str str))
      (cond
        ((null? word) #t) ; If the word is empty, it means all characters were found
        ((null? str) #f)  ; If the string is empty before the word is found, it's not hidden
        ((char=? (car word) (car str)) (loop (cdr word) (cdr str))) ; If characters match, continue checking
        (else (loop word (cdr str))) ; Otherwise, continue with the next character in the string
        )
      )
    )

  (filter (lambda (word) (hidden-in-word? (string->list word) (string->list str))) word-list) ;We use the built in filter function to help construct our solution
  )

; TEST CASES:
(hidden-words "subdermatoglyphic" '("set" "graphic" "drama" "toy" "brag"))
;Expected Results:
;'("set" "toy" "brag")
(hidden-words "carter" '("set" "graphic" "drama" "toy" "brag" "cat"))
;Expected Results:
;'("cat")