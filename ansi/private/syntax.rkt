#lang racket

(provide define-modifier
         define-color-definer)

(require (for-syntax racket/syntax syntax/parse))

(define-syntax (define-modifier stx)
  (syntax-parse stx
    [(_ id:id
        code:integer
        (~optional (~seq #:cancel canceler))
        (~optional (~seq #:alias alias)))
     (define/with-syntax escape-sequence (format "\e[~am" (syntax-e #'code)))
     (define/with-syntax id-proc (format-id #'here "~a" #'id))
     #'(begin
         (define id-proc
           (case-lambda
             (() escape-sequence)
             ((s)
              (string-append escape-sequence s (~? canceler)))))

         (define-for-syntax stx-transformer
           (lambda (stx)
             (syntax-case stx ()
               [(id v (... ...))
                #'(id-proc v (... ...))]
               [id
                #'escape-sequence])))

         (define-syntax id stx-transformer)
         (~? (define-syntax alias stx-transformer)))]))

(define-syntax (define-foreground stx)
  (syntax-parse stx
    [(_ id:id code:integer foreground-default)
     (define/with-syntax foreground-id (format-id #'id "foreground-~a" #'id))
     #'(define-modifier foreground-id code #:cancel foreground-default #:alias id)]))

(define-syntax (define-background stx)
  (syntax-parse stx
    [(_ id:id code:integer background-default)
     (define/with-syntax background-id (format-id #'id "background-~a" #'id))
     #'(define-modifier background-id code #:cancel background-default)]))

(define-for-syntax (define-color stx)
  (syntax-parse stx
    [(_ id:id code:integer)
     (define/with-syntax normal-foreground (+ 30 (syntax-e #'code)))
     (define/with-syntax bright-foreground (+ 90 (syntax-e #'code)))
     (define/with-syntax normal-background (+ 40 (syntax-e #'code)))
     (define/with-syntax bright-background (+ 100 (syntax-e #'code)))

     (define/with-syntax bright-id (format-id #'id "bright-~a" #'id))

     (define/with-syntax foreground-default (format-id #'id "foreground-default"))
     (define/with-syntax background-default (format-id #'id "background-default"))

     #'(begin
         (define-foreground id normal-foreground foreground-default)
         (define-foreground bright-id bright-foreground foreground-default)
         (define-background id normal-background background-default)
         (define-background bright-id bright-background background-default))]))

(define-syntax (define-color-definer stx)
  (syntax-parse stx
    [(_ definer:id foreground-default-code:integer background-default-code:integer)
     (define/with-syntax foreground-default (format-id #'definer "foreground-default"))
     (define/with-syntax background-default (format-id #'definer "background-default"))
     #'(begin
         (define-modifier foreground-default foreground-default-code)
         (define-modifier background-default background-default-code)

         (define-syntax (definer stx)
           (define-color stx)))]))
