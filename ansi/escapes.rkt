#lang racket

(provide (prefix-out ansi- (all-defined-out)))

(require "private/syntax.rkt")

;; MODIFIERS

(define-modifier reset 0)
(define-modifier bold 1 #:cancel normal-intensity)
(define-modifier dim 2 #:cancel normal-intensity)
(define-modifier normal-intensity 22)
(define-modifier italic 3 #:cancel not-italicized)
(define-modifier not-italicized 23)
(define-modifier underline 4 #:cancel not-underlined)
(define-modifier not-underlined 24)
(define-modifier negative-image 7 #:cancel positive-image)
(define-modifier positive-image 27)
(define-modifier crossed-out 9 #:cancel not-crossed-out)
(define-modifier not-crossed-out 29)

(define-syntax inverse (make-rename-transformer #'negative-image))
(define-syntax strikethrough (make-rename-transformer #'crossed-out))

;; COLORS

(define-modifier foreground-default 39)
(define-modifier background-default 49)

(define-color-definer define-color foreground-default background-default)

(define-color black 0)
(define-color red 1)
(define-color green 2)
(define-color yellow 3)
(define-color blue 4)
(define-color magenta 5)
(define-color cyan 6)
(define-color white 7)
