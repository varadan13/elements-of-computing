#lang racket

(require "ram4k.rkt"
         "dmux4way.rkt"
         "mux4way16.rkt")
(provide make-ram16k)

; RAM16K: 4 RAM4Ks, 14-bit address
; low 12 bits → inner address within RAM4K
; high 2 bits → which RAM4K (4-way, not 8-way)
(define (make-ram16k)
  (let ([rams (build-list 4 (lambda (_) (make-ram4k)))])
    (lambda (in address load)
      (define inner (take address 12))
      (define outer (drop address 12))
      (define-values (l0 l1 l2 l3) (dmux4way load outer))
      (define outs (map (lambda (ram l) (ram in inner l)) rams (list l0 l1 l2 l3)))
      (apply mux4way16 (append outs (list outer))))))

(module+ test
  (require rackunit)

  (define ram (make-ram16k))
  (define zero '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
  (define val  '(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0))

  (ram val (make-list 14 0) 1)
  (check-equal? (ram zero (make-list 14 0) 0) val)
  (check-equal? (ram zero (make-list 14 1) 0) zero)
  (ram val (make-list 14 1) 1)
  (check-equal? (ram zero (make-list 14 1) 0) val))
