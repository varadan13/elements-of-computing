#lang racket

(require "mux16.rkt"
         "inc16.rkt")
(provide make-pc)

(define zero16 '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

; PC: cascaded mux selects next value by priority: reset > load > inc > hold
;   after-inc   = mux16(out, out+1,  inc)
;   after-load  = mux16(after-inc, in, load)
;   after-reset = mux16(after-load, 0, reset)
(define (make-pc)
  (let ([state (box zero16)])
    (lambda (in inc load reset)
      (define out (unbox state))
      (define after-inc   (mux16 out (inc16 out) inc))
      (define after-load  (mux16 after-inc in load))
      (define after-reset (mux16 after-load zero16 reset))
      (set-box! state after-reset)
      out)))

(module+ test
  (require rackunit)

  (define pc (make-pc))
  (define zero zero16)
  (define one  '(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define two  '(0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define val  '(1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0))

  ; initial out = 0
  (check-equal? (pc zero 0 0 0) zero)

  ; inc → out increments each tick
  (check-equal? (pc zero 1 0 0) zero)  ; out=0, next=1
  (check-equal? (pc zero 1 0 0) one)   ; out=1, next=2
  (check-equal? (pc zero 1 0 0) two)   ; out=2, next=3

  ; load overrides inc
  (check-equal? (pc val 1 1 0) two)    ; out=2 this tick, latches val
  (check-equal? (pc zero 0 0 0) val)   ; out=val

  ; reset overrides all
  (check-equal? (pc val 1 1 1) val)    ; out=val this tick, resets
  (check-equal? (pc val 1 1 0) zero)   ; out=0 after reset

  ; hold (no flags)
  (check-equal? (pc val 1 1 1) val)    ; reset again
  (check-equal? (pc zero 0 0 0) zero)  ; hold 0
  (check-equal? (pc zero 0 0 0) zero))
