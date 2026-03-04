#lang racket

(require "half-adder.rkt"
         "or.rkt")
(provide full-adder)

; FullAdder: half-adder(a,b) → (sum1, c1), half-adder(sum1, c) → (sum, c2), carry = OR(c1, c2)
(define (full-adder a b c)
  (define-values (sum1 carry1) (half-adder a b))
  (define-values (sum  carry2) (half-adder sum1 c))
  (values sum (or-gate carry1 carry2)))

(module+ test
  (require rackunit)

  (define (run a b c) (define-values (s k) (full-adder a b c)) (list s k))

  (check-equal? (run 0 0 0) '(0 0))
  (check-equal? (run 0 0 1) '(1 0))
  (check-equal? (run 0 1 0) '(1 0))
  (check-equal? (run 0 1 1) '(0 1))
  (check-equal? (run 1 0 0) '(1 0))
  (check-equal? (run 1 0 1) '(0 1))
  (check-equal? (run 1 1 0) '(0 1))
  (check-equal? (run 1 1 1) '(1 1)))
