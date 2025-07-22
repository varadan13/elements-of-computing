#lang racket

(require "../logic-gates/xor-gate.rkt")
(require "../logic-gates/and-gate.rkt")
(require "../logic-gates/or-gate.rkt")

(provide full-adder)

(define (full-adder a b cin)
  (let* ([ab-xor (xor-gate a b)]
         [sum (xor-gate ab-xor cin)]
         [carry1 (and-gate a b)]
         [carry2 (and-gate ab-xor cin)]
         [cout (or-gate carry1 carry2)])
    (list sum cout)))

(module+ test
  (require rackunit)
  (check-equal? (full-adder 0 0 0) '(0 0))
  (check-equal? (full-adder 0 0 1) '(1 0))
  (check-equal? (full-adder 0 1 0) '(1 0))
  (check-equal? (full-adder 0 1 1) '(0 1))
  (check-equal? (full-adder 1 0 0) '(1 0))
  (check-equal? (full-adder 1 0 1) '(0 1))
  (check-equal? (full-adder 1 1 0) '(0 1))
  (check-equal? (full-adder 1 1 1) '(1 1)))
