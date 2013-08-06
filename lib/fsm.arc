; Finite State Machine Library
;     by Brian J Rubinton
; 
; based on http://cs.brown.edu/~sk/Publications/Papers/Published/sk-automata-macros/paper.pdf
; with help from the Arc Community: http://arclanguage.org/item?id=17916
;
; Features
;
;   1 - Explicit accept and todo reject transitions.
;                                simplest possible kill method
;   2 - States with functions.
;   3 - "defaut" convenience macro
;   4 - Compatible with lazy streams
;
; (automaton init
;            ((init (prn "init!")
;               (c more))
;             (more (prn "more")
;               (a more)
;               (d more)
;               (r end))
;             (end  (prn "no more!")
;               accept))) 
; i : symbol
; rs: list of elts, each elt r...
; r : (list symbol expr . cons)
;
; hard-coded example
;(= m1 (withr/p ((init (fn (str)
;                        (init-body)
;                        (case (car str) 
;                          c (more (cdr str)))))
;                (more (fn (str)
;                        (more-body)
;                        (case (car str)
;                          a (more (cdr str))
;                          d (more (cdr str))
;                          r (end  (cdr str)))))
;                (end  (fn (str)
;                        (end-body)
;                        (case (car str)
;                          nil t))))))

; examples:
; (m1 '(c a d a d d r)) -> t
; (m1 '(c a d a d d r r)) -> nil

; call:
;   (mktransition '(a more)
; expansion:
;   (a (more (cdr str)))
(def mktn (tn)
  (if (is tn 'accept)    (list nil t)
      (is type.tn 'cons) (list car.tn (list last.tn '(cdr str)))))

; call:
;   (mktns '((a more) (d more) (r end)))
; expansion:
;   (a (more (cdr str))
;    d (more (cdr str))
;    r (end  (cdr str)))
(def mktns (tns)
  (accum accfn ; accum helps splice the result of mktransition
    (each x (map1 mktn tns)
      (accfn (car x))
      (accfn (last x)))))

(def mkrule (r)
  "r : (list state expr . transitions)"
  (let i r
    (list (car i) `(fn (str)
                     ,(cadr i)
                     (case (car str)
                       ,@(mktns (cddr i)))))))

(mac automaton (i rs) `(withr/p ,(map1 [mkrule _] rs) ,i))
  "i: initial state; rs: (list rules)"

(mac defaut (n i rs) `(= ,n (automaton ,i ,rs))) 

; thoughts on lazy evaluation:
; str is a lazy list of states of resource
; at each state there is an action
; the action updates the rsrc
; the fsm takes the next state from the str
; the next state is lazily computed using rsrc at that time
