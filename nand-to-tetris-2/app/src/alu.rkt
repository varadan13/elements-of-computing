#lang racket

(require "mux16.rkt"
         "not16.rkt"
         "and16.rkt"
         "add16.rkt"
         "or8way.rkt"
         "or.rkt"
         "not.rkt")
(provide alu)

(define zero16 '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

; ALU pipeline:
;   x = mux16(x, 0,    zx)  → mux16(!x, x, nx)  (zero then maybe negate)
;   y = mux16(y, 0,    zy)  → mux16(!y, y, ny)
;   out = mux16(x&y, x+y, f)  → mux16(out, !out, no)
;   zr = NOT(OR(or8way(out[0..7]), or8way(out[8..15])))
;   ng = out[15]  (MSB — sign bit in 2's complement)
(define (alu x y zx nx zy ny f no)
  ; --- process x ---
  (define x1 (mux16 x zero16 zx))
  (define x2 (mux16 x1 (not16 x1) nx))

  ; --- process y ---
  (define y1 (mux16 y zero16 zy))
  (define y2 (mux16 y1 (not16 y1) ny))

  ; --- compute function ---
  (define fout (mux16 (and16 x2 y2) (add16 x2 y2) f))

  ; --- post-process output ---
  (define out (mux16 fout (not16 fout) no))

  ; --- zr: 1 iff all bits are 0 ---
  (define zr (not-gate (or-gate (or8way (take out 8))
                                (or8way (drop out 8)))))

  ; --- ng: sign bit (MSB = last element, index 15) ---
  (define ng (last out))

  (values out zr ng))

(module+ test
  (require rackunit)

  (define (run x y zx nx zy ny f no)
    (define-values (out zr ng) (alu x y zx nx zy ny f no))
    (list out zr ng))

  (define zero '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define one  '(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))  ; = 1
  (define neg1 '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))  ; = -1 in 2's complement

  ; 0  (zx=1 nx=0 zy=1 ny=0 f=1 no=0) → out=0, zr=1, ng=0
  (check-equal? (run zero zero 1 0 1 0 1 0) (list zero 1 0))

  ; 1  (zx=1 nx=1 zy=1 ny=1 f=1 no=1) → out=1, zr=0, ng=0
  (check-equal? (run zero zero 1 1 1 1 1 1) (list one 0 0))

  ; -1 (zx=1 nx=1 zy=1 ny=0 f=1 no=0) → out=-1, zr=0, ng=1
  (check-equal? (run zero zero 1 1 1 0 1 0) (list neg1 0 1))

  ; x  (zx=0 nx=0 zy=1 ny=1 f=0 no=0) → out=x
  (check-equal? (run one zero 0 0 1 1 0 0) (list one 0 0))

  ; x+y (zx=0 nx=0 zy=0 ny=0 f=1 no=0)
  (check-equal? (run one one 0 0 0 0 1 0) (list '(0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0) 0 0))

  ; x&y (zx=0 nx=0 zy=0 ny=0 f=0 no=0)
  (check-equal? (run neg1 one 0 0 0 0 0 0) (list one 0 0)))
