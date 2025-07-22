#lang racket

(provide nand-gate)

(define (nand-gate a b)
  (match (list a b)
    [(list 1 1) 0]
    [_          1]))

(module+ test
  (require rackunit)
  (check-equal? (nand-gate 0 0) 1)
  (check-equal? (nand-gate 1 0) 1)
  (check-equal? (nand-gate 0 1) 1)
  (check-equal? (nand-gate 1 1) 0))