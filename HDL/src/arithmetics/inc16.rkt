#lang racket

(require "./adder16.rkt")

(provide inc16)

(define (inc16 in)
  (define one '(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (adder16 in one))

(module+ test
  (require rackunit)

  (define zero16 '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define one16 '(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define two16 '(0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

  (check-equal? (inc16 zero16) one16)
  (check-equal? (inc16 one16) two16))
