(use file.util)

(define filename "/home/hiragi/gosh/work/words.txt")

(define text
  (file->string filename))

(define random-rows
  (lambda (n)
	(list-ref (string-split text "------------------------------------------------------------------------------") n)))

(define len (length (string-split text "------------------------------------------------------------------------------")))
(define (random x)
  (modulo (sys-random) x))

(define *seed* 1)

(define (srand x)
  (set! *seed* x))

(define (irand)
  (set! *seed* (modulo (+ (* (modulo (sys-time) 69069) *seed*) 1) #x10000000))
  *seed*)

(define (make-number n)
  (+ (modulo (quotient (irand) #x10000) n) 1))

(define (execution n)
  (if (<= n 0)
	  "END"
	  (begin
		(print (random-rows (make-number (- len 2))))
		(execution (- n 1)))))

(execution 20)
