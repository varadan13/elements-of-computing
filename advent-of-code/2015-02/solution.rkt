#lang racket

(require racket/string)

(define input
  (file->lines "input.txt"))

(define (calculate-dimensions lst)
  (match lst
    [(list a b c)
     (let* ([ab (* a b)]
            [bc (* b c)]
            [ac (* a c)])
       (+ (* 2 ab) (* 2 bc) (* 2 ac) (apply min (list ab bc ac))))]
    [else 0]))

(define (calculate-dimensions-2 lst)
  (match lst
    [(list a b c)
     (let* ([A (apply + (take (sort lst <) 2))] 
            [B (* a b c)])
       (+ (* 2 A) B))]
    [else 0]))

(define process-list-item 
  (lambda (list-item) 
    (map (λ (c)  (string->number c))
      (string-split list-item "x"))))

(define processed-1 
  (map 
    (lambda (c) (calculate-dimensions (process-list-item c))) input))

(define final-solution (apply + processed-1))

(printf "Part 1 solution: ~a~%" final-solution)

(define processed-2 
  (map 
    (lambda (c) (calculate-dimensions-2 (process-list-item c))) input))

(define final-solution-2 (apply + processed-2))

(printf "Part 2 solution: ~a~%" final-solution-2)




