#lang racket

(require rackunit)

(require ansi/format)

(define-syntax-rule (check-ansi actual expected)
  (check-equal? (with-output-to-string
                  (lambda () actual))
                (with-output-to-string
                  (lambda () expected))))

(check-ansi (display-ansi green "hello" foreground-default)
            (display-ansi (green "hello")))

(check-ansi (display-ansi bold "hello" normal-intensity " world")
            (display-ansi (bold "hello") " world"))

(check-equal? (~ansi (strikethrough "foo"))
              (~ansi (crossed-out "foo")))

(check-equal? (~ansi (inverse "foo"))
              (~ansi (negative-image "foo")))
