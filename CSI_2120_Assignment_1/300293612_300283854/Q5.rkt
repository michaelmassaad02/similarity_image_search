#lang racket

;Matin Mobini 300283854
;Michael Massaad 300293612

;This implementation represents a graph that is undirected

(define (make-graph);Define a function called make-graph to create an empty graph
  (let ((graph (make-hash)))
    (hash-set! graph 1 '())
    graph
    )
  )

(define (make-graph-n-nodes n); Define a function called make-graph-n-nodes to create a graph with n nodes
  (let ((graph (make-hash)))
    (do ((i 1 (+ i 1)))
      ((= i (+ n 1)) graph)
      (hash-set! graph i '())
      )
    )
  )

(define (add-vertex g); Define a function called add-vertex to add a new vertex to the graph
  (let ((size (hash-count g)))
    (hash-set! g (+ size 1) '())
    )
  )


(define (add-edge g u v); Define a function called add-edge to add an edge between two vertices u and v
  (if (and (member u (hash-keys g)) (member v (hash-keys g)))
      (begin
        (hash-set! g u (cons v (hash-ref g u)))
        (hash-set! g v (cons u (hash-ref g v)))
        g
        )
      g
      )
  )

(define (find-path g u v); Define a function called find-path to find a path between vertices u and v in the graph
  (if (or (not (member u (hash-keys g))) (not (member v (hash-keys g))))
      '()
      (path-finder g u v u '())
      )
  )

(define (path-finder g u v current visited); Define a helper function called path-finder to recursively find a path
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


(define (edges g); Define a function called edges to retrieve a list of edges in the graph
  (edgelist g (hash-keys g) '())
  )

(define (edgelist g keys lst); Define a helper function called edgelist to recursively generate a list of edges
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

;TEST CASES
(define mygraph (make-graph-n-nodes 4))


(add-edge mygraph 1 2)
(add-edge mygraph 2 3)
(add-edge mygraph 3 4)
;(add-edge mygraph 3 1) add this to skip visiting vertex 2

(edges mygraph)

(find-path mygraph 1 4)


;TEST#2
(define mygraph2 (make-graph))

(add-vertex mygraph2)
(add-vertex mygraph2)
(add-vertex mygraph2)
(add-vertex mygraph2)


(add-edge mygraph2 1 4)
(add-edge mygraph2 2 3)
(add-edge mygraph2 3 4)
(add-edge mygraph2 2 5)

(edges mygraph2)

(find-path mygraph2 1 5)


