#lang racket

(require "ram8.rkt"
         "dmux8way.rkt"
         "mux8way16.rkt")
(provide make-ram64)

; RAM64: 8 RAM8s, 6-bit address
; low 3 bits → inner address within RAM8
; high 3 bits → which RAM8
(define (make-ram64)
  (let ([rams (build-list 8 (lambda (_) (make-ram8)))])
    (lambda (in address load)
      (define inner (take address 3))
      (define outer (drop address 3))
      (define-values (l0 l1 l2 l3 l4 l5 l6 l7) (dmux8way load outer))
      (define outs (map (lambda (ram l) (ram in inner l)) rams (list l0 l1 l2 l3 l4 l5 l6 l7)))
      (apply mux8way16 (append outs (list outer))))))

(module+ test
  (require rackunit)

  (define ram (make-ram64))
  (define zero '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define val  '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0))

  ; write to address 0 (000 000)
  (ram val '(0 0 0 0 0 0) 1)
  (check-equal? (ram zero '(0 0 0 0 0 0) 0) val)

  ; address 63 (111 111) still zero
  (check-equal? (ram zero '(1 1 1 1 1 1) 0) zero)

  ; write to address 63
  (ram val '(1 1 1 1 1 1) 1)
  (check-equal? (ram zero '(1 1 1 1 1 1) 0) val))
