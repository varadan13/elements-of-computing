#lang racket

(require "nand.rkt"
         "not.rkt")
(provide or-gate)

; Or = NAND(NOT(a), NOT(b))
(define (or-gate a b)
  (nand-gate (not-gate a) (not-gate b)))

(module+ test
  (require rackunit)

  (check-equal? (or-gate 0 0) 0)
  (check-equal? (or-gate 0 1) 1)
  (check-equal? (or-gate 1 0) 1)
  (check-equal? (or-gate 1 1) 1))
