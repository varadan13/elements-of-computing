#lang racket

(require "mux.rkt")
(provide mux16)

; Mux16 = for each bit i in 0..15: out[i] = Mux(a[i], b[i], sel)
(define (mux16 a b sel)
  (map (lambda (ai bi) (mux ai bi sel)) a b))

(module+ test
  (require rackunit)

  ; sel=0 → out=a
  (check-equal? (mux16 '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0)
                       '(0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1)
                       0)
                '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0))

  ; sel=1 → out=b
  (check-equal? (mux16 '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0)
                       '(0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1)
                       1)
                '(0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1)))
