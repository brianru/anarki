; Finite State Machine Library
;     by Brian J Rubinton
; 
; based on http://cs.brown.edu/~sk/Publications/Papers/Published/sk-automata-macros/paper.pdf
; with help from the Arc Community: http://arclanguage.org/item?id=17916
;
; Features
;
;   1 - Explicit accept and reject transitions.
;   2 - States with functions.
;   3 - "defaut" convenience macro
;   4 - Compatible with lazy streams
;
; (automaton init
;            ((init init-body
;               (c more))
;             (more more-body
;               (a more)
;               (d more)
;               (r end))
;             (end  end-body
;               accept))) 
;
; (defaut m init
;           ((init (c more))
;            (more (a more)
;                  (d more)
;                  (r end))
;            (end  accept)))


; hard-coded example
(= m1
   (withr (init (fn (str)
                  (if (empty str)
                    t
                    (case (car str) 
                      c (more (cdr str)))))
           more (fn (str)
                  (if (empty str)
                    t
                    (case (car str)
                      a (more (cdr str))
                      d (more (cdr str))
                      r (end  (cdr str)))))
           end  (fn (str)
                  (if (empty str)
                    t
                    (case (car str)
                      t nil))))
     init))

(= m2 (withr/p ((init (fn (str)
                        (init-body)
                        (case (car str) ; (car str) == nil is handled by case definition
                          c (more (cdr str)))))
                (more (fn (str)
                        (more-body)
                        (case (car str)
                          a (more (cdr str))
                          d (more (cdr str))
                          r (end  (cdr str)))))
                (end  (fn (str)
                        (end-body)
                        (case (car str)
                          nil t))))))

; examples:
; (m1 '(c a d a d d r)) -> t
; (m1 '(c a d a d d r r)) -> nil

; call:
;   (mktransition '(a more)
; expansion:
;   (a (more (cdr str)))
(def mktn (tn) (if (is tn 'accept)    (list nil t)
                   (is type.tn 'cons) (list car.tn (list last.tn '(cdr str)))))

; call:
;   (mktransitions '((a more) (d more) (r end)))
; expansion:
;   (a (more (cdr str))
;    d (more (cdr str))
;    r (end  (cdr str)))
(def mktransitions (ts)
  (accum accfn ; accum helps splice the result of mktransition
    (each x (map1 mktn ts)
      (accfn (car x))
      (accfn (last x)))))

; call:
;   (mkrule '(more (a more) (d more) (r end)))
; expansion:
;   more (fn (str)
;          (if (empty str) t
;            (case (car str)
;              a (more (cdr str))
;              d (more (cdr str))
;              r (end  (cdr str)))))
(def mkrule (r)
  (let i r
    (list (car i) `(fn (str)
                     (case (car str)
                       ,@(mktransitions (cdr i)))))))
; call:
;   (automaton init
;              ((init (c more))
;               (more (a more)
;                     (d more)
;                     (r end))
;               (end)))
(mac automaton (i r) `(withr/p ,(map1 [mkrule _] r) ,i))

(mac defaut (n i r) `(= ,n (automaton ,i ,r))) 


; thoughts on lazy evaluation:
; str is a lazy list of states of resource
; at each state there is an action
; the action updates the rsrc
; the fsm takes the next state from the str
; the next state is lazily computed using rsrc at that time
