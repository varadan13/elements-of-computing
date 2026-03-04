#lang racket

(require "register.rkt"
         "dmux8way.rkt"
         "mux8way16.rkt")
(provide make-ram8)

; RAM8: 8 registers, 3-bit address
; DMux8Way routes load to addressed register; Mux8Way16 selects output
(define (make-ram8)
  (let ([regs (build-list 8 (lambda (_) (make-register)))])
    (lambda (in address load)
      (define-values (l0 l1 l2 l3 l4 l5 l6 l7) (dmux8way load address))
      (define outs (map (lambda (reg l) (reg in l)) regs (list l0 l1 l2 l3 l4 l5 l6 l7)))
      (apply mux8way16 (append outs (list address))))))

(module+ test
  (require rackunit)

  (define ram (make-ram8))
  (define zero '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define val  '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0))

  ; write val to address 0 (000)
  (ram val '(0 0 0) 1)
  (check-equal? (ram zero '(0 0 0) 0) val)

  ; address 1 (001) still zero
  (check-equal? (ram zero '(1 0 0) 0) zero)

  ; write val to address 7 (111)
  (ram val '(1 1 1) 1)
  (check-equal? (ram zero '(1 1 1) 0) val)

  ; address 0 unchanged
  (check-equal? (ram zero '(0 0 0) 0) val))
