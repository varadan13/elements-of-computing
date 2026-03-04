#lang racket

(require "and.rkt"
         "or.rkt"
         "not.rkt")
(provide xor-gate)

; Xor = OR(AND(a, NOT(b)), AND(NOT(a), b))
(define (xor-gate a b)
  (or-gate (and-gate a (not-gate b))
           (and-gate (not-gate a) b)))

(module+ test
  (require rackunit)

  (check-equal? (xor-gate 0 0) 0)
  (check-equal? (xor-gate 0 1) 1)
  (check-equal? (xor-gate 1 0) 1)
  (check-equal? (xor-gate 1 1) 0))
