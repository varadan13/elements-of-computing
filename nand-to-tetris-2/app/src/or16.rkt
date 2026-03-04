#lang racket

(require "or.rkt")
(provide or16)

; Or16 = for each bit i in 0..15: out[i] = OR(a[i], b[i])
(define (or16 a b)
  (map or-gate a b))

(module+ test
  (require rackunit)

  (check-equal? (or16 '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                      '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
                '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

  (check-equal? (or16 '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
                      '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
                '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))

  (check-equal? (or16 '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0)
                      '(0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1))
                '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)))
