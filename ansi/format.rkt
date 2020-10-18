#lang racket

(provide ~ansi
         display-ansi)

(require racket/require)

(require (for-syntax syntax/parse racket/syntax)
         (filtered-in
          (lambda (name)
            (regexp-replace #rx"^ansi-" name ""))
          "escapes.rkt"))

(define-syntax-rule (display-ansi e* ...)
  (begin
    (display (compile-ansi e*)) ...))

(define-syntax-rule (~ansi e* ...)
  (string-append (compile-ansi e*) ...))

(define-for-syntax (resolve-ansi-id id)
  (define/with-syntax ansi-id (format-id #'here "~a" id))
  (cond
    [(identifier-binding #'ansi-id)
     #'ansi-id]
    [else
     id]))

(define-syntax (compile-ansi stx)
  (syntax-parse stx
    [(_ v:str)
     #'v]
    [(_ (id:id e ...))
     (define/with-syntax ansi-id (resolve-ansi-id #'id))
     #'(ansi-id (compile-ansi e) ...)]
    [(_ id:id)
     (define/with-syntax ansi-id (resolve-ansi-id #'id))
     #'ansi-id]
    [(_ e)
     #'e]))
