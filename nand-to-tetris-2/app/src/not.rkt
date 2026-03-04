#lang racket

(require "nand.rkt")
(provide not-gate)

; Not = NAND(in, in)
(define (not-gate in)
  (nand-gate in in))

(module+ test
  (require rackunit)

  (check-equal? (not-gate 0) 1)
  (check-equal? (not-gate 1) 0))
