#lang racket


(define (make-graph)
  (let ((graph (make-hash)))
    (hash-set! graph 1 '())
    graph
    )
  )

(define (make-graph-n-nodes n)
  (let ((graph (make-hash)))
    (do ((i 1 (+ i 1)))
      ((= i (+ n 1)) graph)
      (hash-set! graph i '())
      )
    )
  )

(define (add-vertex g)
  (let ((size (hash-count g)))
    (hash-set! g (+ size 1) '())
    )
  )


(define (add-edge g u v)
  (if (and (member u (hash-keys g)) (member v (hash-keys g)))
      (begin
        (hash-set! g u (cons v (hash-ref g u)))
        (hash-set! g v (cons u (hash-ref g v)))
        g
        )
      g
      )
  )

(define (find-path g u v)
  (if (or (not (member u (hash-keys g))) (not (member v (hash-keys g))))
      '()
      (path-finder g u v u '())
      )
  )

(define (path-finder g u v current visited)
  (if (= current v)
      (reverse (cons v visited))
      (let nextvertex ((edges (hash-ref g current)))
        (cond
          ((null? edges) '())
          ((member (car edges) visited) (nextvertex (cdr edges)))
          (else
           (let ((potentialpath (path-finder g u v (car edges) (cons current visited))))
             (if (null? potentialpath)
                 (nextvertex (cdr edges))
                 potentialpath
                 )
             )          
           )

          )
        )
      )
  )


(define (edges g)
  (edgelist g (hash-keys g) '())
  )

(define (edgelist g keys lst)
  (if (null? keys)
      (reverse lst)
      (let vertices ((adjacent (hash-ref g (car keys))))
        (cond
          ((null? adjacent) (edgelist g (cdr keys) lst))
          (else
           (set! lst (cons (cons (car keys) (car adjacent)) lst))
           (vertices (cdr adjacent))
           )
          )
        )
      )
  )
