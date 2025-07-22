#lang racket

(require "./full-adder.rkt")

(provide adder16)

(define (adder16 a b)
  (define (loop a-list b-list cin acc)
    (if (null? a-list)
        (reverse acc)
        (let* ([fa (full-adder (car a-list) (car b-list) cin)]
               [sum (first fa)]
               [cout (second fa)])
          (loop (cdr a-list) (cdr b-list) cout (cons sum acc)))))
  (loop a b 0 '()))

(module+ test
  (require rackunit)

  ;; 3 + 2 = 5 -> 0000 0000 0000 0011 + 0000 0000 0000 0010 = 0000 0000 0000 0101
  (define a '(1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0)) ; 3
  (define b '(0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0)) ; 2

  (check-equal? (adder16 a b)
                '(1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0))) ; 5
