#lang racket

(require "add16.rkt")
(provide inc16)

(define one16 '(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

; Inc16: out = in + 1
(define (inc16 in)
  (add16 in one16))

(module+ test
  (require rackunit)

  ; 0 + 1 = 1
  (check-equal? (inc16 '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
                       '(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

  ; 1 + 1 = 2
  (check-equal? (inc16 '(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
                       '(0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

  ; all ones + 1 = 0 (overflow discarded)
  (check-equal? (inc16 '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))
                       '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
