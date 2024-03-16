#lang racket

;JUST run to create the out.txt file

(define (read-file filename)
  (with-input-from-file filename
    (lambda ()
      (let ((num (string->number (read-line))))
        (let loop ((numbers '())
                   (count 0))
          (if (= count num)
              (reverse numbers) ; Skip the first number
              (loop (cons (string->number (read-line)) numbers)
                    (+ count 1))))))))

(define (write-file filename data)
  (with-output-to-file filename
    (lambda ()
      (for-each (lambda (x) (display x) (newline)) data))))

(define (longest-increasing-subsequence number numbers)
  (define (lis-helper nums)
    (let loop ((nums nums)
               (current '())  ; Current increasing subsequence
               (best '()))    ; Best increasing subsequence found so far
      (cond
        ((null? nums)
         (if (> (length current) (length best))
             current
             best))
        ((null? current) ; Handle the case when the current subsequence is empty
         (loop (cdr nums) (list (car nums)) best))
        ((< (car nums) (car current))  ; Skip if the number is smaller than the first of current sequence
         (loop (cdr nums) current best))
        ((< (car current) (car nums))  ; If current number is greater, consider it in the sequence
         (let ((extended (loop (cdr nums) (cons (car nums) current) best)))
           (if (> (length extended) (length best))
               extended
               best)))
        (else  ; If current number is equal, proceed to next number
         (let ((extended (loop (cdr nums) (cons (car nums) current) best)))
           (if (> (length extended) (length best))
               extended
               best))))))

  (let* ((index (let loop ((nums numbers)
                            (count 0))
                  (if (= (car nums) number)
                      count
                      (loop (cdr nums) (+ count 1)))))
         (nums (if (zero? index)
                   numbers
                   (let loop ((n numbers) (i index))
                     (if (zero? i)
                         n
                         (loop (cdr n) (- i 1)))))))
    (lis-helper nums)))




(define (main)
  (let* ((numbers (read-file "in.txt"))
         (subsequences (map (lambda (number) (longest-increasing-subsequence number numbers)) numbers))
         (longest (foldl (lambda (subseq acc)
                           (if (> (length subseq) (length acc))
                               subseq
                               acc))
                         '() subsequences)))
    (write-file "out.txt" (cons (length longest) (reverse longest)))))

(main)


