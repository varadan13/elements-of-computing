#lang racket

(require "dmux.rkt"
         "dmux4way.rkt")
(provide dmux8way)

; DMux8Way: first dmux on sel[2] splits in into low (a-d) and high (e-h),
; then dmux4way each half on sel[0..1]
; sel is (list sel[0] sel[1] sel[2]), sel[0] is LSB
(define (dmux8way in sel)
  (let ([sel-low (list (first sel) (second sel))]
        [s2      (third sel)])
    (define-values (low high) (dmux in s2))
    (define-values (a b c d) (dmux4way low sel-low))
    (define-values (e f g h) (dmux4way high sel-low))
    (values a b c d e f g h)))

(module+ test
  (require rackunit)

  (define (run sel) (define-values (a b c d e f g h) (dmux8way 1 sel))
                    (list a b c d e f g h))

  (check-equal? (run '(0 0 0)) '(1 0 0 0 0 0 0 0))
  (check-equal? (run '(1 0 0)) '(0 1 0 0 0 0 0 0))
  (check-equal? (run '(0 1 0)) '(0 0 1 0 0 0 0 0))
  (check-equal? (run '(1 1 0)) '(0 0 0 1 0 0 0 0))
  (check-equal? (run '(0 0 1)) '(0 0 0 0 1 0 0 0))
  (check-equal? (run '(1 0 1)) '(0 0 0 0 0 1 0 0))
  (check-equal? (run '(0 1 1)) '(0 0 0 0 0 0 1 0))
  (check-equal? (run '(1 1 1)) '(0 0 0 0 0 0 0 1)))
