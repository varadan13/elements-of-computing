#lang racket

(provide newton-method-sqrt)
(provide packed-newton-method-sqrt)

(define abs 
  (lambda (x) 
    (cond 
      ([> x 0] x) 
      ([= x 0] 0) 
      (else (- 0 x)))))

(define average 
  (lambda (x y) (/ (+ x y) 2)))

(define (square x) (* x x))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (improve guess x)
  (average guess (/ x guess)))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
    guess
    (sqrt-iter (improve guess x) x)))

(define (newton-method-sqrt x)
  (sqrt-iter 1.0 x))

(define (packed-newton-method-sqrt x)
  (letrec ([abs (lambda (x)
                  (cond [(> x 0) x]
                        [(= x 0) 0]
                        [else (- 0 x)]))]
           
           [average (lambda (x y)
                      (/ (+ x y) 2))]
           
           [square (lambda (x)
                     (* x x))]

           [good-enough? (lambda (guess)
                           (< (abs (- (square guess) x)) 0.001))]

           [improve (lambda (guess)
                      (average guess (/ x guess)))]

           [sqrt-iter (lambda (guess)
                        (if (good-enough? guess)
                            guess
                            (sqrt-iter (improve guess))))])

    (sqrt-iter 1.0)))


(module+ test
  (require rackunit)

  (check-equal? (abs 0) 0)
  (check-equal? (abs 2) 2)
  (check-equal? (abs -2) 2)
  
  (check-equal? (average 0 0) 0)
  (check-equal? (average 0 1) 1/2)
  (check-equal? (average 1 1) 1)
  
  (check-equal? (square 3) 9)
  (check-equal? (square 1) 1)
  
  ; (check-equal? (newton-method-sqrt 4) 2)
  (check-equal? (newton-method-sqrt 4) (packed-newton-method-sqrt 4)))