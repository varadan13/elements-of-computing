#lang racket

(provide make-clock)

(define (make-clock)                   
  (let ([state 0])                    
    (lambda ()                        
      (set! state (if (= state 0) 1 0))
      state)))          

(module+ test
  (require rackunit)

  (define test-clock (make-clock))
  
  (check-equal? (test-clock) 1)
  (check-equal? (test-clock) 0)
  (check-equal? (test-clock) 1)
  (check-equal? (test-clock) 0))