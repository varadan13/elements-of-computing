#lang racket

(require "and.rkt"
         "or.rkt"
         "not.rkt")
(provide mux)

; Mux = OR(AND(a, NOT(sel)), AND(b, sel))
(define (mux a b sel)
  (or-gate (and-gate a (not-gate sel))
           (and-gate b sel)))

(module+ test
  (require rackunit)

  ; sel=0 → out=a
  (check-equal? (mux 0 0 0) 0)
  (check-equal? (mux 0 1 0) 0)
  (check-equal? (mux 1 0 0) 1)
  (check-equal? (mux 1 1 0) 1)
  ; sel=1 → out=b
  (check-equal? (mux 0 0 1) 0)
  (check-equal? (mux 0 1 1) 1)
  (check-equal? (mux 1 0 1) 0)
  (check-equal? (mux 1 1 1) 1))
