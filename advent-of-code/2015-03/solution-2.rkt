#lang racket
(require racket/set)

(define input
  (file->string "input.txt"))

(define direction-vectors
  (hash
    #\^ #(0 1)
    #\v #(0 -1)
    #\< #(-1 0)
    #\> #(1 0)))

(define (count-visited houses instructions)
  (define visited (make-hash))
  (define santa '(0 . 0))
  (define robo  '(0 . 0))
  (hash-set! visited santa #t)

  (for ([idx (in-range (string-length instructions))])
    (define ch (string-ref instructions idx))
    (define vec (hash-ref direction-vectors ch))
    (define dx (vector-ref vec 0))
    (define dy (vector-ref vec 1))

    (if (even? idx)
        (begin
          (set! santa (cons (+ (car santa) dx) (+ (cdr santa) dy)))
          (hash-set! visited santa #t))
        (begin
          (set! robo (cons (+ (car robo) dx) (+ (cdr robo) dy)))
          (hash-set! visited robo #t))))

  (hash-count visited))

(count-visited #f input) 

