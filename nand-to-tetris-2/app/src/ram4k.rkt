#lang racket

(require "ram512.rkt"
         "dmux8way.rkt"
         "mux8way16.rkt")
(provide make-ram4k)

; RAM4K: 8 RAM512s, 12-bit address
; low 9 bits → inner address within RAM512
; high 3 bits → which RAM512
(define (make-ram4k)
  (let ([rams (build-list 8 (lambda (_) (make-ram512)))])
    (lambda (in address load)
      (define inner (take address 9))
      (define outer (drop address 9))
      (define-values (l0 l1 l2 l3 l4 l5 l6 l7) (dmux8way load outer))
      (define outs (map (lambda (ram l) (ram in inner l)) rams (list l0 l1 l2 l3 l4 l5 l6 l7)))
      (apply mux8way16 (append outs (list outer))))))

(module+ test
  (require rackunit)

  (define ram (make-ram4k))
  (define zero '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define val  '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0))

  (ram val (make-list 12 0) 1)
  (check-equal? (ram zero (make-list 12 0) 0) val)
  (check-equal? (ram zero (make-list 12 1) 0) zero)
  (ram val (make-list 12 1) 1)
  (check-equal? (ram zero (make-list 12 1) 0) val))
