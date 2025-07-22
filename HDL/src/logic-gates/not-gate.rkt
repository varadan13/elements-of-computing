#lang racket

(require "./nand-gate.rkt")

(provide not-gate)

(define (not-gate in)
  (nand-gate in in))

(module+ test
  (require rackunit)
  (check-equal? (not-gate 0) 1)
  (check-equal? (not-gate 1) 0))