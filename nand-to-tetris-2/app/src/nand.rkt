#lang racket

(provide nand-gate)

; Nand = primitive gate — if a=b=1 then out=0 else out=1
(define (nand-gate a b)
  (match (list a b)
    [(list 1 1) 0]
    [_          1]))

(module+ test
  (require rackunit)

  (check-equal? (nand-gate 0 0) 1)
  (check-equal? (nand-gate 0 1) 1)
  (check-equal? (nand-gate 1 0) 1)
  (check-equal? (nand-gate 1 1) 0))
