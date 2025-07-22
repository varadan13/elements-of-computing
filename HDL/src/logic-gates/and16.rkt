#lang racket

(require "./and-gate.rkt")

(provide and16)

(define (and16 a b)
  (cond
    [(empty? a) empty]
    [else (cons (and-gate (first a) (first b))
                (and16 (rest a) (rest b)))]))


(module+ test
  (require rackunit)

  (define all-ones '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))
  (define all-zeros '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define alt '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0))
  (define alt-flip '(0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1))
  (define alt-result '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

  (check-equal? (and16 all-ones all-ones) all-ones)
  (check-equal? (and16 all-ones all-zeros) all-zeros)
  (check-equal? (and16 alt alt-flip) alt-result)
  (check-equal? (and16 alt all-ones) alt))
