# nor.scm

This Scheme (Racket) program demonstrates that the truth function **logical NOR**(↓) is functionally complete, namely, that any binary truth function **f: {0,1}×{0,1}→{0,1}** is given by a composition just of **NOR**.

## Description

The higher-order function `truth-func`, constructed with only **NOR**, take six arguments `map-11`, `map-10`, `map-01`, `map-00`, `x`, `y`, where the function `map-xy` is composed just of **NOR** and `x`, `y` are truth values, and return the binary truth function which value of arguments **(x, y)** is equal to the `(map-xy x y)`. So, if a `func-imply` is defined as below:

```
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
```

where the `map-xy-z` maps truth values **(x, y)** to **z**, then the `func-imply` turns out to be the **logical IMP**(⇒) itself. In fact,

```
(func-imply #t #t)
(func-imply #t #f)
(func-imply #f #t)
(func-imply #f #f)
```

outputs

```
#t
#f
#t
#t
```
