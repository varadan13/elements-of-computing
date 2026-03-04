#lang racket

(require "xor.rkt"
         "and.rkt")
(provide half-adder)

; HalfAdder: sum = XOR(a, b), carry = AND(a, b)
(define (half-adder a b)
  (values (xor-gate a b)
          (and-gate a b)))

(module+ test
  (require rackunit)

  (define (run a b) (define-values (s c) (half-adder a b)) (list s c))

  (check-equal? (run 0 0) '(0 0))
  (check-equal? (run 0 1) '(1 0))
  (check-equal? (run 1 0) '(1 0))
  (check-equal? (run 1 1) '(0 1)))
