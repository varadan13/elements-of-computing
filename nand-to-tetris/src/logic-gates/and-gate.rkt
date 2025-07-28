#lang racket

(require "./nand-gate.rkt")
(require "./not-gate.rkt")

(provide and-gate)

(define (and-gate a b)
  (not-gate (nand-gate a b)))

(module+ test
  (require rackunit)
  
  (check-equal? (and-gate 0 0) 0)
  (check-equal? (and-gate 0 1) 0) 
  (check-equal? (and-gate 1 0) 0) 
  (check-equal? (and-gate 1 1) 1))