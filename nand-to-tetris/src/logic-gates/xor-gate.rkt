#lang racket

(require "./not-gate.rkt")
(require "./and-gate.rkt")
(require "./or-gate.rkt")

(provide xor-gate)

(define (xor-gate a b)
   (or-gate (and-gate a (not-gate b)) (and-gate (not-gate a) b)))

(module+ test
  (require rackunit)
  
  (check-equal? (xor-gate 0 0) 0)
  (check-equal? (xor-gate 0 1) 1) 
  (check-equal? (xor-gate 1 0) 1) 
  (check-equal? (xor-gate 1 1) 0))