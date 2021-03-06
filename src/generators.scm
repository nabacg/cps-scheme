#lang scheme

; current-continuation : -> continuation
(define (current-continuation)
  (call-with-current-continuation
   (lambda (cc) cc)))

; void : -> void
(define (void)
 'Done)

; tree-iterator : tree -> generator
(define (tree-iterator tree)
  (lambda (yield)

    ;; Walk the tree, yielding the leaves.

    (define (walk tree)
      (if (not (pair? tree))
          (yield tree)
          (begin
            (walk (car tree))
            (walk (cdr tree)))))

    (walk tree)))

; make-yield : continuation -> (value -> ...)
(define (make-yield for-cc)
  (lambda (value)
    ;when tree-iterator yields a value
    (let ((cc (current-continuation))) ; capture generator CC
      (if (procedure? cc)
          (for-cc (cons cc value)) ; pass yielded value and this CC to for loop-CC
          (void)))))

; (for v in generator body) will execute body
; with v bound to successive values supplied
; by generator.
(define-syntax for
  (syntax-rules (in) ;; scheme pattern matching macros http://www.willdonnelly.net/blog/scheme-syntax-rules/
    ((_ v in iterator body ...)
     ; =>
     (let ((iterator-cont #f))
       (letrec ((loop (lambda ()
                        (let ((cc (current-continuation))) ;;capture CC
                          (if (procedure? cc)
                              (if iterator-cont
                                  (iterator-cont (void))
                                  (iterator (make-yield cc))) ; pass for CC as yeld to tree-iterator
                              (let ((it-cont (car cc)) ; get iterator-cc
                                    (it-val  (cdr cc))); get yielded value
                                (set! iterator-cont it-cont)
                                (let ((v it-val))
                                  body ...)
                                (loop)))))))
         (loop))))))


; Prints:
; 3
; 4
; 5
; 6
(for v in (tree-iterator '(3 . ( ( 4 . 5 ) . 6 ) ))
  (display v)
  (newline))
