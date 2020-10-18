#lang racket

(provide (prefix-out ansi- (all-defined-out)))

(require "private/syntax.rkt")

;; MODIFIERS

(define-modifier normal-intensity 22)
(define-modifier reset 0)
(define-modifier bold 1 #:cancel normal-intensity)
(define-modifier dim 2 #:cancel normal-intensity)
(define-modifier italic 3 #:cancel not-italicized)
(define-modifier not-italicized 23)
(define-modifier underline 4 #:cancel not-underlined)
(define-modifier not-underlined 24)
(define-modifier negative-image 7 #:cancel positive-image #:alias inverse)
(define-modifier positive-image 27)
(define-modifier crossed-out 9 #:cancel not-crossed-out #:alias strikethrough)
(define-modifier not-crossed-out 29)

;; COLORS

(define-color-definer define-color 39 49)

(define-color black 0)
(define-color red 1)
(define-color green 2)
(define-color yellow 3)
(define-color blue 4)
(define-color magenta 5)
(define-color cyan 6)
(define-color white 7)
