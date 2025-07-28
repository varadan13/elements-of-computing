#lang racket

(require racket/string)

(define input
  (string->list (file->string "input.txt")))

(define location (make-hash))

(define coord (make-hash)) 

(hash-set! coord #\^ #(0 1))
(hash-set! coord #\v #(0 -1))
(hash-set! coord #\> #(1 0))
(hash-set! coord #\< #(-1 0))

(define (x vector) (vector-ref vector 0))
(define (y vector) (vector-ref vector 1))
(define (dx vector) (vector-ref vector 0))
(define (dy vector) (vector-ref vector 1))

(define (transform lst site-visited current-coord)
  (cond
    [(null? lst) site-visited]
    [else
     (define vec (hash-ref coord (car lst)))
     (define next-coord (vector (+ (vector-ref current-coord 0) (vector-ref vec 0))
                                (+ (vector-ref current-coord 1) (vector-ref vec 1))))
     (if (hash-has-key? location next-coord)
         (transform (cdr lst) site-visited next-coord)
         (begin
           (hash-set! location next-coord #t)
           (transform (cdr lst) (+ site-visited 1) next-coord)))]))

(define final-solution (transform input 1 #(0 0)))

(printf "Part 1 solution: ~a~%" final-solution)

(define (split-even-odd lst)
  (define (helper lst even odd idx)
    (cond
      [(null? lst) (values (reverse even) (reverse odd))]
      [(even? idx) (helper (cdr lst) (cons (car lst) even) odd (+ idx 1))]
      [else        (helper (cdr lst) even (cons (car lst) odd) (+ idx 1))]))
  (helper lst '() '() 0))

(define-values (even odd) (split-even-odd input))

(define location-1 (make-hash))

(define (transform-1 lst site-visited current-coord)
  (cond
    [(null? lst) site-visited]
    [else
     (define vec (hash-ref coord (car lst)))
     (define next-coord (vector (+ (vector-ref current-coord 0) (vector-ref vec 0))
                                (+ (vector-ref current-coord 1) (vector-ref vec 1))))
     (if (hash-has-key? location-1 next-coord)
         (transform-1 (cdr lst) site-visited next-coord)
         (begin
           (hash-set! location-1 next-coord #t)
           (transform-1 (cdr lst) (+ site-visited 1) next-coord)))]))

(define location-2 (make-hash))

(define (transform-2 lst site-visited current-coord)
  (cond
    [(null? lst) site-visited]
    [else
     (define vec (hash-ref coord (car lst)))
     (define next-coord (vector (+ (vector-ref current-coord 0) (vector-ref vec 0))
                                (+ (vector-ref current-coord 1) (vector-ref vec 1))))
     (if (hash-has-key? location-2 next-coord)
         (transform-2 (cdr lst) site-visited next-coord)
         (begin
           (hash-set! location-2 next-coord #t)
           (transform-2 (cdr lst) (+ site-visited 1) next-coord)))]))


(define final-solution-2 (+ (transform-1 even 1 #(0 0)) (transform-2 odd 1 #(0 0))))

(printf "Part 2 solution: ~a~%" final-solution-2)

