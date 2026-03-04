#lang racket

(require "rom32k.rkt")  ; int->bits16
(provide make-keyboard)

; Keyboard: outputs the 16-bit ASCII code of the currently pressed key.
; Returns (values read! press!) where:
;   (read!)       → out[16]  — current key code (0 if no key pressed)
;   (press! code) → void     — simulate a key press (code = integer or 0 to release)
(define (make-keyboard)
  (let ([state (box (int->bits16 0))])

    (define (read!)
      (unbox state))

    (define (press! code)
      (set-box! state (int->bits16 code)))

    (values read! press!)))

(module+ test
  (require rackunit)

  (define-values (kbd press!) (make-keyboard))

  ; no key pressed → 0
  (check-equal? (kbd) (int->bits16 0))

  ; press 'A' (ASCII 65)
  (press! 65)
  (check-equal? (kbd) (int->bits16 65))

  ; press Space (ASCII 32)
  (press! 32)
  (check-equal? (kbd) (int->bits16 32))

  ; release key
  (press! 0)
  (check-equal? (kbd) (int->bits16 0)))
