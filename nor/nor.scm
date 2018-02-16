#lang racket


;; We assume f: {0,1}x{0,1}->{0,1} to be any binary truth function.
;; We also regard the 0 (resp. 1) as the truth value #f (resp. #t), in the following.

;; <definition of truth function NOR>
(define func-nor
  (lambda (x y)
    (if (eqv? x #f)
      (if (eqv? y #f)
        #t
        #f
      )
      #f
    )
  )
)

;; <definitions of map-xy-z's>
;; If (x, y) = (a, b) and f(a, b) = c, then the (map-ab-c x y) returns c, for all a, b in {0,1}.
;; A map-xy-1 is given by the (func-nor (map-xy-0 x y) (map-xy-0 x y)).
(define map-11-0
  (lambda (x y)
    (func-nor x x)
  )
)
(define map-10-0
  (lambda (x y)
    y
  )
)
(define map-01-0
  (lambda (x y)
    x
  )
)
(define map-00-0
  (lambda (x y)
    x
  )
)
(define map-11-1
  (lambda (x y)
    (func-nor (map-11-0 x y) (map-11-0 x y))
  )
)
(define map-10-1
  (lambda (x y)
    (func-nor (map-10-0 x y) (map-10-0 x y))
  )
)
(define map-01-1
  (lambda (x y)
    (func-nor (map-01-0 x y) (map-01-0 x y))
  )
)
(define map-00-1
  (lambda (x y)
    (func-nor (map-00-0 x y) (map-00-0 x y))
  )
)

;; <definitions of are-xy's>
;; (x, y) = (a, b) iff the value of (are-ab x y) equal to #t.
(define are-11
  (lambda (x y)
    (func-nor (func-nor x x) (func-nor y y))
  )
)
(define are-10
  (lambda (x y)
    (func-nor (func-nor x x) y)
  )
)
(define are-01
  (lambda (x y)
    (func-nor x (func-nor y y))
  )
)
(define are-00
  (lambda (x y)
    (func-nor x y)
  )
)

;; <definition of conditional branch>
;; If the x is #t, the value of (if-else x y z) equal to y, and if the x is #f, it equal to z.
;; Remark that (if-else x y z) = 1 iff (x = 1 & y = 1) or (x = 0 & z = 1).
;; Therefore, (if-else x y z) = 1 iff (func-nor (x-is-1-and-y-is-1 x y) (x-is-0-and-z-is-1 x z)) = 0.
(define x-is-1-and-y-is-1
  (lambda (x y)
    (func-nor
      (func-nor x x)
      (func-nor (func-nor (func-nor x x) (func-nor y y)) (func-nor (func-nor x x) (func-nor y y)))
    )
  )
)
(define x-is-0-and-z-is-1
  (lambda (x z)
    (func-nor
      x
      (func-nor (func-nor x (func-nor z z)) (func-nor x (func-nor z z)))
    )
  )
)
(define if-else
  (lambda (x y z)
    (func-nor
      (func-nor (x-is-1-and-y-is-1 x y) (x-is-0-and-z-is-1 x z))
      (func-nor (x-is-1-and-y-is-1 x y) (x-is-0-and-z-is-1 x z))
    )
  )
)

;; <definition of (meta) truth function>
;; The truth function f is emulated by (truth-func map-11-a map-10-b map-01-c map-00-d x y), if
;;   f(1, 1) = a and
;;   f(1, 0) = b and
;;   f(0, 1) = c and
;;   f(0, 0) = d.
(define truth-func
  (lambda (map-11 map-10 map-01 map-00 x y)
    (if-else (are-11 x y)
      (map-11 x y)
      (if-else (are-10 x y)
        (map-10 x y)
        (if-else (are-01 x y)
          (map-01 x y)
          (map-00 x y)
        )
      )
    )
  )
)


;; <examples of some concrete truth functions>

;; (func-imply #t #t) -> #t
;; (func-imply #t #f) -> #f
;; (func-imply #f #t) -> #t
;; (func-imply #f #f) -> #t
(define func-imply
  (lambda (x y)
    (truth-func
      map-11-1
      map-10-0
      map-01-1
      map-00-1
    x y)
  )
)
;; (func-or #t #t) -> #t
;; (func-or #t #f) -> #t
;; (func-or #f #t) -> #t
;; (func-or #f #f) -> #f
(define func-or
  (lambda (x y)
    (truth-func
      map-11-1
      map-10-1
      map-01-1
      map-00-0
    x y)
  )
)
;; (func-contra #t #t) -> #f
;; (func-contra #t #f) -> #f
;; (func-contra #f #t) -> #f
;; (func-contra #f #f) -> #f
(define func-contra
  (lambda (x y)
    (truth-func
      map-11-0
      map-10-0
      map-01-0
      map-00-0
    x y)
  )
)
