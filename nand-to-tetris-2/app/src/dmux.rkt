#lang racket

(require "and.rkt"
         "not.rkt")
(provide dmux)

; DMux = a: AND(in, NOT(sel)), b: AND(in, sel)
(define (dmux in sel)
  (values (and-gate in (not-gate sel))
          (and-gate in sel)))

(module+ test
  (require rackunit)

  ; sel=0 → a=in, b=0
  (define-values (a0 b0) (dmux 0 0))
  (check-equal? a0 0)
  (check-equal? b0 0)

  (define-values (a1 b1) (dmux 1 0))
  (check-equal? a1 1)
  (check-equal? b1 0)

  ; sel=1 → a=0, b=in
  (define-values (a2 b2) (dmux 0 1))
  (check-equal? a2 0)
  (check-equal? b2 0)

  (define-values (a3 b3) (dmux 1 1))
  (check-equal? a3 0)
  (check-equal? b3 1))
