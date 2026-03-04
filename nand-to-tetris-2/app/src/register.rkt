#lang racket

(require "bit.rkt")
(provide make-register)

; Register: 16 Bit cells in parallel, shared load signal
(define (make-register)
  (let ([bits (build-list 16 (lambda (_) (make-bit)))])
    (lambda (in load)
      (map (lambda (bit-fn i) (bit-fn i load)) bits in))))

(module+ test
  (require rackunit)

  (define reg (make-register))

  (define zero '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define val  '(1 0 1 1 0 0 1 0 1 1 0 1 0 1 0 1))

  ; load=0 → holds 0
  (check-equal? (reg val 0) zero)
  (check-equal? (reg val 0) zero)

  ; load=1 → latches val on next tick
  (check-equal? (reg val 1) zero)
  (check-equal? (reg zero 0) val)

  ; load=0 → holds val
  (check-equal? (reg zero 0) val)

  ; load=1 → latches zero
  (check-equal? (reg zero 1) val)
  (check-equal? (reg val 0) zero))
