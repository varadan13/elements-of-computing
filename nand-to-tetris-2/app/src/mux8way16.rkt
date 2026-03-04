#lang racket

(require "mux4way16.rkt"
         "mux16.rkt")
(provide mux8way16)

; Mux8Way16 = mux16(mux4way16(a,b,c,d,sel[0..1]), mux4way16(e,f,g,h,sel[0..1]), sel[2])
; sel is a 3-element list: (list sel[0] sel[1] sel[2]), sel[0] is LSB
(define (mux8way16 a b c d e f g h sel)
  (let ([sel-low  (list (first sel) (second sel))]
        [s2       (third sel)])
    (mux16 (mux4way16 a b c d sel-low)
           (mux4way16 e f g h sel-low)
           s2)))

(module+ test
  (require rackunit)

  (define wa '(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define wb '(0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define wc '(0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define wd '(0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0))
  (define we '(0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0))
  (define wf '(0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0))
  (define wg '(0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0))
  (define wh '(0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0))

  (check-equal? (mux8way16 wa wb wc wd we wf wg wh '(0 0 0)) wa)
  (check-equal? (mux8way16 wa wb wc wd we wf wg wh '(1 0 0)) wb)
  (check-equal? (mux8way16 wa wb wc wd we wf wg wh '(0 1 0)) wc)
  (check-equal? (mux8way16 wa wb wc wd we wf wg wh '(1 1 0)) wd)
  (check-equal? (mux8way16 wa wb wc wd we wf wg wh '(0 0 1)) we)
  (check-equal? (mux8way16 wa wb wc wd we wf wg wh '(1 0 1)) wf)
  (check-equal? (mux8way16 wa wb wc wd we wf wg wh '(0 1 1)) wg)
  (check-equal? (mux8way16 wa wb wc wd we wf wg wh '(1 1 1)) wh))
