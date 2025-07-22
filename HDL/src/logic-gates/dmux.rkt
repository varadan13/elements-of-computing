#lang racket

(require "./not-gate.rkt")

(require "./and-gate.rkt")

(require "./or-gate.rkt")

(provide dmux)

(define (dmux in sel)
  (define not-sel (not-gate sel))
  (define a (and-gate in not-sel)) 
  (define b (and-gate in sel))     
  (list a b)) 

(module+ test
  (require rackunit)
  (check-equal? (dmux 0 0) '(0 0))
  (check-equal? (dmux 1 0) '(1 0))
  (check-equal? (dmux 0 1) '(0 0))
  (check-equal? (dmux 1 1) '(0 1)))
