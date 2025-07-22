#lang racket

(require "./not-gate.rkt")

(require "./and-gate.rkt")

(require "./or-gate.rkt")

(provide mux)

(define (mux a b sel)
  (let* ([not-sel (not-gate sel)]
         [a-and (and-gate a not-sel)]
         [b-and (and-gate b sel)])
    (or-gate a-and b-and)))
    
(module+ test
  (require rackunit)
  (check-equal? (mux 0 0 0) 0)
  (check-equal? (mux 0 1 0) 0)
  (check-equal? (mux 0 1 1) 1)
  (check-equal? (mux 1 0 0) 1)
  (check-equal? (mux 1 0 1) 0)
  (check-equal? (mux 1 1 1) 1)
  (check-equal? (mux 1 1 0) 1))
