#lang scheme

(define (f r)
   (r 2)
    42)


(lambda (v) v )

(f (lambda (x) x))

(call/cc f)

(let* ((c 10)
       (r (call/cc (lambda (x) x))))
  (display (format "Hello World ~s \n" c))
  (cond ((zero? c) 'done)
        (else (set! c (- c 1))
              (r r))))

(define (current-continuation)
  (call/cc (lambda (cc) cc)))

(quote 
 (let ((cc (current-continuation)))
   (cond
     ((procedure? cc) (display "cc body"))
     ((future-value? cc) (display "handing-body")
                         else (error "sth went wrong")))))


;right now
(define (right-now)
  (call/cc (lambda (cc) cc)))

;go-when
(define (go-when to)
  (to to))

(let* ((i 10)
      (cc (right-now)))
  (display (format "Now: ~s" i))
  (set! i (- i 1))
  (if (> i 0)
      (go-when cc)
      'done))
  

(let ([ x (call/cc (lambda (x) x))])
  (display "LET Binded x")
  (newline)
  (x (lambda (ignore) "hi")))

;sample mind bender cont
(((call/cc (lambda (x) x)) (lambda (x) x)) "Hello World")

(define (hello-cc w)
  (((call/cc (lambda (x) x)) (lambda (x) x)) w))

(((lambda (p)
  (p (lambda (x) x)))
  (lambda (x) x)) "Hello three")

((lambda (v)
   
   ((lambda (x) x) v)) "Hello World Too")



(define (fact-cps n k)
  (cond
    ((zero? n) (k 1))
    (else (fact-cps (sub1 n)
                    (lambda (v) (k (* v n)))))))

(define (fact n) (fact-cps n (lambda (x) x)))

(fact 5)



