#lang racket

(require "./nand-gate.rkt")
(require "./not-gate.rkt")

(provide or-gate)

(define (or-gate a b)
   (nand-gate (not-gate a) (not-gate b)))

(module+ test
  (require rackunit)
  
  (check-equal? (or-gate 0 0) 0)
  (check-equal? (or-gate 0 1) 1) 
  (check-equal? (or-gate 1 0) 1) 
  (check-equal? (or-gate 1 1) 1))