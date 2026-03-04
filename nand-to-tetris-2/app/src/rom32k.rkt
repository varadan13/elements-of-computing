#lang racket

(provide make-rom32k bits->int int->bits16)

(define zero16 '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
(define ROM-SIZE 32768)  ; 2^15

; convert LSB-first bit list to integer
(define (bits->int bits)
  (for/fold ([acc 0]) ([b bits] [i (in-naturals)])
    (+ acc (* b (expt 2 i)))))

; convert integer to 16-bit LSB-first list
(define (int->bits16 n)
  (map (lambda (i) (if (bitwise-bit-set? n i) 1 0)) (range 16)))

; ROM32K: preloaded read-only memory, 32K × 16-bit words
; returns (values read! load!) where:
;   (read! address[15]) → out[16]   — combinational read
;   (load! program)                 — load a list of 16-bit words
(define (make-rom32k)
  (let ([mem (make-vector ROM-SIZE zero16)])

    (define (load! program)
      (for ([word program] [i (in-naturals)])
        (vector-set! mem i word)))

    (define (read! address)
      (vector-ref mem (bits->int address)))

    (values read! load!)))

(module+ test
  (require rackunit)

  (define-values (rom load!) (make-rom32k))

  ; initially all zeros
  (check-equal? (rom '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)) zero16)

  ; load a small program
  (define prog (list (int->bits16 42)    ; address 0 → 42
                     (int->bits16 1337)  ; address 1 → 1337
                     (int->bits16 0)))   ; address 2 → 0
  (load! prog)

  (check-equal? (rom '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)) (int->bits16 42))
  (check-equal? (rom '(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0)) (int->bits16 1337))
  (check-equal? (rom '(0 1 0 0 0 0 0 0 0 0 0 0 0 0 0)) (int->bits16 0)))
