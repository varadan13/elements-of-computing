#lang racket

(require "alu.rkt"
         "mux16.rkt"
         "and.rkt"
         "or.rkt"
         "not.rkt"
         "inc16.rkt")
(provide make-cpu)

(define zero16 '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

; CPU pipeline per tick:
;   1. snapshot A, D, PC state
;   2. decode instruction bits
;   3. ALU: x=D, y=mux16(A, inM, a-bit)
;   4. jump = c-inst AND (j1∧ng OR j2∧zr OR j3∧pos)
;   5. update A ← instruction or ALU out
;   6. update D ← ALU out (if C-inst and d2)
;   7. update PC ← 0 (reset) | A (jump) | PC+1 (inc)
;   outputs: outM, writeM, addressM[15], pc[15]
;
; Instruction bit layout (LSB-first, index = bit position):
;   [15]=c-inst  [14][13]=unused  [12]=a
;   [11]=zx [10]=nx [9]=zy [8]=ny [7]=f [6]=no
;   [5]=d1(A)  [4]=d2(D)  [3]=d3(M)
;   [2]=j1(ng) [1]=j2(zr) [0]=j3(pos)

(define (make-cpu)
  (let ([A  (box zero16)]
        [D  (box zero16)]
        [PC (box zero16)])
    (lambda (inM instruction reset)
      ; --- snapshot ---
      (define a-val  (unbox A))
      (define d-val  (unbox D))
      (define pc-val (unbox PC))

      ; --- decode ---
      (define c-inst (list-ref instruction 15))
      (define a-bit  (list-ref instruction 12))
      (define zx     (list-ref instruction 11))
      (define nx     (list-ref instruction 10))
      (define zy     (list-ref instruction 9))
      (define ny     (list-ref instruction 8))
      (define f-bit  (list-ref instruction 7))
      (define no     (list-ref instruction 6))
      (define d1     (list-ref instruction 5))
      (define d2     (list-ref instruction 4))
      (define d3     (list-ref instruction 3))
      (define j1     (list-ref instruction 2))
      (define j2     (list-ref instruction 1))
      (define j3     (list-ref instruction 0))

      ; --- ALU ---
      (define-values (alu-out zr ng)
        (alu d-val (mux16 a-val inM a-bit) zx nx zy ny f-bit no))

      ; --- jump logic ---
      (define pos  (and-gate (not-gate ng) (not-gate zr)))
      (define jump (and-gate c-inst
                    (or-gate (and-gate j1 ng)
                    (or-gate (and-gate j2 zr)
                             (and-gate j3 pos)))))

      ; --- update A: A-inst → load instruction value
      ;               C-inst with d1=1 → load ALU out ---
      (define load-A (or-gate (not-gate c-inst) (and-gate c-inst d1)))
      (set-box! A (mux16 a-val (mux16 instruction alu-out c-inst) load-A))

      ; --- update D: C-inst with d2=1 → load ALU out ---
      (set-box! D (mux16 d-val alu-out (and-gate c-inst d2)))

      ; --- update PC ---
      (define next-pc
        (cond [(= reset 1) zero16]
              [(= jump  1) a-val]
              [else        (inc16 pc-val)]))
      (set-box! PC next-pc)

      ; --- outputs ---
      (values alu-out                   ; outM[16]
              (and-gate c-inst d3)      ; writeM
              (take a-val 15)           ; addressM[15]
              (take next-pc 15)))))     ; pc[15]

(module+ test
  (require rackunit)

  ; helpers
  ; A-instruction: value as 16-bit LSB-first list (bit15 must be 0)
  (define (a-inst n)
    (map (lambda (i) (if (bitwise-bit-set? n i) 1 0)) (range 16)))

  ; C-instruction builder
  (define (c-inst a zx nx zy ny f no d1 d2 d3 j1 j2 j3)
    (list j3 j2 j1 d3 d2 d1 no f ny zy nx zx a 1 1 1))

  (define (run-cpu cpu inM inst reset)
    (define-values (outM writeM addrM pc) (cpu inM inst reset))
    (list outM writeM addrM pc))

  (define cpu (make-cpu))
  (define zero zero16)
  (define noop (c-inst 0 1 0 1 0 1 0 0 0 0 0 0 0))  ; comp=0, no dest, no jump

  ; reset → pc=0
  (run-cpu cpu zero noop 1)
  (check-equal? (fourth (run-cpu cpu zero noop 0))
                '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

  ; @5 → A=5, PC increments to 1
  (define cpu2 (make-cpu))
  (run-cpu cpu2 zero (a-inst 5) 0)
  ; A is now 5, next pc = 1
  ; D=A: a=0 zx=1 nx=1 zy=0 ny=0 f=0 no=0 d2=1
  (run-cpu cpu2 zero (c-inst 0 1 1 0 0 0 0 0 1 0 0 0 0) 0)
  ; D should now be 5; compute D (zx=0 nx=0 zy=1 ny=1 f=0 no=0) → store outM
  (define-values (outM2 wM2 addrM2 pc2)
    (cpu2 zero (c-inst 0 0 0 1 1 0 0 0 0 1 0 0 0) 0))
  (check-equal? outM2 (a-inst 5)))  ; outM = D = 5
