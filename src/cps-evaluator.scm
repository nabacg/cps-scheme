#lang racket


(define (init-env)
  (lambda (x) #f))

(define (bind env sym val)
  (lambda (x)
    (if (eqv? x sym)
        val
        (env x))))

(define (repl)
  (lambda (expr)
    (eval expr (init-env) (lambda (v) v))))

(define (self-evaluating? exp)
  (cond
    ((number? exp) true)
    ((string? exp) true)
  (else false)))

(define (variable? exp)
  (symbol? exp))

(define (lookup-variable env exp cont)
  (cont (env exp)))

(define (application? exp)
  (pair? exp))

(define (eval env exp cont)
  (cond
    ((self-evaluating? exp) (cont exp))
    ((variable? exp) (lookup-variable env exp cont))
    ((application? exp) (lookup-variable env (car exp)
                                         (lambda (v)
                                           (apply v (cdr exp)))))))
                            