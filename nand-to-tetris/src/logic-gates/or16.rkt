#lang racket

(require "./or-gate.rkt")

(provide or16)

(define (or16 a b)
  (cond
    [(empty? a) empty]
    [else (cons (or-gate (first a) (first b))
                (or16 (rest a) (rest b)))]))

(module+ test
  (require rackunit)

  (define all-ones  '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))
  (define all-zeros '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define alt       '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0))
  (define alt-flip  '(0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1))
  (define all-mixed '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))

  (check-equal? (or16 all-zeros all-zeros) all-zeros)
  (check-equal? (or16 all-ones all-ones) all-ones)
  (check-equal? (or16 all-ones all-zeros) all-ones)
  (check-equal? (or16 alt alt-flip) all-mixed)
  (check-equal? (or16 alt all-zeros) alt)
  (check-equal? (or16 alt all-ones) all-ones))
