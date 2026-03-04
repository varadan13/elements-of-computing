#lang racket

(require "ram64.rkt"
         "dmux8way.rkt"
         "mux8way16.rkt")
(provide make-ram512)

; RAM512: 8 RAM64s, 9-bit address
; low 6 bits → inner address within RAM64
; high 3 bits → which RAM64
(define (make-ram512)
  (let ([rams (build-list 8 (lambda (_) (make-ram64)))])
    (lambda (in address load)
      (define inner (take address 6))
      (define outer (drop address 6))
      (define-values (l0 l1 l2 l3 l4 l5 l6 l7) (dmux8way load outer))
      (define outs (map (lambda (ram l) (ram in inner l)) rams (list l0 l1 l2 l3 l4 l5 l6 l7)))
      (apply mux8way16 (append outs (list outer))))))

(module+ test
  (require rackunit)

  (define ram (make-ram512))
  (define zero '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define val  '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0))

  (ram val '(0 0 0 0 0 0 0 0 0) 1)
  (check-equal? (ram zero '(0 0 0 0 0 0 0 0 0) 0) val)
  (check-equal? (ram zero '(1 1 1 1 1 1 1 1 1) 0) zero)
  (ram val '(1 1 1 1 1 1 1 1 1) 1)
  (check-equal? (ram zero '(1 1 1 1 1 1 1 1 1) 0) val))
