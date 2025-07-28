#lang racket

(require "./not-gate.rkt")

(provide not16)

(define (not16 in-bits)
  (cond
    [(empty? in-bits) empty]
    [else (cons (not-gate (first in-bits))
                (not16 (rest in-bits)))]))

(module+ test
  (require rackunit)
  
  (check-equal? (not16 '(0  0 0 0 0 0 0 0 0 0 0 0 0 0 0))
                '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))
  (check-equal? (not16 '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0))
                '(0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1)))
