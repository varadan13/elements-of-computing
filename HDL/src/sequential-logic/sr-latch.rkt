#lang racket

(provide make-sr-latch)

(define (make-sr-latch)
  (let ([q 0] [q-prime 1])
    (lambda (reset set)
      (match (list reset set)
        [(list 0 1)
         (set! q 1)
         (set! q-prime 0)
         (list q q-prime)]
        [(list 1 0)
         (set! q 0)
         (set! q-prime 1)
         (list q q-prime)]
        [(list 0 0)
         (list q q-prime)]
        [(list 1 1)
         (error 'sr-latch "Invalid input: both reset and set cannot be 1 at the same time")]))))

(module+ test
  (require rackunit)

  (define sr-latch (make-sr-latch))

  (check-equal? (sr-latch 0 1) '(1 0))
  (check-equal? (sr-latch 0 0) '(1 0))
  (check-equal? (sr-latch 0 0) '(1 0))
  (check-equal? (sr-latch 0 0) '(1 0))
  (check-equal? (sr-latch 1 0) '(0 1))
  (check-equal? (sr-latch 0 0) '(0 1))
  (check-equal? (sr-latch 0 0) '(0 1))
  (check-equal? (sr-latch 0 0) '(0 1))
  
  (check-exn exn:fail? (lambda () (sr-latch 1 1))))