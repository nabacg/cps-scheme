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

(define (if-exp? exp)
  (eqv? (car exp) 'if))

(define (if-exp env exp cont)
  (eval env (cadr exp)
        (lambda (b)
          (if b
              (eval env (caddr exp) cont)
              (eval env (cadddr exp) cont)))))

(define (application? exp)
  (pair? exp))

(define (apply-procedure env exp cont)
  (lookup-variable env (car exp)
                   (lambda (v)
                     (cont
                      (apply v
                            (map (lambda (op) (eval env op (lambda (x) x)))                                  (cdr exp)))))))
                        ;(cdr exp))))))

(define (eval env exp cont)
  (cond
    ((self-evaluating? exp) (cont exp))
    ((variable? exp) (lookup-variable env exp cont))
    ((if-exp? exp) (if-exp env exp cont))
    ((application? exp) (apply-procedure env exp cont))))


(eval (bind (init-env) '+ +) '(+ 12 132) (lambda (x) x))
(eval (bind (init-env) '= =) '(= 2 2) (lambda (x) x))
(eval (bind (init-env) '= =) '(if (= 2 2) "TRUE" "FALSE") (lambda (x) x))
(eval (bind (init-env) '= =) '(if (= 2 4) "TRUE" "FALSE") (lambda (x) x))
(eval (bind (bind (init-env) '= =) '+ +) '(if (= (+ 2 2) 5) "TRUE" "FALSEY") (lambda (x) x))