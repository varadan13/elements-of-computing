#lang racket

(require "dmux.rkt")
(provide dmux4way)

; DMux4Way: first dmux on sel[1] splits in into two halves,
; then dmux each half on sel[0] → (a,b) and (c,d)
; sel is (list sel[0] sel[1]), sel[0] is LSB
(define (dmux4way in sel)
  (let ([s0 (first sel)]
        [s1 (second sel)])
    (define-values (first-half second-half) (dmux in s1))
    (define-values (a b) (dmux first-half s0))
    (define-values (c d) (dmux second-half s0))
    (values a b c d)))

(module+ test
  (require rackunit)

  ; sel=00 → a=in
  (define-values (a0 b0 c0 d0) (dmux4way 1 '(0 0)))
  (check-equal? (list a0 b0 c0 d0) '(1 0 0 0))

  ; sel=01 → b=in
  (define-values (a1 b1 c1 d1) (dmux4way 1 '(1 0)))
  (check-equal? (list a1 b1 c1 d1) '(0 1 0 0))

  ; sel=10 → c=in
  (define-values (a2 b2 c2 d2) (dmux4way 1 '(0 1)))
  (check-equal? (list a2 b2 c2 d2) '(0 0 1 0))

  ; sel=11 → d=in
  (define-values (a3 b3 c3 d3) (dmux4way 1 '(1 1)))
  (check-equal? (list a3 b3 c3 d3) '(0 0 0 1)))
