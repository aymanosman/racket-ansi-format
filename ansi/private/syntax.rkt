#lang racket

(provide define-modifier
         define-color-definer)

(require (for-syntax racket/syntax syntax/parse))

(define-syntax (define-modifier stx)
  (syntax-parse stx
    [(_ id:id
        code:integer
        (~optional (~seq #:cancel canceler)))
     (define/with-syntax escape-sequence (format "\e[~am" (syntax-e #'code)))
     (define/with-syntax id-proc (format-id #'here "~a" #'id))
     #'(begin
         (define id-proc
           (case-lambda
             (() escape-sequence)
             ((s)
              (string-append escape-sequence s (~? canceler)))))

         (define-syntax id
           (lambda (stx)
             (syntax-case stx ()
               [(id v (... ...))
                #'(id-proc v (... ...))]
               [id
                #'escape-sequence]))))]))


(define-syntax (define-color-definer stx)
  (syntax-parse stx
    [(_ definer:id foreground-default background-default)
     #'(begin
         (define-for-syntax (define-color stx)
           (syntax-parse stx
             [(_ id:id code:integer)
              (define/with-syntax normal-foreground (+ 30 (syntax-e #'code)))
              (define/with-syntax bright-foreground (+ 90 (syntax-e #'code)))
              (define/with-syntax normal-background (+ 40 (syntax-e #'code)))
              (define/with-syntax bright-background (+ 100 (syntax-e #'code)))

              (define/with-syntax bright (format-id #'id "bright-~a" #'id))
              (define/with-syntax foreground-color (format-id #'id "foreground-~a" #'id))
              (define/with-syntax foreground-bright-color (format-id #'id "foreground-bright-~a" #'id))
              (define/with-syntax background-color (format-id #'id "background-~a" #'id))
              (define/with-syntax background-bright-color (format-id #'id "background-bright-~a" #'id))

              #'(begin
                  (define-modifier foreground-color normal-foreground #:cancel foreground-default)
                  (define-syntax id (make-rename-transformer #'foreground-color))
                  (define-modifier foreground-bright-color bright-foreground #:cancel foreground-default)
                  (define-syntax bright (make-rename-transformer #'foreground-bright-color))
                  (define-modifier background-color normal-background #:cancel background-default)
                  (define-modifier background-bright-color bright-background #:cancel background-default))]))

         (define-syntax (definer stx)
           (define-color stx)))]))
