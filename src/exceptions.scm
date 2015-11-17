#lang scheme
; current-continuation : -> continuationxx
(define (current-continuation)
  (call-with-current-continuation
   (lambda (cc)
     (cc cc))))

; exception-stack : list[continuation]
(define exception-stack '())

; (try exp ... catch catch-procedure) runs
; exp ..., and invokes catch-procedure with
; the value passed to throw.
(define-syntax try 
  (syntax-rules (catch)  ;macro http://www.willdonnelly.net/blog/scheme-syntax-rules/
    ((_ exp ... catch proc) 
     ; =>
     (let ((cc (current-continuation)))
       (cond
         ((procedure? cc)
          ;dynamic-wind before-thunk do-work-thunk after-thunk
          (dynamic-wind 
           (lambda ()
             (set! exception-stack (cons cc exception-stack))) ;put cc on exception-stack
           (lambda ()
             exp ...) ;do work
           (lambda ()
             (set! exception-stack (cdr exception-stack))))) ;if do-work finished pop current cc from exception-stack
         
         ((pair? cc) ;if cc is a value (pair) passed to cc from throw => exectute handler proc
          (proc (cadr cc)))))))) 

(define (throw exception-value)
  (let ((handler (car exception-stack)))
    (handler (list 'exception exception-value))))



; Example:
(try (try (throw 'foo)
          catch
          (lambda (exn)
            (display "got inner exception: ")
            (display exn)
            (newline)
            (throw 'bar)))
     catch
     (lambda (exn)
       (display "got outer exception: ")
       (display exn)
       (newline)))
                        
