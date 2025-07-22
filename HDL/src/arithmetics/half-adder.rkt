#lang racket

(require "../logic-gates/xor-gate.rkt")
(require "../logic-gates/and-gate.rkt")

(provide half-adder)

(define (half-adder a b)
  (list (xor-gate a b)      
        (and-gate a b)))    

(module+ test
  (require rackunit)
  
  (check-equal? (half-adder 0 0) '(0 0))
  (check-equal? (half-adder 0 1) '(1 0))
  (check-equal? (half-adder 1 0) '(1 0))
  (check-equal? (half-adder 1 1) '(0 1)))
