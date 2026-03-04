#lang racket

(require "rom32k.rkt")  ; bits->int, int->bits16
(provide make-screen screen-pixel)

(define zero16  '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
(define ROWS    256)
(define COLS    512)
(define WORDS   8192)  ; 256 rows × 32 words/row = 8192 = 2^13

; Screen: 8K × 16-bit RAM with pixel-mapped side effect
; (screen in address[13] load) → out[16]
(define (make-screen)
  (let ([mem (make-vector WORDS zero16)])

    (define (screen in address load)
      (define idx (bits->int address))
      (when (= load 1)
        (vector-set! mem idx in))
      (vector-ref mem idx))

    screen))

; Read a single pixel at (row r, col c)
; Pixel at r,c → word at r*32 + c/16, bit c%16 (LSB = leftmost in group)
(define (screen-pixel mem-fn r c)
  (define word-addr (+ (* r 32) (quotient c 16)))
  (define bit-pos   (remainder c 16))
  (define word (mem-fn zero16
                        (map (lambda (i) (if (bitwise-bit-set? word-addr i) 1 0))
                             (range 13))
                        0))
  (list-ref word bit-pos))

(module+ test
  (require rackunit)

  (define screen (make-screen))

  ; initially all pixels off (0)
  (check-equal? (screen zero16 '(0 0 0 0 0 0 0 0 0 0 0 0 0) 0) zero16)

  ; write 0xFFFF (all 1s) to address 0 — turns on first 16 pixels of row 0
  (screen '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
          '(0 0 0 0 0 0 0 0 0 0 0 0 0) 1)
  (check-equal? (screen zero16 '(0 0 0 0 0 0 0 0 0 0 0 0 0) 0)
                '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))

  ; pixel (0,0) should be on
  (check-equal? (screen-pixel screen 0 0) 1)
  ; pixel (0,15) should be on
  (check-equal? (screen-pixel screen 0 15) 1)
  ; pixel (0,16) should be off (next word, not written)
  (check-equal? (screen-pixel screen 0 16) 0)
  ; pixel (1,0) should be off (different row)
  (check-equal? (screen-pixel screen 1 0) 0))
