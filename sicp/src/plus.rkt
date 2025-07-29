#lang racket

(define inc (lambda (n) (+ n 1)))

(define dec (lambda (n) (- n 1)))

(define recursive-plus 
  (lambda (a b) 
    (cond 
      [(= a 0) b] 
      [else (inc (recursive-plus (dec a) b))])))

(define iterative-plus 
  (lambda (a b) 
    (cond 
      [(= a 0) b] 
      [else (iterative-plus (dec a) (inc b))])))

(module+ test
  (require rackunit)

  (check-equal? (inc 10) 11)
  (check-equal? (dec 11) 10)
  (check-equal? (recursive-plus 10 11) 21)
  (check-equal? (recursive-plus 10 11) (iterative-plus 10 11)))
