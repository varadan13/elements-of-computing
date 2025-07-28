#lang racket

(require "../logic-gates/not-gate.rkt")
(require "../logic-gates/and-gate.rkt")
(require "../logic-gates/or-gate.rkt")
(require "../logic-gates/xor-gate.rkt")
(require "../logic-gates/not16.rkt")
(require "../logic-gates/and16.rkt")
(require "../logic-gates/or16.rkt")
(require "../logic-gates/mux16.rkt")
(require "./adder16.rkt")

(provide alu)

(define (map-binary op a b)
  (map op a b))

(define (is-zero16? bits)
  (if (ormap (λ (bit) (= bit 1)) bits) 0 1))

(define (is-negative16? bits)
  ;; MSB = most significant bit, which is last in LSB-first list
  (if (= (last bits) 1) 1 0))

(define (alu x y zx nx zy ny f no)
  (define x1 (if (= zx 1) (make-list 16 0) x))
  (define x2 (if (= nx 1) (not16 x1) x1))

  (define y1 (if (= zy 1) (make-list 16 0) y))
  (define y2 (if (= ny 1) (not16 y1) y1))

  (define out0 (if (= f 1) (adder16 x2 y2) (and16 x2 y2)))

  (define out (if (= no 1) (not16 out0) out0))

  (define zr (is-zero16? out))
  (define ng (is-negative16? out))

  (list out zr ng))

(module+ test
  (require rackunit)

  ;; Test: 0 + 0 = 0
  (define x (make-list 16 0))
  (define y (make-list 16 0))

  ;; zx=1, nx=0, zy=1, ny=0, f=1 (add), no=0 → out = 0 + 0
  (define result (alu x y 1 0 1 0 1 0))

  ;; Out, ZR, NG
  (check-equal? (second result) 1) ;; zero
  (check-equal? (third result) 0)) ;; not negative
