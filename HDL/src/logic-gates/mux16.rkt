#lang racket

(require "./mux.rkt")

(provide mux16)

(define (mux16 a b sel)
  (cond
    [(empty? a) empty]
    [else (cons (mux (first a) (first b) sel)
                (mux16 (rest a) (rest b) sel))]))

(module+ test
  (require rackunit)

  (define all-zeros '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define all-ones  '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))
  (define alt       '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0))
  (define alt-flip  '(0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1))

  (check-equal? (mux16 alt alt-flip 0) alt)
  (check-equal? (mux16 alt alt-flip 1) alt-flip)
  (check-equal? (mux16 all-zeros all-ones 0) all-zeros)
  (check-equal? (mux16 all-zeros all-ones 1) all-ones)
  (check-equal? (mux16 alt alt 0) alt)
  (check-equal? (mux16 alt alt 1) alt))
