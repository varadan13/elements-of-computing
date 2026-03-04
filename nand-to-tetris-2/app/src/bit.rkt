#lang racket

(require "mux.rkt")
(provide make-bit)

; Bit register: Mux(out, in, load) feeds into DFF
; If load(t-1)=1 → out(t)=in(t-1), else out(t)=out(t-1)
(define (make-bit)
  (let ([state (box 0)])
    (lambda (in load)
      (let ([out (unbox state)])
        (set-box! state (mux out in load))
        out))))

(module+ test
  (require rackunit)

  (define bit (make-bit))

  ; load=0 → holds initial 0
  (check-equal? (bit 1 0) 0)
  (check-equal? (bit 1 0) 0)

  ; load=1 → latches in=1 on next tick
  (check-equal? (bit 1 1) 0)  ; out still 0 this tick
  (check-equal? (bit 0 0) 1)  ; now out=1 (latched)

  ; load=0 → holds 1
  (check-equal? (bit 0 0) 1)

  ; load=1 → latches in=0
  (check-equal? (bit 0 1) 1)  ; out still 1 this tick
  (check-equal? (bit 1 0) 0)) ; now out=0 (latched)
