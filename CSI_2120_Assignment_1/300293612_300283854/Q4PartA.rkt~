#lang racket
;Matin Mobini 300283854
;Michael Massaad 300293612

;GIVEN LAB 5 Thursday solutions:

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
        (if (> x p)
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



;Michael's LAB5 code:

(define (remove heap) ;; creating a new heap that has its original root removed and the last inserted element as the root
  (if (empty? (vector->list heap))
      '()
      (begin
        (let* ((lst (vector->list heap)) (revl (reverse lst))) 
           (cons (car lst) (downheap (list->vector (cons (car revl) (reverse (cdr (reverse (cdr lst)))))) 0)) ;; reorganize the heap in order to have the max element as the root
          );We altered Michael's code to now return a pair, from which the car is the root, and the tail is the rest of the heap.
        )
      )
 
  
  )

(define (downheap vector index) ;; similar to the upheap method implemented before, but we retrieve the index of the child with the greater value and we compare it to the current element
  (if (= (maxCI vector index) index)
      vector
      (let* ((MaxChildIndex (maxCI vector index)) (p (vector-ref vector index)) (c (vector-ref vector MaxChildIndex)))
        (if (> c p)
            (begin
              (vector-set! vector MaxChildIndex p)
              (vector-set! vector index c)
              (downheap vector MaxChildIndex)
              )
            (downheap vector MaxChildIndex)
            )
        )
      )
  )

(define (maxCI heap parent) ;; retrieves the child with the greater value, similar to min-child method seen during tutorial
   (let ((n (vector-length heap))
         (p (vector-ref heap parent))
         (lchI (+ (* 2 parent) 1))
         (rchI (+ (* 2 parent) 2)))
     (cond
       ((>= lchI n) parent)
       ((>= rchI n) (if (> p (vector-ref heap lchI)) parent lchI))
       (else
        (let ((lch (vector-ref heap lchI))
              (rch (vector-ref heap rchI))
              )
          (cond
            ((and (> p lch) (> p rch)) parent)
            ((and (> lch p) (> lch rch)) lchI)
            (else rchI)
            )
          )
        )
       )
     )
   )


;Question 4A: we defined an new function "heap-sort" to add the given values to a max-heap, then remove them one by one into a list which results in a order solution

;OUR solution code:

(define (heap-sort vec)

  (define (build-heap vec)
    (do ((i 0 (+ i 1)))
      ((= i (vector-length vec)) vec)
      (adjust! vec i)))

  (define (heap-removemax heap lst) ;keep removing all the head of the heap and add it into the given empty list lst
    (if (= 1 (vector-length heap));Stop at one and just add that value to the list, then return said list as the solution
        (cons (car (vector->list heap)) lst)
        (begin
          (let* ((heap-pair (remove heap)) (newlst (cons (car heap-pair) lst)))
            (heap-removemax (cdr heap-pair) newlst)
            )
          )
        )
    )

  ;; Create a copy of the input vector
  (let ((heap (vector-copy vec)))
    (build-heap heap);we call the build function to populate the heap
    (heap-removemax heap '()); we call the remove max function to remove the max of the heap until there is none left to take, which then we return our result
    )

  )

; TEST CASES
(heap-sort '#(10 18 3 22 9 31 45 28))
;Expected Results: '(3 9 10 18 22 28 31 45)
(heap-sort '#(82 21 62 1 162 96 96 16 49 49 21 121))
;;Expected Results: '(1 16 21 21 49 49 62 82 96 96 121 162)
