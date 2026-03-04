#lang racket

(provide make-dff)

; DFF (Data Flip-Flop) — primitive sequential gate
; out(t) = in(t-1)
; Simulated with a mutable box inside a closure.
; Each call represents one clock tick: returns stored value, then updates it.
(define (make-dff)
  (let ([state (box 0)])
    (lambda (in)
      (let ([out (unbox state)])
        (set-box! state in)
        out))))

(module+ test
  (require rackunit)

  (define dff (make-dff))

  (check-equal? (dff 1) 0)  ; initial state is 0
  (check-equal? (dff 1) 1)
  (check-equal? (dff 0) 1)
  (check-equal? (dff 0) 0))
