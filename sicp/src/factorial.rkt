#lang racket

(define linear-recursive-factorial 
  (lambda (n) 
    (cond 
      [(= n 1) 1] 
      [else (* n (linear-recursive-factorial (- n 1)))])))

(define iter 
  (lambda (product counter max-count) 
    (cond 
      [(> counter max-count) product] 
      [else (iter (* product counter) (+ counter 1) max-count)])))

(define linear-iterative-factorial 
  (lambda (n) (iter 1 1 n)))

(module+ test
  (require rackunit)

  (check-equal? (linear-recursive-factorial 10) 3628800)
  (check-equal? (linear-recursive-factorial 11) 39916800)
  (check-equal? (linear-recursive-factorial 10) (linear-iterative-factorial 10))
  (check-equal? (linear-recursive-factorial 11) (linear-iterative-factorial 11)))