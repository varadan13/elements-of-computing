#lang racket

(define input
  (file->string "input.txt"))

(define moves
  (map (λ (c) (case c
                [(#\()  +1]
                [(#\))  -1]
                [else   (error "Invalid character in input" c)]))
       (string->list input)))

(define final-floor (apply + moves))

(define (find-basement-position moves)
  (let loop ([remaining moves]
             [pos 0]
             [floor 0])
    (cond
      [(empty? remaining) #f]
      [else
       (define new-floor (+ floor (first remaining)))
       (define new-pos (add1 pos))
       (if (= new-floor -1)
           new-pos
           (loop (rest remaining) new-pos new-floor))])))

(define basement-pos (find-basement-position moves))

(printf "Part 1 — Final floor: ~a~%" final-floor)
(printf "Part 2 — Position of first basement enter: ~a~%" basement-pos)
