#lang racket

(require "not.rkt")
(provide not16)

; Not16 = for each bit i in 0..15: out[i] = NOT(in[i])
(define (not16 in)
  (map not-gate in))

(module+ test
  (require rackunit)

  (check-equal? (not16 '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
                '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))

  (check-equal? (not16 '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))
                '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

  (check-equal? (not16 '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0))
                '(0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1)))
