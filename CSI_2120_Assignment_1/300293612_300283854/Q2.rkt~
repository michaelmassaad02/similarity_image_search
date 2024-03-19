#lang racket

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

  (filter (lambda (word) (hidden-in-word? (string->list word) (string->list str))) word-list)
  )

; Example usage:
;(display (hidden-words "subdermatoglyphic" '("set" "graphic" "drama" "toy" "brag")))
;(display (hidden-words "carter" '("set" "graphic" "drama" "toy" "brag" "cat")))

