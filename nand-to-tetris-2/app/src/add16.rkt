#lang racket

(require "half-adder.rkt"
         "full-adder.rkt")
(provide add16)

; Add16: half-adder on bit 0, full-adder on bits 1..15 with carry chain
; overflow is discarded
(define (add16 a b)
  (define-values (sum0 carry0) (half-adder (first a) (first b)))
  (define-values (rest-sums _)
    (for/fold ([sums '()] [carry carry0])
              ([ai (rest a)] [bi (rest b)])
      (define-values (s c) (full-adder ai bi carry))
      (values (cons s sums) c)))
  (cons sum0 (reverse rest-sums)))

(module+ test
  (require rackunit)

  ; 0 + 0 = 0
  (check-equal? (add16 '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                       '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
                       '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

  ; 1 + 1 = 2  → bit1 set: (0 1 0 0 ...)
  (check-equal? (add16 '(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                       '(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
                       '(0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

  ; all ones + 1 = 0 (overflow discarded)
  (check-equal? (add16 '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
                       '(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
                       '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
