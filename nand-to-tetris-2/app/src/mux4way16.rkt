#lang racket

(require "mux16.rkt")
(provide mux4way16)

; Mux4Way16 = mux16(mux16(a,b,sel[0]), mux16(c,d,sel[0]), sel[1])
; sel is a 2-element list: (list sel[0] sel[1]), sel[0] is LSB
(define (mux4way16 a b c d sel)
  (let ([s0 (first sel)]
        [s1 (second sel)])
    (mux16 (mux16 a b s0)
           (mux16 c d s0)
           s1)))

(module+ test
  (require rackunit)

  (define all-zeros '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define all-ones  '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))
  (define pattern-a '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0))
  (define pattern-b '(0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1))

  ; sel=00 → out=a
  (check-equal? (mux4way16 pattern-a all-zeros all-ones pattern-b '(0 0)) pattern-a)
  ; sel=01 → out=b
  (check-equal? (mux4way16 pattern-a all-zeros all-ones pattern-b '(1 0)) all-zeros)
  ; sel=10 → out=c
  (check-equal? (mux4way16 pattern-a all-zeros all-ones pattern-b '(0 1)) all-ones)
  ; sel=11 → out=d
  (check-equal? (mux4way16 pattern-a all-zeros all-ones pattern-b '(1 1)) pattern-b))
