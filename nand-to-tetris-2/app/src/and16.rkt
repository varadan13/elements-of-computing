#lang racket

(require "and.rkt")
(provide and16)

; And16 = for each bit i in 0..15: out[i] = AND(a[i], b[i])
(define (and16 a b)
  (map and-gate a b))

(module+ test
  (require rackunit)

  (check-equal? (and16 '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                       '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
                '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

  (check-equal? (and16 '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
                       '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))
                '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))

  (check-equal? (and16 '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0)
                       '(1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0))
                '(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0)))
