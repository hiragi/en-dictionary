(add-load-path "/c/scheme/site-lib")
(use rfc.http)
(use sxml.sxpath)
(use gauche.charconv)
(use srfi-13)
(use gauche.process)
(load "/home/hiragi/gosh/lib/htmlprag.scm")

(define search
  (lambda (word)
	(let* ((tohtml
		   (ces-convert 
			(values-ref (http-get "www.ldoceonline.com" (string-append "/dictionary/" word)) 2)
			"*JP"))
		  (html2shtml (html->shtml tohtml))
		  (meanings ((sxpath "//span[@class='DEF']/text()") html2shtml)))
	  meanings)))



(define plus-one
  (lambda (word)
	(string-append word "_1")))

(define lookup
  (lambda (word fileport)
	(let ((result (search (x->string word))))
	  (if (null? result)
		  (begin
			(set! result (search (plus-one (x->string word))))))
	  (if (not (null? result))
		  (begin
			(newline fileport)
			(newline fileport)
			(write word fileport)
			(newline fileport)
			(newline fileport)
			(map
			 (lambda (x)
			   (begin
				 (newline fileport)
				 (write x fileport)
				 (newline fileport)
				 (newline fileport)
				 (newline)
				 (display x)
				 (newline)
				 (newline)))
			 result)
			(write "------------------------------------------------------------------------------" fileport))
		  (begin
			(print)
			(print "Not Found"))))
	(close-output-port fileport)))

(define clear
  (let1 c (process-output->string '("clear"))
		(lambda ()
		  (display c))))

(while #t
	   (let ((word (read)))
		 (define out (open-output-file "/home/hiragi/gosh/work/words.txt" :if-exists :append))
		 (clear)
		 (newline)
		 (print "...")
		 (lookup word out)))
