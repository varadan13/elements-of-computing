#lang racket

(require "or.rkt")
(provide or8way)

; Or8Way = OR(in[0], OR(in[1], ... OR(in[6], in[7])...))
(define (or8way in)
  (foldl or-gate 0 in))

(module+ test
  (require rackunit)

  (check-equal? (or8way '(0 0 0 0 0 0 0 0)) 0)
  (check-equal? (or8way '(1 1 1 1 1 1 1 1)) 1)
  (check-equal? (or8way '(0 0 0 0 0 0 0 1)) 1)
  (check-equal? (or8way '(1 0 0 0 0 0 0 0)) 1)
  (check-equal? (or8way '(0 0 1 0 0 0 1 0)) 1))
